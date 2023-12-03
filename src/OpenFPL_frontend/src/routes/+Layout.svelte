<script lang="ts">
	import { browser } from '$app/environment';
	import { authStore, type AuthStoreData } from '$lib/stores/auth.store';
	import { onMount } from 'svelte';
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
  import Toast from "$lib/components/toast.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
	import { fade } from 'svelte/transition';
  import "../app.css";
  
  import { toastStore } from '$lib/stores/toast-store';
	import { initAuthWorker } from '$lib/services/worker.auth.services';

	const init = async () => await Promise.all([syncAuthStore()]);

	const syncAuthStore = async () => {
		if (!browser) {
			return;
		}

		try {
			await authStore.sync();
		} catch (err: unknown) {
			toastStore.show("Unexpected error syncing authentication.", "error");
		}
	};
  
	  
  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;
	  
  onMount(async () => (worker = await initAuthWorker()));

  $: worker, $authStore, (() => worker?.syncAuthIdle($authStore))();

  $: (() => {
    if (!browser) {
      return;
    }

    if ($authStore === undefined) {
      return;
    }

    const spinner = document.querySelector('body > #app-spinner');
      spinner?.remove();
  })();

</script>

<svelte:window on:storage={syncAuthStore} />
{#await init()}
  <div in:fade class="loading-overlay">
    <LoadingIcon />
  </div>
{:then _}
  <div class="flex flex-col h-screen justify-between">
    <Header />
    <main>
      <slot />
    </main>
    <Toast />
    <Footer />
  </div>
{/await}

<style>
  .loading-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 10;
  }

  main {
    flex: 1;
    display: flex;
    flex-direction: column;
  }
</style>
