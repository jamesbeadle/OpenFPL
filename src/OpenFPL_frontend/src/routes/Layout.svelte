<script lang="ts">
  import { onMount } from "svelte"; 
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";
  import { page } from "$app/state";

  import { userStore } from "$lib/stores/user-store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthStoreData } from "$lib/stores/auth.store";
  
  import "../app.css";
  import Toasts from "$lib/components/toasts/toasts.svelte";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { toasts } from "$lib/stores/toasts-store";
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";
  import { storeManager } from "$lib/managers/store-manager";
  import { appStore } from "$lib/stores/app-store";
  import CreateNewUser from "$lib/components/profile/create-new-user.svelte";
  import LandingPage from "$lib/components/landing/landing-page.svelte";
  import InvalidMembershipPage from "$lib/components/profile/invalid-membership-page.svelte";
  import type { ICFCMembershipDTO } from "../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;

  let isLoading = true;
  let hasProfile = false;
  let hasValidMembership = false;
  let membership: ICFCMembershipDTO | undefined = undefined;

  const init = async () => {
    await syncAuthStore();
    worker = await initAuthWorker();
    await appStore.checkServerVersion();
    await storeManager.syncStores();
    membership = await userStore.getUserIFCFMembership();
    if(membership){
      hasValidMembership = 
        Object.keys(membership.membershipType)[0] == 'Founding' || 
        Object.keys(membership.membershipType)[0] == 'Seasonal' || 
        Object.keys(membership.membershipType)[0] == 'Lifetime' || 
        Object.keys(membership.membershipType)[0] == 'Monthly'
    }
  };

  const syncAuthStore = async (retryCount = 0, maxRetries = 3) => {
    if (!browser) return;

    try {
      isLoading = true;
      await authStore.sync();
      
      if (!$authSignedInStore) {
        hasProfile = false;
        isLoading = false;
        return;
      }

      let profile = $userStore;

      if (!profile && retryCount < maxRetries) {
        await new Promise(resolve => setTimeout(resolve, 1000));
        return syncAuthStore(retryCount + 1, maxRetries);
      }

      hasProfile = !!profile;
      isLoading = false;
    } catch (err: unknown) {
      console.error("Error syncing auth store:", err);
      toasts.addToast({ 
        message: "Unexpected issue while syncing the status of your authentication.",
        type: "error" 
      });
      isLoading = false;
    }
  };

  const handleStorageEvent = (event: StorageEvent) => {
    syncAuthStore();
  };

  onMount(async () => {
    await init();
  });

  $: if (browser && $authSignedInStore) {
    syncAuthStore();
  }

  $: if (worker && $authStore) {
    worker.syncAuthIdle($authStore);
  }

  $: if (browser && $authStore !== undefined) {
    document.querySelector("body > #app-spinner")?.remove();
  }

  let currentPathname = '';
  $: if (browser && page.url) {
    if (page.url.pathname !== currentPathname) {
      currentPathname = page.url.pathname;
      syncAuthStore();
    }
  }

  $: isWhitepaper = browser && page.url.pathname === "/whitepaper";

  function handleProfileCreated() {
    hasProfile = true;
    isLoading = false;
  }

  async function onLogout() {
    isLoading = true;
    await authStore.signOut();
    userStore.set(undefined);
    isLoading = false;
  }
</script>

<svelte:window on:storage={handleStorageEvent} />

{#await init()}
  <div in:fade>
    <FullScreenSpinner />
  </div>
{:then _}
  <div class="flex w-full h-screen">
    {#if isLoading}
      <FullScreenSpinner />
    {:else if $authSignedInStore && hasProfile && !hasValidMembership}
      <InvalidMembershipPage />
    {:else if $authSignedInStore && hasProfile && hasValidMembership}
      <Header {onLogout} />
      <main class="page-wrapper">
        <slot />
      </main>
      <Footer />
    {:else if $authSignedInStore && !hasProfile}
      <CreateNewUser on:profileCreated={handleProfileCreated} {membership} />
    {:else}
      <LandingPage />
    {/if}
    <Toasts />
  </div>
{/await}