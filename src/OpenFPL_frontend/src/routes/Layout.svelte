<script lang="ts">

  import { onMount} from "svelte";
  import { goto } from "$app/navigation";
  import { fade } from "svelte/transition";
  import { browser } from "$app/environment";
  import { authStore, type AuthStoreData } from "$lib/stores/auth.store";
  import { userStore } from "$lib/stores/user-store";
  
  import Header from "$lib/shared/Header.svelte";
  import Footer from "$lib/shared/Footer.svelte";
  import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
  import "../app.css";

  import { initAuthWorker } from "$lib/services/worker.auth.services";
  import { storeManager} from "$lib/managers/store-manager";
  import { toasts } from "$lib/stores/toasts-store";
  import Toasts from "$lib/components/toasts/toasts.svelte";
  import NewUserModal from "$lib/components/profile/new-user-modal.svelte";
  import { appStore } from "$lib/stores/app-store";

  import { createDeferred, type Deferred } from "$lib/utils/helpers";

  export let showHeader = true;

  let isLoading = true;
  let showNewUserModal = false;
  let hasStartedSync = false;
  let hasSynced = false;
  let userSignUpDeferred: Deferred<void> | null = null;

  const init = async () => {
    await Promise.all([syncAuthStore()]);
    worker = await initAuthWorker();
  };

  const syncAuthStore = async () => {
    if (!browser) { return; }

    try {
      await authStore.sync();
    } catch (err: unknown) {
      toasts.addToast( { message: "Unexpected issue while syncing the status of your authentication.",
      type: "error" });
    }
  };

  let worker: { syncAuthIdle: (auth: AuthStoreData) => void } | undefined;

  onMount(async () => {
    worker = await initAuthWorker();
    await storeManager.syncStores();
    isLoading = false;
  });

  async function onUserSignUpComplete() {
    if (userSignUpDeferred) {
      userSignUpDeferred.resolve();
      userSignUpDeferred = null;
      await syncPage();
    }
  }

  async function onLogout() {
    await authStore.signOut();
    userStore.set(undefined);
    hasSynced = false;
    hasStartedSync = false;
    userSignUpDeferred = null;
    showNewUserModal = false;
    isLoading = false;
  }

  async function syncPage() {
    isLoading = true;
    try {
        await storeManager.syncStores();
        await appStore.checkServerVersion();
        hasSynced = true;
        isLoading = false;
    } catch (error) {
        console.error('[Layout] Error in syncPage:', error);
        isLoading = false;
    }
  }
  
  $: if ($authStore?.identity && !hasSynced && !hasStartedSync && !isLoading) {
    hasStartedSync = true;
    (async () => {
      try {
        await userStore.sync();
        if ($userStore === undefined) {
          showNewUserModal = true;
          userSignUpDeferred = createDeferred<void>();
          await userSignUpDeferred.promise;
        }
        else {
          await syncPage();
        }
      } catch (error) {
        console.error("Error syncing user store:", error);
      }
    })();
  }

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
    <WidgetSpinner />
  </div>
{:then _}
  <div class="flex flex-col justify-between h-screen default-text ${showHeader ? 'bg-background' : ''}">
    {#if showHeader}
      <Header onLogout={onLogout} />
      <main class="page-wrapper">
        <slot />
      </main>
      <Footer />
    {:else}
      <main class="flex-1">
        <slot />
      </main>
    {/if}
    <Toasts />
    {#if showNewUserModal}
      <NewUserModal visible={true} onSignUpComplete={onUserSignUpComplete} onLogout={onLogout} />
    {/if}
  </div>
{/await}