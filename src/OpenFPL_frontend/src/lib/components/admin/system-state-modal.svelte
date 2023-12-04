<script lang="ts">
  import { onMount } from "svelte";
  import { systemStore } from "$lib/stores/system-store";
  import { authIsAdmin } from "$lib/derived/auth.derived";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import type { UpdateSystemStateDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { Modal } from "@dfinity/gix-components";

  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;

  let activeGameweek = $systemStore?.activeGameweek ?? 1;
  let focusGameweek = $systemStore?.focusGameweek ?? 1;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);

  let isLoading = true;

  onMount(async () => {
    await systemStore.sync();
  });

  async function updateSystemState() {
    isLoading = true;
    try {
      let newSystemState: UpdateSystemStateDTO = {
        activeGameweek: activeGameweek,
        focusGameweek: focusGameweek,
      };
      await systemStore.updateSystemState(newSystemState);
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
    <div class="mt-3">
      <h3 class="text-lg leading-6 font-medium mb-2">Update System State</h3>
      <form on:submit|preventDefault={updateSystemState}>
        <div class="mt-4 flex flex-col space-y-2">
          <h5>Active Gameweek</h5>
          <select
            bind:value={activeGameweek}
            class="w-full p-2 rounded-md fpl-dropdown"
          >
            {#each gameweeks as gameweek}
              <option value={gameweek}>Gameweek {gameweek}</option>
            {/each}
          </select>

          <h5>Focus Gameweek</h5>
          <select
            bind:value={focusGameweek}
            class="w-full p-2 rounded-md fpl-dropdown"
          >
            {#each gameweeks as gameweek}
              <option value={gameweek}>Gameweek {gameweek}</option>
            {/each}
          </select>
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
              !$authIsAdmin ? "bg-gray-500" : "fpl-purple-btn"
            } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
            type="submit"
            disabled={!$authIsAdmin}
          >
            Update
          </button>
        </div>
      </form>
    </div>
  </div>
</Modal>
