<script lang="ts">
    import { onMount } from "svelte";
    import { Modal } from "@dfinity/gix-components";
    import { toastsError } from "$lib/stores/toasts-store";
    import { teamStore } from "$lib/stores/team-store";
    import type { ClubDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { governanceStore } from "$lib/stores/governance-store";

    export let visible: boolean;
    export let cancelModal: () => void;

    let formerClubs: ClubDTO[] = [];
    let selectedClubId: number = -1;
    let isLoading = true;
    let showConfirm = false;

    $: isSubmitDisabled = selectedClubId <= 0;
   
    onMount(async () => {
        try {
            await teamStore.sync();
            formerClubs = await teamStore.getFormerClubs();
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
        await governanceStore.promoteFormerClub(selectedClubId);
    }
        

</script>

<Modal {visible} on:nnsClose={cancelModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Promote Former Club</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            <div class="ml-4">
                <select
                    class="p-2 fpl-dropdown mx-0 md:mx-2 min-w-[100px]"
                    bind:value={selectedClubId}
                >
                    <option value={-1}>Select</option>
                    {#each formerClubs as club}
                        <option value={club.id}>{club.friendlyName}</option>
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
