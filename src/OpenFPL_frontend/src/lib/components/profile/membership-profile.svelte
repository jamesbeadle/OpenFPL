<script lang="ts">
    import LocalSpinner from "../shared/local-spinner.svelte";
    import Header from "$lib/shared/Header.svelte";
    import type { CombinedProfile } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import CopyPrincipal from "./copy-principal.svelte";
    import MembershipLinkedModal from "./membership-linked-modal.svelte";
    
    export let icfcProfile: CombinedProfile | undefined = undefined;
  
    let isLoading = false;

    let membershipLinked = false;
    
    async function checkMembership(){
      // TODO Recheck 
      
    }
   


  </script>


{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="flex flex-col w-full h-full max-w-2xl mx-auto">
      <Header />
      <div class="flex-1 w-full mt-16 overflow-x-hidden">

        <div class="mt-4 border-b border-white/10">
            <div class="flex items-center justify-between">
                <h3 class="text-2xl text-white cta-text">ICFC Membership Profile</h3>
            </div>

            <p>
              OpenFPL is free to play for ICFC owners who have claimed their membership through <a target="_blank" href="https://icfc.app/memberhsip">icfc.app</a>.
            </p>

            <p>
              Please link your below OpenFPL principal ID within your ICFC profile to play:
            </p>

            <CopyPrincipal />

        </div>

        <div class="flex justify-between">
            <button 
            class="brand-button"
            on:click={checkMembership}
            >
            Refresh
            </button>
        </div>
      </div>
  </div>
{/if}

{#if membershipLinked}
  <MembershipLinkedModal />
{/if}