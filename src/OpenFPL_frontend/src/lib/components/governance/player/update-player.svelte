<script lang="ts">
  import { onMount } from "svelte";
  import { Modal } from "@dfinity/gix-components";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { countriesStore } from "$lib/stores/country-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import { toastsError } from "$lib/stores/toasts-store";
  import type {
    PlayerDTO,
    PlayerPosition,
  } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  export let visible: boolean;
  export let cancelModal: () => void;

  let selectedClubId: number = 0;
  let selectedPlayerId: number = 0;
  let clubPlayers: PlayerDTO[] = [];
  let playerId: number = 0;
  let position: PlayerPosition;
  let firstName: string = "";
  let lastName: string = "";
  let shirtNumber: number;
  let dateOfBirth: bigint;
  let nationalityId: number;

  let isLoading = true;
  let showConfirm = false;

  $: isSubmitDisabled =
    (!isLoading && playerId <= 0) ||
    firstName.length > 50 ||
    lastName.length > 50 ||
    (shirtNumber <= 0 && shirtNumber > 99) ||
    dateOfBirth <= 0 ||
    nationalityId <= 0;

  $: if (isSubmitDisabled && showConfirm) {
    showConfirm = false;
  }

  onMount(async () => {
    try {
      playerStore.sync();
    } catch (error) {
      toastsError({
        msg: { text: "Error syncing player store." },
        err: error,
      });
      console.error("Error syncing player store.", error);
    } finally {
      isLoading = false;
    }
  });

  function raiseProposal() {
    showConfirm = true;
  }

  async function confirmProposal() {
    isLoading = true;
    await governanceStore.updatePlayer(
      selectedClubId,
      position,
      firstName,
      lastName,
      shirtNumber,
      dateOfBirth,
      nationalityId
    );
    isLoading = false;
    resetForm();
    cancelModal();
  }

  function resetForm(){
    selectedClubId = 0;
    selectedPlayerId = 0;
    playerId = 0;
    position = {Goalkeeper: null};
    firstName = "";
    lastName = "";
    shirtNumber = 0;
    dateOfBirth = 0n;
    nationalityId = 0;
    showConfirm = false;
    clubPlayers = [];
  }

  $: if (selectedClubId) {
    loadClubPlayers();
  }

  $: if (selectedPlayerId) {
    loadPlayer();
  }

  async function loadClubPlayers() {
    isLoading = true;
    clubPlayers = $playerStore.filter((x) => x.clubId == selectedClubId);
    isLoading = false;
  }

  async function loadPlayer() {
    let selectedPlayer = clubPlayers.find((x) => x.id == selectedPlayerId);
    position = selectedPlayer?.position ?? { Goalkeeper: null };
    firstName = selectedPlayer?.firstName ?? "";
    lastName = selectedPlayer?.lastName ?? "";
    shirtNumber = selectedPlayer?.shirtNumber ?? 0;
    dateOfBirth = selectedPlayer?.dateOfBirth ?? 0n;
    nationalityId = selectedPlayer?.nationality ?? 0;
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Update Player</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
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
            <p>Select a player to update:</p>
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

          {#if selectedPlayerId > 0}
            <div class="flex-col space-y-2">
              <p>Select a player's position:</p>
              <select
                class="p-2 fpl-dropdown my-4 min-w-[100px]"
                bind:value={position}
              >
                <option value={{ Goalkeeper: null }}>Goalkeeper</option>
                <option value={{ Defender: null }}>Defender</option>
                <option value={{ Midfielder: null }}>Midfielder</option>
                <option value={{ Forward: null }}>Forward</option>
              </select>
            </div>
    
            <div class="flex-col space-y-2">
              <p>First name:</p>
              <input
                type="text"
                class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                placeholder="First Name"
                bind:value={firstName}
              />
            </div>
    
            <div class="flex-col space-y-2">
              <p>Last name:</p>
              <input
                type="text"
                class="w-full px-4 py-2 my-4 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                placeholder="Last Name"
                bind:value={lastName}
              />
            </div>
          
            <div class="flex-col space-y-2">
              <p>Shirt number:</p>
              <input
                type="text"
                class="w-full px-4 py-2 my-4 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                placeholder="Shirt Number"
                bind:value={shirtNumber}
              />
            </div>
          
            <div class="flex-col space-y-2">
              <p>Date of birth:</p>
              <input
                type="date"
                bind:value={dateOfBirth}
                class="input input-bordered"
              />
            </div>
          
            <div class="flex-col space-y-2">
              <p>Nationality:</p>  
              <select
                class="p-2 fpl-dropdown my-4 min-w-[100px]"
                bind:value={nationalityId}
              >
                {#each $countriesStore as country}
                  <option value={country.id}>{country.name}</option>
                {/each}
              </select>
            </div>
          {/if}
        {/if}
        
        <div class="border-b border-gray-200"></div>

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
