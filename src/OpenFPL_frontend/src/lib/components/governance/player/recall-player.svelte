<script lang="ts">
  import { onMount } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { Modal } from "@dfinity/gix-components";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import type { PlayerDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  export let visible: boolean;
  export let cancelModal: () => void;

  let selectedClubId: number = 0;
  let selectedPlayerId: number = 0;
  let leavingLeague = false;
  let loanEndDate: number = 0;
  let loanedPlayers: PlayerDTO[] = [];

  let isLoading = true;
  let showConfirm = false;

  $: isSubmitDisabled =
    selectedPlayerId <= 0 ||
    (!leavingLeague && selectedClubId <= 0) ||
    loanEndDate == 0;


  onMount(async () => {
    try {
      await playerStore.sync();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching fixture information." },
        err: error,
      });
      console.error("Error fetching fixture information.", error);
    } finally {
      isLoading = false;
    }
  });

  $: if (selectedClubId) {
    getLoanedPlayers();
  }

  async function getLoanedPlayers() {
    isLoading = true;
    loanedPlayers = await playerStore.getLoanedPlayers(selectedClubId);
    isLoading = false;
  }

  function raiseProposal() {
    showConfirm = true;
  }

  async function confirmProposal() {
    isLoading = true;
    await governanceStore.recallPlayer(selectedPlayerId);
    isLoading = false;
    resetForm();
    cancelModal();
  }

  function resetForm(){
    selectedClubId = 0;
    selectedPlayerId = 0;
    leavingLeague = false;
    loanEndDate = 0;
    showConfirm = false;
    loanedPlayers = [];
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Recall Player</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="ml-4">
        <p>Select the players club:</p>

        <select
          class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
          bind:value={selectedClubId}
        >
          {#each $teamStore as club}
            <option value={club.id}>{club.friendlyName}</option>
          {/each}
        </select>

        {#if selectedClubId > 0}
          <p>Select a player to recall:</p>

          <select
            class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
            bind:value={selectedPlayerId}
          >
            <option value={0}>Select Player</option>
            {#each loanedPlayers as player}
              <option value={player.id}
                >{player.firstName} {player.lastName}</option
              >
            {/each}
          </select>
        {/if}

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
          <div class="items-center py-3 flex">
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
