<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import LoadingDots from "../shared/loading-dots.svelte";
    import WithdrawFplModal from "./withdraw-fpl-modal.svelte";

    let loadingBalances = true;
    let showWithdrawFPLModal = false;
    let fplBalance = 0n;
    let fplBalanceFormatted = "0.0000"; 

    onMount(async () => {
      await fetchBalances();
      loadingBalances = false;
    });

    async function fetchBalances() {
      fplBalance = await userStore.getFPLBalance();
      const fplBalanceInTokens = Number(fplBalance) / 100_000_000;
      fplBalanceFormatted = fplBalanceInTokens.toFixed(8);
      loadingBalances = false;
    }
  
    function loadWithdrawFPLModal(){
        showWithdrawFPLModal = true;
    };

    async function closeWithdrawFPLModal(){
        showWithdrawFPLModal = false;
        await fetchBalances();
    };
</script>
<div class="flex flex-wrap">
    <div class="w-full px-2 mb-4">
      <div class="mt-4 px-2">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
          <div class="flex items-center p-4 rounded-lg shadow-md border border-gray-700">
            <img src="/FPLCoin.png" alt="FPL" class="h-12 w-12 md:h-9 md:w-9" />
            <div class="ml-4 md:ml-3 flex flex-col space-y-2">
                {#if loadingBalances}
                  <LoadingDots />
                {:else}
                  <p>
                    {fplBalanceFormatted} FPL
                  </p>
                  <button class="text-sm md:text-sm p-1 md:p-2 px-2 md:px-4 rounded fpl-button"
                    on:click={loadWithdrawFPLModal}
                  >
                    Withdraw
                  </button>
                {/if}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <WithdrawFplModal
    bind:visible={showWithdrawFPLModal}
    closeModal={closeWithdrawFPLModal}
    cancelModal={closeWithdrawFPLModal}
    fplBalance={fplBalance}
    fplBalanceFormatted={fplBalanceFormatted}
  />