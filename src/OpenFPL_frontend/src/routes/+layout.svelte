<script lang="ts">
  import { onMount, type Snippet } from "svelte"; 
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";
  import { get } from "svelte/store";
  import { userStore } from "$lib/stores/user-store";
  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { authStore, type AuthStoreData } from "$lib/stores/auth-store";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { toasts } from "$lib/stores/toasts-store";
  import { storeManager } from "$lib/managers/store-manager";
  import { appStore } from "$lib/stores/app-store";
  import { initUserProfile } from "$lib/services/user-profile-service";
  import { displayAndCleanLogoutMsg } from "$lib/services/auth-services";
  
  import "../app.css";
  import Toasts from "$lib/components/toasts/toasts.svelte";
  import PortalHost from 'svelte-portal';
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";
  import LayoutController from "$lib/components/profile/layout-controller.svelte";

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
</script>

<svelte:window on:storage={authStore.sync} />

{#if browser && isLoading}
<div in:fade>
  <FullScreenSpinner />
</div>
{:else}
  <LayoutController>
    {@render children()}
  </LayoutController>
  <Toasts />
  <PortalHost />
{/if}