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
  import { systemStore } from "$lib/stores/system-store";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
    import { playerStore } from "$lib/stores/player-store";

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


  onMount(async () => {
    try {

      console.log(process.env)
      console.log("Mounting data stores.")
      await authStore.sync();
      await systemStore.sync();
      await teamStore.sync();
      await fixtureStore.sync($systemStore?.calculationSeasonId ?? 1);
      await playerStore.sync($systemStore?.calculationSeasonId ?? 1); 
      console.log("Data stores mounted.")
    } catch (error) {
      toastsError({
        msg: { text: "Error mounting application data." },
        err: error,
      });
      console.error("Error mounting application data:", error);
    } finally {
    }
  });

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
