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

  let pickTeamSeasonId: number;
  let pickTeamGameweek: number;
  let calculationGameweek: number;
  let transferWindowActive: boolean;
  let calculationMonth: number;
  let calculationSeasonId: number;
  let onHold: boolean;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);

  let isLoading = true;

  onMount(async () => {
    await systemStore.sync();
    calculationGameweek = $systemStore?.calculationGameweek ?? 1;
    pickTeamGameweek = $systemStore?.pickTeamGameweek ?? 1;
  });

  async function updateSystemState() {
    isLoading = true;
    try {
      let newSystemState: UpdateSystemStateDTO = {
        pickTeamSeasonId: pickTeamSeasonId,
        calculationGameweek: calculationGameweek,
        transferWindowActive: transferWindowActive,
        pickTeamGameweek: pickTeamGameweek,
        calculationMonth: calculationMonth,
        calculationSeasonId: calculationSeasonId,
        onHold: onHold,
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
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Update System State</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <form on:submit|preventDefault={updateSystemState}>
      <div class="mt-4 flex flex-col space-y-2">
        <h5>Calculation Gameweek</h5>
        <select
          bind:value={calculationGameweek}
          class="w-full p-2 rounded-md fpl-dropdown"
        >
          {#each gameweeks as gameweek}
            <option value={gameweek}>Gameweek {gameweek}</option>
          {/each}
        </select>

        <h5>Pick Team Gameweek</h5>
        <select
          bind:value={pickTeamGameweek}
          class="w-full p-2 rounded-md fpl-dropdown"
        >
          {#each gameweeks as gameweek}
            <option value={gameweek}>Gameweek {gameweek}</option>
          {/each}
        </select>
      </div>
      <div class="items-center py-3 flex space-x-4">
        <button
          class="default-button fpl-cancel-btn"
          type="button"
          on:click={cancelModal}
        >
          Cancel
        </button>
        <button
          class={`px-4 py-2 ${
            !$authIsAdmin ? "bg-gray-500" : "fpl-purple-btn"
          } default-button fpl-purple-btn`}
          type="submit"
          disabled={!$authIsAdmin}
        >
          Update
        </button>
      </div>
    </form>
  </div>
</Modal>
