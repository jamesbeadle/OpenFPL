<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { seasonStore } from "$lib/stores/season-store";
  import { systemStore } from "$lib/stores/system-store";
  import { authStore } from "$lib/stores/auth.store";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import type {
    Season,
    SystemState,
    UpdateSystemStateDTO,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { Modal } from "@dfinity/gix-components";

  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  let seasons: Season[] = [];
  let systemState: SystemState | null;

  let activeGameweek = 1;
  let activeSeasonId = 1;

  let unsubscribeSeasons: () => void;
  let unsubscribeSystemState: () => void;

  $: isSubmitDisabled =
    ($authStore.identity?.getPrincipal().toString() ?? "") !==
    "kydhj-2crf5-wwkao-msv4s-vbyvu-kkroq-apnyv-zykjk-r6oyk-ksodu-vqe";

  let isLoading = true;

  onMount(async () => {
    await authStore.sync();
    await seasonStore.sync();
    await systemStore.sync();

    unsubscribeSeasons = seasonStore.subscribe((value) => {
      seasons = value;
    });

    unsubscribeSystemState = systemStore.subscribe((value) => {
      systemState = value;
    });
  });

  onDestroy(() => {
    unsubscribeSeasons?.();
    unsubscribeSystemState?.();
  });

  async function updateSystemState() {
    isLoading = true;
    try {
      let systemState: UpdateSystemStateDTO = {
        activeGameweek: activeGameweek,
        activeSeasonId: activeSeasonId,
      };
      await systemStore.updateSystemState(systemState);
      systemStore.sync();
      await closeModal();
      toastsShow({
        text: "System State Updated.",
        level: "success",
        duration: 2000,
      });
    } catch (error) {
      toastsError({
        msg: { text: "Error updating system state." },
        err: error,
      });
      console.error("Error updating system state:", error);
      cancelModal();
    } finally {
      isLoading = false;
    }
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="bg-gray-900 p-4">
    <div class="mt-3 text-center">
      <h3 class="text-lg leading-6 font-medium mb-2">Update System State</h3>
      <form on:submit|preventDefault={updateSystemState}>
        <div class="mt-4">
          <!-- Dropdown for seasons -->

          <!-- Dropdown for active gameweeks -->

          <!-- Dropdown for focus gameweeks -->
        </div>
        <div class="items-center py-3 flex space-x-4">
          <button
            class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
            on:click={cancelModal}
          >
            Cancel
          </button>
          <button
            class={`px-4 py-2 ${
              isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"
            } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
            type="submit"
            disabled={isSubmitDisabled}
          >
            Update
          </button>
        </div>
      </form>
    </div>
  </div>
</Modal>
