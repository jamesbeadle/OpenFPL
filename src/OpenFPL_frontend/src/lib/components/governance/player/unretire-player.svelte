
<script lang="ts">
    import { onMount } from "svelte";
    import { Modal } from "@dfinity/gix-components";
    import { toastsError } from "$lib/stores/toasts-store";
    import { playerStore } from "$lib/stores/player-store";
    import { governanceStore } from "$lib/stores/governance-store";
    import type { PlayerDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
   
    export let visible: boolean;
    export let cancelModal: () => void;

    let selectedClubId: number = -1;
    let selectedPlayerId: number = 0;
    let isLoading = true;    
    let showConfirm = false;
    let clubRetiredPlayers: PlayerDTO[] = [];
    
    $: isSubmitDisabled = selectedPlayerId <= 0;
    
    $: if (selectedClubId) {
        getRetiredPlayers();
    }

    onMount(async () => {
        try {
            await playerStore.sync();
        } catch (error) {
        toastsError({
            msg: { text: "Error syncing club details." },
            err: error,
        });
        console.error("Error syncing club details.", error);
        } finally {
        isLoading = false;
        }
    });

    function raiseProposal(){
        showConfirm = true;
    }

    async function confirmProposal(){
        await governanceStore.unretirePlayer(selectedPlayerId);
    }

    async function getRetiredPlayers(){
        clubRetiredPlayers = await playerStore.getRetiredPlayers(selectedClubId);
    }

</script>

<Modal {visible} on:nnsClose={cancelModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Unretire Player</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            <div class="ml-4">

                <p>Select a player to retire:</p>

                <select
                    class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                    bind:value={selectedPlayerId}
                >
                    <option value={0}>Select Player</option>
                    {#each $playerStore as player}
                        <option value={player.id}>{player.firstName} {player.lastName}</option>
                    {/each}
                </select>
               
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
