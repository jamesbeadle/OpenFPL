<script lang="ts">
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import { Modal } from "@dfinity/gix-components";
  import { systemStore } from "$lib/stores/system-store";
  import { teamStore } from "$lib/stores/team-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import type {
    ClubDTO,
    FixtureDTO,
  } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  export let visible: boolean;
  export let closeModal: () => void;

  let gameweeks = Array.from({ length: Number(process.env.TOTAL_GAMEWEEKS) }, (_, i) => i + 1);
  let selectedGameweek: number = 1;
  let selectedFixtureId: number;
  let gameweekFixtures: FixtureDTO[] = [];

  $: isSubmitDisabled = !selectedFixtureId || selectedFixtureId <= 0;

  $: if (selectedFixtureId) {
    loadGameweekFixtures();
  }

  function loadGameweekFixtures() {
    gameweekFixtures = $fixtureStore.filter(
      (x) => x.gameweek == selectedGameweek
    );
  }

  let isLoading = true;

  onMount(async () => {
    try {
      await teamStore.sync();
      await systemStore.sync();
      await fixtureStore.sync($systemStore?.calculationSeasonId ?? 1);
      loadGameweekFixtures();
    } catch (error) {
      toastsError({
        msg: { text: "Error syncing proposal data." },
        err: error,
      });
      console.error("Error syncing proposal data.", error);
    } finally {
      isLoading = false;
    }
  });

  function getTeamById(teamId: number): ClubDTO {
    return $teamStore.find((x) => x.id === teamId)!;
  }

  async function selectFixure() {
    goto(`/add-fixture-data?id=${selectedFixtureId}`);
  }
</script>

<Modal {visible} on:nnsClose={closeModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Add Fixture Data</h3>
      <button class="times-button" on:click={closeModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full flex-col space-y-4 mb-2">
        <div class="flex-col space-y-2">
          <p>Select Gameweek:</p>
          <select
            class="p-2 fpl-dropdown my-4 min-w-[100px]"
            bind:value={selectedGameweek}
          >
            {#each gameweeks as gameweek}
              <option value={gameweek}>Gameweek {gameweek}</option>
            {/each}
          </select>
        </div>

        <div class="flex-col space-y-2">
          <p>Select Fixture:</p>
          <select
            class="p-2 fpl-dropdown my-4 min-w-[100px]"
            bind:value={selectedFixtureId}
          >
            {#each gameweekFixtures as fixture}
              {@const homeTeam = getTeamById(fixture.homeClubId)}
              {@const awayTeam = getTeamById(fixture.awayClubId)}
              <option value={fixture.id}
                >{homeTeam.friendlyName} v {awayTeam.friendlyName}</option
              >
            {/each}
          </select>
        </div>

        <div class="border-b border-gray-200" />

        <div class="items-center flex space-x-4">
          <button
            class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]"
            type="button"
            on:click={closeModal}
          >
            Cancel
          </button>
          <button
            class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`}
            on:click={selectFixure}
            disabled={isSubmitDisabled}
          >
            Add Fixture Data
          </button>
        </div>
      </div>
    </div>

    {#if isLoading}
      <LocalSpinner />
    {/if}
  </div>
</Modal>
