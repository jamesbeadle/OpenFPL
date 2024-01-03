<script lang="ts">
    import { onMount } from "svelte";
    import { Modal } from "@dfinity/gix-components";
    import { teamStore } from "$lib/stores/team-store";
    import { systemStore } from "$lib/stores/system-store";
    import { toastsError } from "$lib/stores/toasts-store";
    import { governanceStore } from "$lib/stores/governance-store";
    import type { PlayerPosition } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { countriesStore } from "$lib/stores/country-store";
    export let visible: boolean;
    export let cancelModal: () => void;

    let selectedClubId: number;
    let selectedNationalityId: number;
    let selectedPosition: PlayerPosition;
    let firstName = "";
    let lastName = "";
    let dateOfBirth = 0;
    let shirtNumber = 0;
    let value = 0;
    let nationalityId = 0;

    $: isSubmitDisabled = selectedClubId <= 0 || nationalityId <= 0 || 
        firstName.length <= 0 || firstName.length > 50; //TODO: 
    
    let isLoading = true;
    let showConfirm = false;

    onMount(async () => {
        try {
            await teamStore.sync();
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
        //TODO: CONVERT THE VALUE INTO QMS
        //TODO: Ensure the value is in QMs
        await governanceStore.rescheduleFixture(
            $systemStore?.calculationSeasonId ?? 0, 
            selectedFixtureId, 
            updatedFixtureGameweek ?? 1, 
            updatedFixtureDate ?? 0);
    }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Create Player</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            <div class="ml-4">
                
                <p>Select Club:</p>
                
                <select
                    class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                    bind:value={selectedClubId}
                >
                    {#each $teamStore as club}
                        <option value={club.id}>{club.friendlyName}</option>
                    {/each}
                </select>

                <p>Select Position:</p>
                
                <select
                    class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                    bind:value={selectedPosition}
                >
                    <option value={{ Goalkeeper: null }}>Goalkeeper</option>
                    <option value={{ Defender: null }}>Defender</option>
                    <option value={{ Midfielder: null }}>Midfielder</option>
                    <option value={{ Forward: null }}>Forward</option>
                </select>

                <p>First Name:</p>
            
                <input
                    type="text"
                    class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                    placeholder="First Name"
                    bind:value={firstName}
                />
                
                <p>Last Name:</p>
            
                <input
                    type="text"
                    class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                    placeholder="First Name"
                    bind:value={lastName}
                />

                <p>Shirt Number:</p>
            
                <input
                    type="text"
                    class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                    placeholder="Shirt Number"
                    bind:value={shirtNumber}
                />

                <p>Value:</p>
            
                <input
                    type="text"
                    class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
                    placeholder="Shirt Number"
                    bind:value={value}
                />

                <p>Date of Birth:</p>

                <input type="date" bind:value={dateOfBirth} class="input input-bordered" />

                <p>Nationality:</p>
            
                <select
                    class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                    bind:value={selectedNationalityId}
                >
                    {#each $countriesStore as country}
                        <option value={country.id}>{country.name}</option>
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
