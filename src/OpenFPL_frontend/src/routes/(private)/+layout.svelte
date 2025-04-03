<script lang="ts">
    import type { Snippet } from 'svelte';
    import { browser } from '$app/environment';
    import { goto } from '$app/navigation';
    import { authSignedInStore } from '$lib/derived/auth.derived';
    import { storeManager } from '$lib/managers/store-manager';
    import { appStore } from '$lib/stores/app-store';
    import { userStore } from '$lib/stores/user-store';
    import FullScreenSpinner from '$lib/components/shared/full-screen-spinner.svelte';
  
    interface Props {
      children: Snippet;
    }
    let { children }: Props = $props();

    const init = async () => await Promise.all([storeManager.syncStores(), appStore.checkServerVersion(), userStore.sync()]);

    $effect(() => {
      if (browser && !$authSignedInStore) {
        goto('/', { replaceState: true });
      }
    });
</script>

{#await init()}
  <FullScreenSpinner />
{:then}
  {@render children()}
{/await}