<script lang="ts">
  import { userStore } from "$lib/stores/user-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { convertToE8s, isAmountValid, isPrincipalValid } from "$lib/utils/helpers";
  import Modal from "$lib/components/shared/modal.svelte";
  import LocalSpinner from "../../shared/local-spinner.svelte";
  
  
  interface Props {
    visible: boolean; 
    closeModal: () => void;
    cancelModal: () => void;
    fplBalance: bigint;
    fplBalanceFormatted: string;
  }
  let { visible, closeModal, cancelModal, fplBalance, fplBalanceFormatted }: Props = $props();


  let isLoading = $state(false);
  let errorMessage: string = $state("");
  let isSubmitDisabled = $state(true);
  let withdrawalAddress: string = $state("");
  let withdrawalInputAmount: string = $state("");

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
  
  $effect(() => {
    isSubmitDisabled = !isPrincipalValid(withdrawalAddress) || !isWithdrawAmountValid(withdrawalInputAmount, fplBalance); 
    errorMessage = (!isAmountValid(withdrawalInputAmount) || !isWithdrawAmountValid(withdrawalInputAmount, fplBalance)) && withdrawalInputAmount
    ? "Withdrawal amount greater than account balance."
    : "";
  });

  async function withdrawFPL() {
    isLoading = true;
    try {
      const amountInE8s = convertToE8s(withdrawalInputAmount);
      await userStore.withdrawFPL(withdrawalAddress, amountInE8s);
      toasts.addToast( { 
        message: "ICFC successfully withdrawn.",
        type: "success",
        duration: 2000,
      });
    } catch (error) {
      toasts.addToast({ 
        message: "Error withdrawing ICFC.",
        type: "error",
        duration: 4000,
      });
      console.error("Error withdrawing ICFC:", error);
    } finally {
      cancelModal();
      isLoading = false;
    }
  }
</script>

<Modal showModal={visible} onClose={closeModal} title="Withdraw ICFC">
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="p-4 mx-4">
      <p>ICFC Balance: {fplBalanceFormatted}</p>
      <div class="mt-4">
        <input type="text" class="fpl-button" placeholder="Withdrawal Address" value={withdrawalAddress} />
      </div>
      <div class="flex items-center mt-4">
        <input type="text" class="mr-2 fpl-button" placeholder="Withdrawal Amount" value={withdrawalInputAmount} />
        <button type="button" class="p-1 px-2 text-sm rounded md:text-sm md:p-2 md:px-4 fpl-button" onclick={setMaxWithdrawAmount}>
          Max
        </button>
      </div>
      {#if errorMessage}
        <div class="mt-2 text-red-600">{errorMessage}</div>
      {/if}
      <div class="flex flex-row items-center py-3 space-x-4">
        <button class="px-4 py-2 default-button fpl-cancel-btn" type="button"onclick={cancelModal}>
          Cancel
        </button>
        <button onclick={withdrawFPL} class={`px-4 py-2 ${ isSubmitDisabled ? "bg-gray-500" : "bg-BrandPurple"} default-button`} type="submit" disabled={isSubmitDisabled}>
          Withdraw
        </button>
      </div>
    </div>
  {/if}
</Modal>
