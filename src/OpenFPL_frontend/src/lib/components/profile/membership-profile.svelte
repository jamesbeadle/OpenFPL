<script lang="ts">
  import FullScreenSpinner from "../shared/full-screen-spinner.svelte";
  import Header from "$lib/shared/Header.svelte";
  import CopyPrincipal from "./copy-principal.svelte";
  import MembershipLinkedModal from "./membership-linked-modal.svelte";
  import { toasts } from "$lib/stores/toasts-store";
  import { userStore } from "$lib/stores/user-store";
  import { authStore } from "$lib/stores/auth-store";
  import { get } from "svelte/store";
  import { userIdCreatedStore } from "$lib/stores/user-control-store";
  import { onMount } from "svelte";

  let isLoading = $state(false);

  let membershipLinked = $state(false);
  let notLinked = $state(true);
  let loadingMessage = $state("");

  onMount(async () => {
    await checkMembership();
  });

  async function checkMembership(){
    loadingMessage = "Checking ICFC Link Status";
    await checkICFCLinkStatus();
  }

  async function checkICFCLinkStatus(){
    isLoading = true;
    try {
      const principalId = get(authStore).identity?.getPrincipal().toString();
      if (!principalId) return;
      
      const icfcLinkStatus = await userStore.getICFCLinkStatus();
      console.log('icfcLinkStatus', icfcLinkStatus);
      if (icfcLinkStatus) {
        if ('PendingVerification' in icfcLinkStatus) {
          notLinked = false;
          toasts.addToast({
            type: "info",
            message: "ICFC Membership Pending Verification",
            duration: 4000,
          });
        } else if ('Verified' in icfcLinkStatus) {
          membershipLinked = true;
          notLinked = false;
          toasts.addToast({
            type: "success",
            message: "ICFC Membership Linked",
            duration: 4000,
          })
          userIdCreatedStore.set({ data: principalId, certified: true });
          //window.location.href = "/";
        } 
      } else {
            notLinked = true;
            toasts.addToast({
              type: "error",
              message: "Please Start ICFC Membership Link Process",
              duration: 4000,
          })
      }
    } catch (error) {
      console.error("Error checking ICFC link status:", error);
      toasts.addToast({
        type: "error",
        message: "Error Checking ICFC Link Status",
        duration: 4000,
      });
    } finally {
      isLoading = false;
    }
  }

  async function handleLinkICFCProfile(){
    try {
      isLoading = true;
      loadingMessage = "Linking ICFC Membership";
      const result = await userStore.linkICFCProfile();
      console.log('Link result:', result);
      
      if (result.success) {
        const principalId = get(authStore).identity?.getPrincipal().toString();
        if (!principalId) return;
        userIdCreatedStore.set({ data: principalId, certified: true });
        toasts.addToast({
          type: "success",
          message: "ICFC Membership Linked",
          duration: 5000,
        });
        window.location.href = "/";
      } else if (result.alreadyExists) {
        toasts.addToast({
          type: "info",
          message: "This Principal ID is already linked to an ICFC Membership",
          duration: 4000,
        });
        loadingMessage = "Re-checking ICFC Link Status";
        await checkMembership();
      } else {
        toasts.addToast({
          type: "error",
          message: "Failed to link ICFC Membership",
          duration: 5000,
        });
      }
    } catch (error) {
      console.error("Error linking ICFC Membership:", error);
      toasts.addToast({
        type: "error",
        message: "Failed to link ICFC Membership",
        duration: 5000,
      });
    } finally {
      isLoading = false;
    }
  } 
</script>

{#if isLoading}
<FullScreenSpinner message={loadingMessage} />
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
          <CopyPrincipal bgColor="bg-transparent" borderColor="border-BrandGreen" />
        </div>
        {#if !notLinked}
          <p class="px-2 mb-4 text-lg text-BrandGreen">
            Your ICFC membership is pending verification. Please click the button below to finalize the linking process.
          </p>
        {/if}
        <div class="flex justify-center pt-4">
          {#if notLinked}
            <button 
              class="fpl-button default-button hover:bg-BrandGreen/80"
              onclick={checkMembership}
            >
              <span>Refresh Status</span>
            </button>
          {:else}
            <button 
              class="fpl-button default-button "
              onclick={handleLinkICFCProfile}
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