<script lang="ts">
  import { onMount } from "svelte";
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";
  import { authStore, type AuthStoreData } from "$lib/stores/auth.store";
  import { toastsError } from "$lib/stores/toasts-store";
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
  import "../app.css";

  import { BusyScreen, Spinner, Toasts } from "@dfinity/gix-components";
  import { initAuthWorker } from "$lib/services/worker.auth.services";

  const init = async () => await Promise.all([syncAuthStore()]);

  const syncAuthStore = async () => {
    if (!browser) {
      return;
    }

    try {
      await authStore.sync();
    } catch (err: unknown) {
      toastsError({
        msg: {
          text: "Unexpected issue while syncing the status of your authentication.",
        },
        err,
      });
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

    const spinner = document.querySelector("body > #app-spinner");
    spinner?.remove();
  })();
</script>

<svelte:window on:storage={syncAuthStore} />
{#await init()}
  <div in:fade>
    <Spinner />
  </div>
{:then _}
  <div class="flex flex-col h-screen justify-between default-text">
    <Header />
    <main class="page-wrapper">
      <slot />
    </main>
    <Toasts />
    <Footer />
  </div>
{/await}

<BusyScreen />

<style>
  main {
    flex: 1;
    display: flex;
    flex-direction: column;
  }
</style>
