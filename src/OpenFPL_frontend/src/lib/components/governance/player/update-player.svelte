<script lang="ts">
    import { onMount } from "svelte";
    import { Modal } from "@dfinity/gix-components";
    import { toastsError } from "$lib/stores/toasts-store";
    import { governanceStore } from "$lib/stores/governance-store";
    import type { ClubDTO, PlayerDTO, PlayerPosition, ShirtType } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { teamStore } from "$lib/stores/team-store";
    import { playerStore } from "$lib/stores/player-store";
    import { countriesStore } from "$lib/stores/country-store";

    export let visible: boolean;
    export let cancelModal: () => void;

    let selectedClubId: number = -1;
    let selectedPlayerId: number = -1;
    let clubPlayers: PlayerDTO[] = [];
    
    let playerId: number;
    let position: PlayerPosition;
    let firstName: string;
    let lastName: string;
    let shirtNumber: number;
    let dateOfBirth: bigint;
    let nationalityId: number;

    let isLoading = true;
    let showConfirm = false;

    $: isSubmitDisabled = playerId <= 0 || 
        firstName.length > 50 ||
        lastName.length > 50 ||
        shirtNumber <= 0 && shirtNumber > 99 ||
        dateOfBirth <= 0 ||
        nationalityId <= 0;

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

    function raiseProposal(){
        showConfirm = true;
    }

    async function confirmProposal(){
        await governanceStore.updatePlayer(selectedClubId, position, firstName, lastName, shirtNumber, dateOfBirth, nationalityId);
    }

    $: if (selectedClubId) {
        loadClubPlayers();
    }

    $: if (selectedPlayerId) {
        loadPlayer();
    }

    async function loadClubPlayers() {
        isLoading = true;
        clubPlayers = $playerStore.filter(x => x.clubId == selectedClubId);
        isLoading = false;
    }

    async function loadPlayer() {
        let selectedPlayer = clubPlayers.find(x => x.id == selectedPlayerId);
        position = selectedPlayer?.position ?? { Goalkeeper: null };
        firstName = selectedPlayer?.firstName ?? "";
        lastName = selectedPlayer?.lastName ?? "";
        shirtNumber = selectedPlayer?.shirtNumber ?? 0;
        dateOfBirth = selectedPlayer?.dateOfBirth ?? 0n;
        nationalityId = selectedPlayer?.nationality ?? 0;
    }


</script>
<Modal {visible} on:nnsClose={cancelModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
            <h3 class="default-header">Update Player</h3>
            <button class="times-button" on:click={cancelModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            
            <div class="ml-4">
                <select
                  class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                  bind:value={selectedClubId}
                >
                    <option value={-1}>Select Club</option>
                    {#each $teamStore as club}
                        <option value={club.id}>{club.friendlyName}</option>
                    {/each}
                </select>
                {#if selectedClubId > 0}

                    <select
                        class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                        bind:value={selectedPlayerId}
                    >
                        <option value={-1}>Select Player</option>
                        {#each clubPlayers as player}
                            <option value={player.id}>{player.firstName} {player.lastName}</option>
                        {/each}
                    </select>

                    {#if selectedPlayerId > 0}

                        <select
                            class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                            bind:value={position}
                        >
                            <option value={{ Goalkeeper: null }}>Goalkeeper</option>
                            <option value={{ Defender: null }}>Defender</option>
                            <option value={{ Midfielder: null }}>Midfielder</option>
                            <option value={{ Forward: null }}>Forward</option>
                        </select>

                        let firstName: string;
                        let lastName: string;
                        let shirtNumber: number;
                        let dateOfBirth: bigint;
                        let nationalityId: number;

                        <input
                            type="text"
                            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                            placeholder="First Name"
                            bind:value={firstName}
                        />

                        <input
                            type="text"
                            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                            placeholder="Last Name"
                            bind:value={lastName}
                        />

                        <input
                            type="text"
                            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                            placeholder="Shirt Number"
                            bind:value={shirtNumber}
                        />


                        <p>Date of Birth:</p>

                        <input type="date" bind:value={dateOfBirth} class="input input-bordered" />


                        <p>Nationality:</p>
            
                        <select
                            class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                            bind:value={nationalityId}
                        >
                            {#each $countriesStore as country}
                                <option value={country.id}>{country.name}</option>
                            {/each}
                        </select>
                    {/if}                   
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
                        disabled={isSubmitDisabled}>
                        Raise Proposal
                    </button>
                </div>

                {#if showConfirm}
                    <div class="items-center py-3 flex">
                        <p class="text-orange-700">Failed proposals will cost the proposer 10 $FPL tokens.</p>
                    </div>
                    <div class="items-center py-3 flex">
                        
                        <button
                            class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`}
                            on:click={confirmProposal}
                            disabled={isSubmitDisabled}>
                            Confirm Submit Proposal
                        </button>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</Modal>
