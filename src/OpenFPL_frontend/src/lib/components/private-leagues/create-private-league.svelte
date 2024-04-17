

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
        {#if currentStep?.name === "LeagueDetails"}
        <LeagueDetailsForm {privateLeague} />

        <button class="primary" on:click={modal.next}>
            Next
        </button>
        {/if}
        {#if currentStep?.name === "EntryRequirements"}
            <EntryRequirements {privateLeague} />

            <button class="primary" on:click={modal.back}>
                Back
            </button>
            <button class="primary" on:click={modal.next}>
                Next
            </button>
        {/if}
        {#if currentStep?.name === "PrizeDistribution"}
            <PrizeSetup {privateLeague} />

            <button class="primary" on:click={modal.next}>
                Next
            </button>
        {/if}
        {#if currentStep?.name === "Terms"}
            <AgreeTerms {privateLeague} />

            <button class="primary" on:click={modal.next}>
                Next
            </button>
        {/if}
        {#if currentStep?.name === "Payment"}
            <Payment {privateLeague} />

            <button class="primary" on:click={modal.next}>
                Next
            </button>
        {/if}
    </div>
    </WizardModal>
{/if}