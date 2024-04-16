

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
    const next = () => modal.next();
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
  
  <Modal visible={$visible} on:nnsClose={closeModal}>
    <div class="p-2">
      
      <WizardModal {steps} bind:currentStep bind:this={modal} on:nnsClose={() => ($visible = false)}>
        <svelte:fragment slot="title">Create Private League</svelte:fragment>
  
        {#if currentStep?.name === "LeagueDetails"}
          <p>Step to enter the controller</p>
  
          <button class="primary" on:click={modal.next}>
              Next
          </button>
        {/if}
        {#if currentStep?.name === "EntryRequirements"}
          <p>Step to confirm the controller</p>
        {/if}
      </WizardModal>

    </div>
  </Modal>
  
  <style>
    .active {
      background-color: #2ce3a6;
      color: white;
    }
  </style>
  
