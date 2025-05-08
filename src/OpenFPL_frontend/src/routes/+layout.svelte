<script lang="ts">
  import { onMount, type Snippet } from "svelte";   
  import { browser } from "$app/environment";
  import { fade } from "svelte/transition";
  
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthStoreData } from "$lib/stores/auth-store";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { displayAndCleanLogoutMsg } from "$lib/services/auth-services";

  import FullScreenSpinner from "$lib/components/shared/global/full-screen-spinner.svelte";
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
  import Sidebar from "$lib/shared/sidebar.svelte";
  import Toasts from "$lib/components/shared/toasts/toasts.svelte";
  import LandingPage from "$lib/components/landing/landing-page.svelte";
  import InvalidMembershipPage from "$lib/components/profile/membership/invalid-membership-page.svelte";
  
  import { userStore } from "$lib/stores/user-store";
  import { checkValidMembership } from "$lib/utils/Helpers";
  import "../app.css";
  
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;
  
  interface Props { children: Snippet }
  let { children }: Props = $props();
    
  let isLoading = $state(true);
  let isMenuOpen = $state(false);
  
  let loadingMessage = $state("");
  let hasValidMembership = $state(false);

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
    const identity = $authStore.identity;
    worker = await initAuthWorker();
    if (identity) {
      try {
        await checkProfile();
      } catch (err) {
        console.error('initUserProfile error:', err);
      }
    }
    isLoading = false;
  });

  async function checkProfile() {
      let i = 1;
      isLoading = true;
      try {
          if (!$authSignedInStore) return;
          loadingMessage = "Searching for Profile";
          await userStore.sync();
          hasValidMembership = checkValidMembership($userStore.membershipType);
      } catch (error) {
          loadingMessage = "Profile not found";
          console.error('Error fetching user profile:', error);
          hasValidMembership = false;
      } finally {
          isLoading = false;
      }
      i++;
  }

  function toggleMenu() {
      isMenuOpen = !isMenuOpen;
  }
</script>

<svelte:window on:storage={authStore.sync} />

{#if isLoading}
  <div in:fade>
    <FullScreenSpinner message={loadingMessage} />
  </div>
{/if}

{#if !isLoading && !$authSignedInStore}
  <LandingPage />
{/if}

{#if !isLoading && $authSignedInStore}
    <Header {toggleMenu} />  
    <Sidebar {isMenuOpen} {toggleMenu} />
{/if}

{#if !isLoading && $authSignedInStore && hasValidMembership}
  <div class="flex flex-col min-h-screen">
    <main class="flex-grow page-wrapper">
        {@render children()}
    </main>
    <Footer />
  </div>
{/if}

{#if !isLoading && $authSignedInStore && !hasValidMembership}
  <InvalidMembershipPage />
{/if}

<Toasts />