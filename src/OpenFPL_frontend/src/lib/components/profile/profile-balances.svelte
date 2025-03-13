<script lang="ts">
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import LoadingDots from "../shared/loading-dots.svelte";
    import WithdrawFplModal from "./withdraw-fpl-modal.svelte";
    import ICFCCoinIcon from "$lib/icons/ICFCCoinIcon.svelte";

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
      <div class="px-2 mt-4">
        <div class="grid grid-cols-1 gap-4 md:grid-cols-4">
          <div class="flex items-center p-4 border border-gray-700 rounded-lg shadow-md">
            <ICFCCoinIcon className="h-12 w-12 md:h-9 md:w-9" />
            <div class="flex flex-col ml-4 space-y-2 md:ml-3">
                {#if loadingBalances}
                  <LoadingDots />
                {:else}
                  <p>
                    {fplBalanceFormatted} ICFC
                  </p>
                  <button class="p-1 px-2 text-sm rounded md:text-sm md:p-2 md:px-4 fpl-button"
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