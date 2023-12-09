<script lang="ts">
  import { onMount } from "svelte";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { authIsAdmin } from "$lib/derived/auth.derived";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import type {
    Fixture,
    UpdateFixtureDTO,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { Modal } from "@dfinity/gix-components";

  interface Status {
    id: number;
    description: string;
  }

  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  export let fixture: Fixture;

  let gameweek: number = fixture.gameweek;
  let kickOff: bigint = fixture.kickOff;
  let status: number = fixture.status;

  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);

  const statuses: Status[] = [
    { id: 0, description: "Unplayed" },
    { id: 1, description: "Active" },
    { id: 2, description: "Completed" },
    { id: 3, description: "Data Finalised" },
  ];

  let kickOffInput: string = "";

  let isLoading = true;

  function bigintToDateStr(kickOff: bigint): string {
    const date = new Date(Number(kickOff) / 1000000);
    return date.toISOString().slice(0, 16);
  }

  onMount(async () => {
    kickOffInput = bigintToDateStr(kickOff);
  });

  async function updateFixture() {
    isLoading = true;
    try {
      let updatedFixture: UpdateFixtureDTO = {
        gameweek,
        kickOff: convertToBigInt(kickOffInput),
        status,
        fixtureId: fixture.id,
        seasonId: fixture.seasonId,
      };
      await fixtureStore.updateFixture(updatedFixture);
      fixtureStore.sync();

      await closeModal();
      toastsShow({
        text: "Fixture Updated.",
        level: "success",
        duration: 2000,
      });
    } catch (error) {
      toastsError({
        msg: { text: "Error updating fixture." },
        err: error,
      });
      console.error("Error updating fixture:", error);
      cancelModal();
    } finally {
      isLoading = false;
    }
  }

  function convertToBigInt(dateString: string): bigint {
    const date = new Date(dateString);
    return BigInt(date.getTime()) * BigInt(1000000);
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Update Fixture</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <form on:submit|preventDefault={updateFixture}>
      <div class="mt-4 flex flex-col space-y-2">
        <h5>Fixture Gameweek</h5>
        <select
          bind:value={gameweek}
          class="w-full p-2 rounded-md fpl-dropdown"
        >
          {#each gameweeks as gameweek}
            <option value={gameweek}>Gameweek {gameweek}</option>
          {/each}
        </select>
      </div>

      <div class="mt-4 flex flex-col space-y-2">
        <h5>Fixture Status</h5>
        <select bind:value={status} class="w-full p-2 rounded-md fpl-dropdown">
          {#each statuses as status}
            <option value={status.id}>{status.description}</option>
          {/each}
        </select>
      </div>

      <div class="mt-4 flex flex-col space-y-2">
        <h5>Fixture Kick Off</h5>
        <input
          type="datetime-local"
          bind:value={kickOffInput}
          class="w-full p-2 rounded-md fpl-dropdown"
        />
      </div>

      <div class="items-center py-3 flex space-x-4">
        <button
          class="default-button fpl-cancel-btn"
          on:click={cancelModal}
        >
          Cancel
        </button>
        <button
          class={`px-4 py-2 ${!$authIsAdmin ? "bg-gray-500" : "fpl-purple-btn"} 
          text-white rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
          type="submit"
          disabled={!$authIsAdmin}
        >
          Update
        </button>
      </div>
    </form>
  </div>
</Modal>
