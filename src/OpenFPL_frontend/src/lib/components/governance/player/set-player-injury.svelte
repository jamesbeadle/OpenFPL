<script lang="ts">
    import { governanceStore } from "$lib/stores/governance-store";
    import { playerStore } from "$lib/stores/player-store";
    import { Modal } from "@dfinity/gix-components";

    export let visible: boolean;
    export let cancelModal: () => void;

    let selectedPlayerId: number = 0;
    let description = "";
    let injuryEndDate = 0;

    $: isSubmitDisabled = selectedPlayerId <= 0 || injuryEndDate == 0 || description.length == 0;
    
    let showConfirm = false;

    function raiseProposal(){
        showConfirm = true;
    }

    async function confirmProposal(){
        await governanceStore.setPlayerInjury(selectedPlayerId, description, injuryEndDate);
    }

</script>

<Modal {visible} on:nnsClose={cancelModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Set Player Injury</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            <div class="ml-4">

                <p>Select a player to set as injured:</p>

                <select
                    class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                    bind:value={selectedPlayerId}
                >
                    <option value={0}>Select Player</option>
                    {#each $playerStore as player}
                        <option value={player.id}>{player.firstName} {player.lastName}</option>
                    {/each}
                </select>


                <p>Enter the injury description:</p>
                
                <input
                    type="text"
                    class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                    placeholder="Injury Description"
                    bind:value={description}
                />

                <p>Enter the expected return date of the player:</p>
                
                <input type="date" bind:value={injuryEndDate} class="input input-bordered" />
               
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
