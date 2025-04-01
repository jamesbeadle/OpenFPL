<script lang="ts">
  import { onMount, type Snippet } from "svelte"; 
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";
  import { page } from "$app/state";
  import { get } from "svelte/store";
  import { userStore } from "$lib/stores/user-store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthStoreData } from "$lib/stores/auth-store";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { toasts } from "$lib/stores/toasts-store";
  import { storeManager } from "$lib/managers/store-manager";
  import { appStore } from "$lib/stores/app-store";
  import { displayAndCleanLogoutMsg } from "$lib/services/auth.services";
  
  import "../app.css";
  import Toasts from "$lib/components/toasts/toasts.svelte";
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";

  import CreateNewUser from "$lib/components/profile/membership-profile.svelte";
  import LandingPage from "$lib/components/landing/landing-page.svelte";
  import InvalidMembershipPage from "$lib/components/profile/invalid-membership-page.svelte";
  //import type { ICFCMembershipDTO } from "../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  import MembershipProfile from "$lib/components/profile/membership-profile.svelte";
    
  interface Props { children: Snippet }
  let { children }: Props = $props();
    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;
  let isLoading = $state(true);

  const init = async () => {
    if (!browser) return;
    await authStore.sync();
    displayAndCleanLogoutMsg();
  };

  onMount(async () => {
    if (browser) {
      document.querySelector('#app-spinner')?.remove();
    }
    await init();
    const identity = get(authStore).identity;
    if (identity) {
      try {
        await initUserProfile({ identity });
      } catch (err) {
        console.error('initUserProfile error:', err);
      }
    }
    worker = await initAuthWorker();
    isLoading = false;
  });

  async function onLogout() {
    isLoading = true;
    await authStore.signOut();
    userStore.set(undefined);
    isLoading = false;
  }

  let hasProfile = false;
  let hasValidMembership = false;
  //let membership: ICFCMembershipDTO | undefined = undefined;

  /*
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


  */
</script>

<svelte:window on:storage={authStore.sync} />

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
        {@render children()}
      </main>
      <Footer />
    {:else if $authSignedInStore && !hasProfile}
      <MembershipProfile {membership} />
    {:else}
      <LandingPage />
    {/if}
    <Toasts />
  </div>
{/await}