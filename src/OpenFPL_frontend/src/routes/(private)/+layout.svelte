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

    const init = async () => {
        try {
            const results = await Promise.allSettled([
                storeManager.syncStores().catch(err => {
                    console.error('Store sync failed:', err);
                    return null;
                }),
                appStore.checkServerVersion().catch(err => {
                    console.error('Version check failed:', err);
                    return null;
                }),
                userStore.sync().catch(err => {
                    console.error('User sync failed:', err);
                    return null;
                })
            ]);

            const criticalFailure = results.every(result => 
                result.status === 'rejected' || result.value === null
            );
            
            if (criticalFailure) {
                throw new Error('All store initializations failed');
            }
        } catch (error) {
            console.error('Store initialization failed:', error);
            return Promise.reject(error);
        }
    };

    $effect(() => {
      if (browser && !$authSignedInStore) {
        goto('/', { replaceState: true });
      }
    });
</script>

{#await init()}
    <FullScreenSpinner message="Loading Layout" />
{:catch error}
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-900 error-container">
        <p class="mb-4 text-xl text-red-500">Failed to load application data</p>
        <p class="text-gray-400">Please try refreshing the page</p>
        <button 
            class="px-4 py-2 mt-4 text-white rounded bg-BrandGreen hover:bg-BrandGreen/80"
            onclick={() => window.location.reload()}
        >
            Refresh Page
        </button>
    </div>
{:then}
    {@render children()}
{/await}