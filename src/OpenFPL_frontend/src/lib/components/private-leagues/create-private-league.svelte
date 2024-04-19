

<!-- League Details -->
<!-- Entry Requirement -->
<!-- Prize Setup -->
<!-- Invite Users -->
<!-- Agree terms -->


<script lang="ts">
    import { onMount } from "svelte";
    import { writable, derived } from 'svelte/store';
    import type {
        CreatePrivateLeagueDTO
    } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { toastsError } from "$lib/stores/toasts-store";
    import { Modal, WizardModal, type WizardStep, type WizardSteps } from "@dfinity/gix-components";
    import LeagueDetailsForm from "./league-details-form.svelte";
    import EntryRequirements from "./entry-requirements.svelte";
    import PrizeSetup from "./prize-setup.svelte";
    import AgreeTerms from "./agree-terms.svelte";
    import Payment from "./payment.svelte";
    import OpenFplIcon from "$lib/icons/OpenFPLIcon.svelte";
    
    export let visible = writable(false);
    let currentStepIndex = writable(0);

    export let closeModal: () => void;
    export let handleCreateLeague: (privateLeague: CreatePrivateLeagueDTO) => void;
    export let privateLeague = writable<CreatePrivateLeagueDTO>({
      adminFee: 0,
      name: "",
      entryRequirement: {FreeEntry : null},
      entrants: 0,
      termsAgreed: false,
      leaguePhoto: []
    });
  
    let isLoading = true;
  
    onMount(async () => {
      try {
        
      } catch (error) {
        toastsError({
          msg: { text: "Error loading create private league." },
          err: error,
        });
        console.error("Error loading create private league:", error);
      } finally {
        isLoading = false;
      }
    });

    let currentStep: WizardStep = {
        name: "LeagueDetails",
        title: "Enter your league details:"
    };
    let modal: WizardModal;
    
    const steps: WizardSteps = [
        {
            name: "LeagueDetails",
            title: "Enter your league details:"
        },
        {
            name: "EntryRequirements",
            title: "Setup your league entry requirements:"
        },
        {
            name: "PrizeDistribution",
            title: "Setup your league prize distribution:"
        },
        {
            name: "Terms",
            title: "Agree OpenFPL private league terms and conditions:"
        },
        {
            name: "Payment",
            title: "Purchase your private league:"
        }
    ];

    function nextStep(){
        modal.next;
        currentStepIndex.set($currentStepIndex + 1);
    }

    function priorStep(){
        modal.back;
        currentStepIndex.set($currentStepIndex - 1);
    }

    
    let pips = derived(currentStepIndex, $currentStepIndex => 
        steps.map((_, index) => index <= $currentStepIndex)
    );

    $: backButtonVisible = $currentStepIndex > 0;

    $: nextButtonVisible = 
        ($currentStepIndex === 0 && 
            ($privateLeague && $privateLeague.name && $privateLeague.name.length > 2) && ($privateLeague.entrants > 1 && $privateLeague.entrants <= 10000));

    $: if ($privateLeague) {
      console.log($privateLeague.entrants)
    }
  </script>
  
{#if $visible}
    <WizardModal {steps} bind:currentStep bind:this={modal} on:nnsClose={closeModal}>
        <div class="p-4">
            <div class="flex justify-between items-center">
                <p class="text-xl mt-2">Create Private League</p>
                <OpenFplIcon className="w-6 mr-2" />
            </div>

            {#if currentStep?.name === "LeagueDetails"}
                <LeagueDetailsForm {privateLeague} />
            {/if}

            {#if currentStep?.name === "EntryRequirements"}
                <EntryRequirements {privateLeague} />
            {/if}

            {#if currentStep?.name === "PrizeDistribution"}
                <PrizeSetup {privateLeague} />
            {/if}
            
            {#if currentStep?.name === "Terms"}
                <AgreeTerms {privateLeague} />
            {/if}
            
            {#if currentStep?.name === "Payment"}
                <Payment {privateLeague} />
            {/if}
            
        <div class="horizontal-divider my-2" />
            <div class="flex flex-row m-4 items-center">
            
                <div class="pips-container w-1/2">
                    {#each $pips as pip, index}
                        <div class="pip {pip ? 'active' : ''}" />
                    {/each}
                </div>

                <div class="flex justify-end space-x-2 mr-4 w-1/2">
                    {#if backButtonVisible}
                        <button class="fpl-button px-4 py-2 rounded-sm" on:click={priorStep}>
                            Back
                        </button>
                    {/if}
                    {#if nextButtonVisible}
                        <button class="fpl-button px-4 py-2 rounded-sm" on:click={nextStep}>
                            Next
                        </button>
                    {/if}
                </div>

            </div>

    </div>
    </WizardModal>
{/if}

<style>
    .pips-container {
        display: flex;
        justify-content: left;
    }
    .pip {
        width: 10px;
        height: 10px;
        border-radius: 50%;
        background-color: lightgrey;
        margin: 0 5px;
    }
    .pip.active {
        background-color: #2ce3a6; /* Adjust the color based on your UI theme */
    }
</style>