<script lang="ts">
    import { onMount } from "svelte";
    import { Modal } from "@dfinity/gix-components";
    import { toastsError } from "$lib/stores/toasts-store";
    import { governanceStore } from "$lib/stores/governance-store";
    import type { ClubDTO, ShirtType } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { teamStore } from "$lib/stores/team-store";

    export let visible: boolean;
    export let cancelModal: () => void;

    let selectedClubId: number = -1;
    
    let name = "";
    let friendlyName = "";
    let abbreviatedName = "";
    let primaryColourHex = "";
    let secondaryColourHex = "";
    let thirdColourHex = "";
    let shirtType: ShirtType = { Filled: null };

    let isLoading = true;
    let showConfirm = false;

    $: isSubmitDisabled = 
        selectedClubId <= 0 ||
        name.length <= 0 || name.length > 100 ||
        friendlyName.length <= 0 || friendlyName.length > 50 ||
        abbreviatedName.length != 3;

    let shirtTypes: ShirtType[] = [{ Filled: null }, { Striped: null }];

    onMount(async () => {
        try {
            teamStore.sync();
        } catch (error) {
        toastsError({
            msg: { text: "Error syncing club store." },
            err: error,
        });
        console.error("Error syncing club store.", error);
        } finally {
        isLoading = false;
        }
    });

    function raiseProposal(){
        showConfirm = true;
    }

    async function confirmProposal(){
        await governanceStore.updateClub(selectedClubId, name, friendlyName, primaryColourHex, secondaryColourHex, thirdColourHex, abbreviatedName, shirtType);
    }

    function handlePrimaryColorChange(event: Event) {
        const input = event.target as HTMLInputElement;
        primaryColourHex = input.value;
    }

    function handleSecondaryColorChange(event: Event) {
        const input = event.target as HTMLInputElement;
        secondaryColourHex = input.value;
    }

    function handleThirdColorChange(event: Event) {
        const input = event.target as HTMLInputElement;
        thirdColourHex = input.value;
    }

    $: if (selectedClubId) {
        loadClub();
    }

    async function loadClub() {
        isLoading = true;

        let clubs = $teamStore;
        let selectedClub = clubs.find(x => x.id == selectedClubId);
        
        if(!selectedClub){
            isLoading = false;
            return;
        }

        name = selectedClub.name;
        friendlyName = selectedClub.friendlyName;
        abbreviatedName = selectedClub.abbreviatedName;
        primaryColourHex = selectedClub.primaryColourHex;
        secondaryColourHex = selectedClub.secondaryColourHex;
        thirdColourHex = selectedClub.thirdColourHex;
        
        isLoading = false;
    }


</script>

<Modal {visible} on:nnsClose={cancelModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
            <h3 class="default-header">Update Club</h3>
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
                    <input
                        type="text"
                        class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                        placeholder="Club Full Name"
                        bind:value={name}
                    />

                    <input
                        type="text"
                        class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                        placeholder="Club Friendly Name"
                        bind:value={name}
                    />

                    <input
                        type="text"
                        class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                        placeholder="Abbreviated Name"
                        bind:value={abbreviatedName}
                    />

                    <input 
                        type="color" 
                        bind:value={primaryColourHex}
                        on:input={handlePrimaryColorChange}
                        class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                    />

                    <input 
                        type="color" 
                        bind:value={secondaryColourHex}
                        on:input={handleSecondaryColorChange}
                        class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                    />

                    <input 
                        type="color" 
                        bind:value={thirdColourHex}
                        on:input={handleThirdColorChange}
                        class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                    />

                    <select
                    class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                    bind:value={shirtType}
                    >
                        {#each shirtTypes as shirt}
                            <option value={shirt}>{shirt}</option>
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
