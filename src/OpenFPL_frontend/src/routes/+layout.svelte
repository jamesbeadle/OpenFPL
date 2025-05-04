<script lang="ts">
  import { onMount, type Snippet } from "svelte"; 
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";
  import { get } from "svelte/store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthStoreData } from "$lib/stores/auth-store";
  import { initUserProfile } from "$lib/services/user-profile-service";
  import { displayAndCleanLogoutMsg } from "$lib/services/auth-services";
  
  import PortalHost from 'svelte-portal';
  import LayoutController from "$lib/components/profile/layout-controller.svelte";
  import FullScreenSpinner from "$lib/components/shared/global/full-screen-spinner.svelte";
  import Toasts from "$lib/components/shared/toasts/toasts.svelte";
  import "../app.css";

  interface Props { children: Snippet }
  let { children }: Props = $props();
    
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;
  let isLoading = $state(true);
  let loadingMessage = $state("");

  const init = async () => {
    if (!browser) return;
    await authStore.sync();
    displayAndCleanLogoutMsg();
  };

  onMount(async () => {
    console.log("mounting")
    if (browser) {
      document.querySelector('#app-spinner')?.remove();
    }
    await init();
    const identity = get(authStore).identity;
    if (identity) {
      try {
        loadingMessage = "Initalizing User Layout";
        await initUserProfile({ identity });
        console.log("Finished initUserProfile")
      } catch (err) {
        console.error('initUserProfile error:', err);
      }
    }
    worker = await initAuthWorker();
    isLoading = false;
  });
</script>

<svelte:window on:storage={authStore.sync} />

{#if browser && isLoading}
<div in:fade>
  <FullScreenSpinner message={loadingMessage} />
</div>
{:else}
  <LayoutController>
    {@render children()}
  </LayoutController>
  <Toasts />
  <PortalHost />
{/if}