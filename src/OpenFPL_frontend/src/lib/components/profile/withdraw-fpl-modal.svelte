<script lang="ts">
  import { userStore } from "$lib/stores/user-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { convertToE8s, isAmountValid, isPrincipalValid } from "$lib/utils/helpers";
  import Modal from "$lib/components/shared/modal.svelte";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  
  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  export let withdrawalAddress: string = "";
  export let withdrawalInputAmount: string = "";
  export let fplBalance: bigint;
  export let fplBalanceFormatted: string;

  let isLoading = false;
  let errorMessage: string = "";

  function isWithdrawAmountValid(amount: string, balance: bigint): boolean {
    if (!isAmountValid(amount)) {
      return false;
    }
    
    const amountInE8s = convertToE8s(amount);
    return amountInE8s <= BigInt(balance * 100_000_000n);
  }

  function setMaxWithdrawAmount() {
    const maxAmount = Number(fplBalance) / 100_000_000;
    withdrawalInputAmount = maxAmount.toFixed(8);
  }

  $: isSubmitDisabled = !isPrincipalValid(withdrawalAddress) || !isWithdrawAmountValid(withdrawalInputAmount, fplBalance);

  $: errorMessage = (!isAmountValid(withdrawalInputAmount) || !isWithdrawAmountValid(withdrawalInputAmount, fplBalance)) && withdrawalInputAmount
    ? "Withdrawal amount greater than account balance."
    : "";

  async function withdrawFPL() {
    isLoading = true;
    try {
      const amountInE8s = convertToE8s(withdrawalInputAmount);
      await userStore.withdrawFPL(withdrawalAddress, amountInE8s);
      toasts.addToast( { 
        message: "FPL successfully withdrawn.",
        type: "success",
        duration: 2000,
      });
    } catch (error) {
      toasts.addToast({ 
        message: "Error withdrawing FPL."
      });
      console.error("Error withdrawing FPL:", error);
    } finally {
      cancelModal();
      isLoading = false;
    }
  }
</script>

<Modal showModal={visible} onClose={closeModal} title="Withdraw FPL">
  {#if isLoading}
    <WidgetSpinner />
  {:else}
    <div class="mx-4 p-4">
      <form on:submit|preventDefault={withdrawFPL}>
        <p>FPL Balance: {fplBalanceFormatted}</p>
        <div class="mt-4">
          <input type="text" class="fpl-button" placeholder="Withdrawal Address" bind:value={withdrawalAddress} />
        </div>
        <div class="mt-4 flex items-center">
          <input type="text" class="fpl-button mr-2" placeholder="Withdrawal Amount" bind:value={withdrawalInputAmount} />
          <button type="button" class="text-sm md:text-sm p-1 md:p-2 px-2 md:px-4 rounded fpl-button" on:click={setMaxWithdrawAmount}>
            Max
          </button>
        </div>
        {#if errorMessage}
          <div class="mt-2 text-red-600">{errorMessage}</div>
        {/if}
        <div class="items-center py-3 flex space-x-4 flex-row">
          <button class="px-4 py-2 default-button fpl-cancel-btn" type="button"on:click={cancelModal}>
            Cancel
          </button>
          <button class={`px-4 py-2 ${ isSubmitDisabled ? "bg-gray-500" : "bg-BrandPurple"} default-button`} type="submit" disabled={isSubmitDisabled}>
            Withdraw
          </button>
        </div>
      </form>
    </div>
  {/if}
</Modal>
