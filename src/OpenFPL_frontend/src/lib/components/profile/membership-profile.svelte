<script lang="ts">
    import LocalSpinner from "../shared/local-spinner.svelte";
    import Header from "$lib/shared/Header.svelte";
    import type { CombinedProfile, ICFCLinkStatus } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import CopyPrincipal from "./copy-principal.svelte";
    import MembershipLinkedModal from "./membership-linked-modal.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import { userStore } from "$lib/stores/user-store";
    import { authStore } from "$lib/stores/auth-store";
    import { get } from "svelte/store";
    
    //export let icfcProfile: CombinedProfile | undefined = undefined;
  
    let isLoading = false;

    let membershipLinked = false;
    let notLinked = true;

    async function checkMembership(){
      toasts.addToast({
        type: "info",
        message: "Checking membership...",
        duration: 2000,
      });
      await checkICFCLinkStatus();
    }

    async function checkICFCLinkStatus(){
      const principalId = get(authStore).identity?.getPrincipal().toString();
      if (!principalId) return;
      
      const icfcLinkStatus = await userStore.getICFCLinkStatus(principalId);
      if (icfcLinkStatus) {
        if ('PendingVerification' in icfcLinkStatus) {
          notLinked = false;
          toasts.addToast({
            type: "info",
            message: "ICFC Membership Pending Verification",
            duration: 2000,
          });
        } else if ('Verified' in icfcLinkStatus) {
          membershipLinked = true;
          notLinked = false;
          toasts.addToast({
            type: "success",
            message: "ICFC Membership Linked",
            duration: 2000,
          })
        } 
      } else {
            notLinked = true;
            toasts.addToast({
              type: "error",
              message: "ICFC Membership Not Linked",
              duration: 2000,
          })
      }
    }

    async function handleLinkICFCProfile(){
      try {
        isLoading = true;
        toasts.addToast({
          type: "info",
          message: "Linking ICFC Membership...",
          duration: 2000,
        });
        const result = await userStore.linkICFCProfile();
        console.log(result)
        if (result) {
          await userStore.sync();
          toasts.addToast({
            type: "success",
            message: "ICFC Membership Linked",
            duration: 2000,
          });
          window.location.href = "/";
        } else {
          toasts.addToast({
            type: "error",
            message: "Failed to link ICFC Membership",
            duration: 2000,
          });
        }
      } catch (error) {
        console.error("Error linking ICFC Membership:", error);
        toasts.addToast({
          type: "error",
          message: "Failed to link ICFC Membership",
          duration: 4000,
        });
      } finally {
        isLoading = false;
      }
    }
    
  </script>


{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="flex flex-col w-full h-full mx-auto">
    <Header />
    <div class="flex-1 w-full p-6 mx-auto">
      <div class="p-8 rounded-lg shadow-xl bg-gray-900/50">
        <div class="mb-8 border-b border-BrandGreen">
          <h1 class="mb-2 text-4xl font-bold text-white">ICFC Membership Profile</h1>
        </div>
        <div class="space-y-6 text-gray-300">
          <p class="text-lg">
            OpenFPL is free to play for ICFC owners who have claimed their membership through 
            <a 
              href="https://icfc.app/membership" 
              target="_blank" 
              class="underline transition-colors text-BrandGreen hover:text-BrandGreen/80"
            >
              icfc.app
            </a>.
          </p>
          <p class="mb-4 text-lg">
            Please link your OpenFPL principal ID within your ICFC profile to play and then click the button below to refresh your status.
          </p>
          <div class="mb-6">
            <CopyPrincipal />
          </div>
          {#if !notLinked}
            <p class="mb-4 text-lg text-BrandGreen">
              Your ICFC membership is pending verification. Please click the button below to finalize the linking process.
            </p>
          {/if}
          <div class="flex justify-center pt-4">
            {#if notLinked}
              <button 
                class="fpl-button default-button hover:bg-BrandGreen/80"
                on:click={checkMembership}
              >
                <span>Refresh Status</span>
              </button>
            {:else}
              <button 
                class="fpl-button default-button "
                on:click={handleLinkICFCProfile}
              >
                <span>Link ICFC Membership</span>
              </button>
            {/if}
          </div>
        </div>
      </div>
    </div>
  </div>
{/if}

{#if membershipLinked}
  <MembershipLinkedModal />
{/if}