<script lang="ts">
    import CopyPrincipal from "../details/copy-principal.svelte";
    import WarningIcon from "$lib/icons/WarningIcon.svelte";
    import FullScreenSpinner from "../../shared/global/full-screen-spinner.svelte";
    import { userStore } from "$lib/stores/user-store";
    import {toastsStore } from "$lib/stores/toasts-store";

    let loadingMessage = $state("Checking membership status");

    let isLoading = $state(false);

    async function handleRefresh() {
        isLoading = true;
    try {
        await userStore.sync();
    } catch (error) {
        toastsStore.addToast({
            type: "error",
            message: "Membership Status Refresh Failed",
            duration: 5000,
        });
        console.error("Error refreshing membership status:", error);
    } finally {
        isLoading = false;
    }
}
</script>

{#if isLoading}
    <FullScreenSpinner message={loadingMessage} />
{:else}
    <div class="flex flex-col p-6 space-y-6 rounded-lg shadow-xl bg-gray-900/50">
        <div class="p-4 border rounded-lg bg-BrandRed border-BrandRed/80">
            <div class="flex items-start space-x-3">
                <div class="flex-shrink-0 mt-1">
                    <WarningIcon className="w-6 h-6" />
                </div>
                <div>
                    <h3 class="text-xl text-white">Membership Required</h3>
                    <p class="mt-1 text-white/70">Your ICFC membership has expired or has not been set up.</p>
                </div>
            </div>
        </div>
        <div class="mb-8 border-b border-BrandGreen">
            <h1 class="mb-2 text-4xl font-bold text-white">ICFC Membership Profile</h1>
        </div>
        <div class="space-y-4 text-gray-300">
            <p class="text-lg">Only ICFC ecosystem owners can play OpenFPL.</p>
            <p class="text-lg">
                Please visit 
                <a 
                    href="https://icfc.app/membership" 
                    target="_blank" 
                    class="underline transition-colors text-BrandGreen hover:text-BrandGreen/80"
                >
                    icfc.app
                </a> 
                to renew or setup your membership and to link your OpenFPL principal ID:
            </p>
            
            <div class="my-6">
                <CopyPrincipal  bgColor="gray" borderColor="white"/>
            </div>

            <div class="flex justify-center pt-4 space-x-4">
                <button 
                    class="fpl-button default-button hover:bg-BrandGreen/80"
                    onclick={handleRefresh}
                >
                    Refresh
                </button>
            </div>
        </div>
    </div>
{/if}