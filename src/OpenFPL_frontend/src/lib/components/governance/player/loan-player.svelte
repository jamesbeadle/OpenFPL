<script lang="ts">
  import { onMount } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { Modal } from "@dfinity/gix-components";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import type { PlayerDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { toastsError } from "$lib/stores/toasts-store";

  export let visible: boolean;
  export let closeModal: () => void;

  let selectedClubId: number = 0;
  let loadnClubId: number = 0;
  let selectedPlayerId: number = 0;
  let leavingLeague = false;
  
  let date = "";
  
  let clubPlayers: PlayerDTO[] = [];

  let isLoading = false;
  let showConfirm = false;

  $: isSubmitDisabled =
    selectedPlayerId <= 0 ||
    (!leavingLeague && selectedClubId <= 0) ||
    date == "";

  $: if (selectedClubId) {
    getClubPlayers();
  }

  $: if (isSubmitDisabled && showConfirm) {
    showConfirm = false;
  }

  onMount(async () => {
    try {
      await playerStore.sync();
      await teamStore.sync();
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

  async function getClubPlayers() {
    clubPlayers = $playerStore.filter((x) => x.clubId == selectedClubId);
  }

  function raiseProposal() {
    showConfirm = true;
  }

  async function confirmProposal() {
    isLoading = true;
    await governanceStore.loanPlayer(
      selectedPlayerId,
      selectedClubId,
      date
    );
    closeModal();
  }

  function cancelModal() {
    resetForm();
    closeModal();
  }

  function resetForm() {
    selectedClubId = 0;
    selectedPlayerId = 0;
    clubPlayers = [];
    isLoading = false;
  }
</script>

<Modal {visible} on:nnsClose={closeModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Loan Player</h3>
      <button class="times-button" on:click={closeModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full flex-col space-y-4 mb-2">
        <div class="flex-col space-y-2">
          <p>Select the players club:</p>
          <select
            class="p-2 fpl-dropdown min-w-[100px]"
            bind:value={selectedClubId}
          >
            <option value={0}>Select Club</option>
            {#each $teamStore as club}
              <option value={club.id}>{club.friendlyName}</option>
            {/each}
          </select>
        </div>

        {#if selectedClubId > 0}
          <div class="flex-col space-y-2">
            <p>Select a player to loan:</p>
            <select
              class="p-2 fpl-dropdown my-4 min-w-[100px]"
              bind:value={selectedPlayerId}
            >
              <option value={0}>Select Player</option>
              {#each clubPlayers as player}
                <option value={player.id}
                  >{player.firstName} {player.lastName}</option
                >
              {/each}
            </select>
          </div>
          <div class="flex-col space-y-2">
            <div class="flex flex-row">
              <p class="mr-2">Player leaving Premier League</p>
              <input type="checkbox" bind:checked={leavingLeague} />
            </div>

            <p>Or</p>

            {#if !leavingLeague}
              <p>Select new Premier League Club:</p>

              <select
                class="p-2 fpl-dropdown my-4 min-w-[100px]"
                bind:value={loadnClubId}
              >
                <option value={0}>Select Club</option>
                {#each $teamStore as club}
                  <option value={club.id}>{club.friendlyName}</option>
                {/each}
              </select>
            {/if}
          </div>

          <div class="flex flex-row my-2">
            <p class="mr-2">Select Date:</p>
            <input type="date" bind:value={date} class="input input-bordered" />
          </div>
        {/if}

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
