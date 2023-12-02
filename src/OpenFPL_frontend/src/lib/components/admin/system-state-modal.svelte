<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { seasonStore } from "$lib/stores/season-store";
  import { systemStore } from "$lib/stores/system-store";
  import { authStore } from "$lib/stores/auth";
  import { toastStore } from "$lib/stores/toast-store";
  import type { Writable } from "svelte/store";
  import type {
    Season,
    SystemState,
    UpdateSystemStateDTO,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  export let showModal: boolean;
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
      toastStore.show("System State Updated.", "success");
    } catch (error) {
      toastStore.show("Error updating system state.", "error");
      console.error("Error updating system state:", error);
      cancelModal();
    } finally {
      isLoading = false;
    }
  }

  function handleKeydown(event: KeyboardEvent): void {
    if (!(event.target instanceof HTMLInputElement) && event.key === "Escape") {
      closeModal();
    }
  }
</script>

{#if showModal}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={cancelModal}
    on:keydown={handleKeydown}
  >
    <div
      class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
      on:click|stopPropagation
      on:keydown={handleKeydown}
    >
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
  </div>
{/if}

<style>
</style>
