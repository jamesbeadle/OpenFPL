<script lang="ts">
  import { onMount } from "svelte";
  import { Modal } from "@dfinity/gix-components";
  import { teamStore } from "$lib/stores/club-store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import type {
    ClubDTO,
    FixtureDTO,
  } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { isError } from "$lib/utils/helpers";

  export let visible: boolean;
  export let closeModal: () => void;

  let gameweeks = Array.from({ length: Number(process.env.TOTAL_GAMEWEEKS) }, (_, i) => i + 1);
  let selectedGameweek: number = 0;
  let newGameweek: number = 0;
  let selectedFixtureId: number = 0;
  let gameweekFixtures: FixtureDTO[] = [];

  let date = "";
  let time = "";
  let dateTime = "";

  $: dateTime = date + "T" + time;

  $: isSubmitDisabled =
    !selectedFixtureId ||
    selectedFixtureId <= 0 ||
    newGameweek <= 0 ||
    date == "" ||
    time == "";

  $: if (selectedGameweek) {
    loadGameweekFixtures();
  }

  function loadGameweekFixtures() {
    gameweekFixtures = $fixtureStore.filter(
      (x) => x.gameweek == selectedGameweek
    );
  }

  let isLoading = true;
  let showConfirm = false;

  $: if (isSubmitDisabled && showConfirm) {
    showConfirm = false;
  }

  onMount(async () => {
    try {
      await systemStore.sync();
      await fixtureStore.sync($systemStore?.calculationSeasonId ?? 1);
      await teamStore.sync();
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

  function raiseProposal() {
    showConfirm = true;
  }

  async function confirmProposal() {
    isLoading = true;
    let result = await governanceStore.moveFixture(
      selectedFixtureId,
      newGameweek ?? 1,
      dateTime
    );
    if (isError(result)) {
      isLoading = false;
      toastsError({
        msg: { text: "Error submitting proposal." },
      });
      console.error("Error submitting proposal");
      return;
    }
    isLoading = false;
    resetForm();
    cancelModal();
  }

  function resetForm() {
    date = "";
    time = "";
    dateTime = "";
    newGameweek = 0;
    showConfirm = false;
  }

  function cancelModal() {
    resetForm();
    closeModal();
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Move Fixture</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full flex-col space-y-4 mb-2">
        <div class="flex-col space-y-2">
          <p>Select Gameweek:</p>
          <select
            class="p-2 fpl-dropdown my-4 min-w-[100px]"
            bind:value={selectedGameweek}
          >
            <option value={0}>Select Gameweek</option>
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
            <option value={0}>Select Fixture</option>
            {#each gameweekFixtures as fixture}
              {@const homeTeam = getTeamById(fixture.homeClubId)}
              {@const awayTeam = getTeamById(fixture.awayClubId)}
              <option value={fixture.id}
                >{homeTeam.friendlyName} v {awayTeam.friendlyName}</option
              >
            {/each}
          </select>
        </div>

        <div class="border-b border-gray-200 my-4" />
        <p class="mr-2 my-2">Set new date:</p>
        <div class="flex flex-row my-2">
          <p class="mr-2">Select Date:</p>
          <input type="date" bind:value={date} class="input input-bordered" />
        </div>
        <div class="flex flex-row my-2">
          <p class="mr-2">Select Time:</p>
          <input type="time" bind:value={time} class="input input-bordered" />
        </div>
        <div class="flex flex-row my-2 items-center">
          <p class="mr-2">Select Gameweek:</p>

          <select
            class="p-2 fpl-dropdown my-4 min-w-[100px]"
            bind:value={newGameweek}
          >
            <option value={0}>Select New Gameweek</option>
            {#each gameweeks as gameweek}
              <option value={gameweek}>Gameweek {gameweek}</option>
            {/each}
          </select>
        </div>

        <div class="border-b border-gray-200" />

        <div class="items-center flex space-x-4">
          <button
            class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]"
            type="button"
            on:click={cancelModal}
          >
            Cancel
          </button>
          <button
            class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`}
            on:click={raiseProposal}
            disabled={isSubmitDisabled}
          >
            Raise Proposal
          </button>
        </div>

        {#if showConfirm}
          <div class="items-center flex">
            <p class="text-orange-400">
              Failed proposals will cost the proposer 10 $FPL tokens.
            </p>
          </div>
          <div class="items-center flex">
            <button
              class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`}
              on:click={confirmProposal}
              disabled={isSubmitDisabled}
            >
              Confirm Submit Proposal
            </button>
          </div>
        {/if}
      </div>
    </div>

    {#if isLoading}
      <LocalSpinner />
    {/if}
  </div>
</Modal>
