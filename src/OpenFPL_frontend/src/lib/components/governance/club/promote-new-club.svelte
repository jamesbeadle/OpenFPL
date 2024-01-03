<script lang="ts">
    import { onMount } from "svelte";
    import { Modal } from "@dfinity/gix-components";
    import { toastsError } from "$lib/stores/toasts-store";
    import { governanceStore } from "$lib/stores/governance-store";
    import type { ShirtType } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let visible: boolean;
    export let cancelModal: () => void;

    let name = "";
    let friendlyName = "";
    let primaryColourHex = "";
    let secondaryColourHex = "";
    let thirdColourHex = "";
    let abbreviatedName = "";
    let shirtType: ShirtType;

    let isLoading = true;
    let showConfirm = false;

    $: isSubmitDisabled = name.length > 0 && name.length < 50;
   
    onMount(async () => {
        try {
            
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
        await governanceStore.promoteNewClub(name, friendlyName, primaryColourHex, secondaryColourHex, thirdColourHex, abbreviatedName, shirtType);
    }
        

</script>

<Modal {visible} on:nnsClose={cancelModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Promote New Club</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            <div class="ml-4">
              
<!-- //TODO: 
                    name : Text;
                    friendlyName : Text;
                    primaryColourHex : Text;
                    secondaryColourHex : Text;
                    thirdColourHex : Text;
                    abbreviatedName : Text;
                    shirtType : T.ShirtType;
                -->


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
