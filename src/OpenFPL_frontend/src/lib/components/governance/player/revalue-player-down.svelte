<script lang="ts">
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { Modal } from "@dfinity/gix-components";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import type { PlayerDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  export let visible: boolean;
  export let cancelModal: () => void;

  let selectedClubId: number = 0;
  let selectedPlayerId: number = 0;
  let clubPlayers: PlayerDTO[] = [];

  let isLoading = false;
  let showConfirm = false;

  $: isSubmitDisabled = selectedPlayerId <= 0;


  $: if (selectedClubId) {
    getClubPlayers();
  }

  async function getClubPlayers() {
    clubPlayers = $playerStore.filter((x) => x.clubId == selectedClubId);
  }

  function raiseProposal() {
    showConfirm = true;
  }

  async function confirmProposal() {
    isLoading = true;
    await governanceStore.revaluePlayerDown(selectedPlayerId);
    isLoading = false;
    resetForm();
    cancelModal();
  }

  function resetForm(){
    selectedClubId = 0;
    selectedPlayerId = 0;
    showConfirm = false;
    clubPlayers = []
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Revalue Player Down</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full">
        <p>Select a player to revalue down by £0.25m:</p>

        <select
          class="p-2 fpl-dropdown my-4 min-w-[100px]"
          bind:value={selectedClubId}
        >
          {#each $teamStore as club}
            <option value={club.id}>{club.friendlyName}</option>
          {/each}
        </select>
        {#if selectedClubId > 0}
          <p>Select a player to revalue up by £0.25m:</p>

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
        {/if}

        <div class="border-b border-gray-200"></div>

        <div class="items-center py-3 flex space-x-4">
          <button
            class="px-4 py-2 default-button fpl-cancel-btn"
            type="button"
            on:click={cancelModal}
          >
            Cancel
          </button>
          <button
            class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button`}
            on:click={raiseProposal}
            disabled={isSubmitDisabled}
          >
            Raise Proposal
          </button>
        </div>

        {#if showConfirm}
          <div class="items-center py-3 flex">
            <p class="text-orange-700">
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
