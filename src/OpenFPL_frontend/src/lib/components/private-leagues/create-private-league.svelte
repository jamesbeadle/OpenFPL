

<!-- League Details -->
<!-- Entry Requirement -->
<!-- Prize Setup -->
<!-- Invite Users -->
<!-- Agree terms -->


<script lang="ts">
    import { onMount } from "svelte";
    import { writable } from "svelte/store";
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

    export let closeModal: () => void;
    export let handleCreateLeague: (privateLeague: CreatePrivateLeagueDTO) => void;
    export let privateLeague = writable<CreatePrivateLeagueDTO | null>(null);
  
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

        
        <div class="flex justify-end mt-4 space-x-2 mb-4 mr-4">
            <button class="fpl-button px-4 py-2 rounded-sm" on:click={modal.next}>
                Next
            </button>
        </div>
        {/if}
        {#if currentStep?.name === "EntryRequirements"}
            <EntryRequirements {privateLeague} />

            <div class="flex justify-end mt-4 space-x-2 mb-4 mr-4">
                <button class="fpl-button px-4 py-2 rounded-sm" on:click={modal.back}>
                    Back
                </button>
                <button class="fpl-button px-4 py-2 rounded-sm" on:click={modal.next}>
                    Next
                </button>
            </div>
        {/if}
        {#if currentStep?.name === "PrizeDistribution"}
            <PrizeSetup {privateLeague} />

            <div class="flex justify-end mt-4 space-x-2 mb-4 mr-4">
                <button class="fpl-button px-4 py-2 rounded-sm" on:click={modal.back}>
                    Back
                </button>
                <button class="fpl-button px-4 py-2 rounded-sm" on:click={modal.next}>
                    Next
                </button>
            </div>
        {/if}
        {#if currentStep?.name === "Terms"}
            <AgreeTerms {privateLeague} />

            <div class="flex justify-end mt-4 space-x-2 mb-4 mr-4">
                <button class="fpl-button px-4 py-2 rounded-sm" on:click={modal.back}>
                    Back
                </button>
                <button class="fpl-button px-4 py-2 rounded-sm" on:click={modal.next}>
                    Next
                </button>
            </div>
        {/if}
        {#if currentStep?.name === "Payment"}
            <Payment {privateLeague} />

            <div class="flex justify-end mt-4 space-x-2 mb-4 mr-4">
                <button class="fpl-button px-4 py-2 rounded-sm mr-4" on:click={modal.back}>
                    Back
                </button>
            </div>
        {/if}
    </div>
    </WizardModal>
{/if}