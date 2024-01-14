<script lang="ts">
  import { onMount } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { Modal } from "@dfinity/gix-components";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import type { ClubDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { isError } from "$lib/utils/Helpers";

  export let visible: boolean;
  export let closeModal: () => void;

  let formerClubs: ClubDTO[] = [];
  let selectedClubId: number = 0;

  let isLoading = true;
  let showConfirm = false;

  $: isSubmitDisabled = selectedClubId <= 0;

  $: if (isSubmitDisabled && showConfirm) {
    showConfirm = false;
  }

  onMount(async () => {
    try {
      await teamStore.sync();
      formerClubs = await teamStore.getFormerClubs();
    } catch (error) {
      toastsError({
        msg: { text: "Error syncing proposal data." },
        err: error,
      });
      console.error("Error syncing proposal data.", error);
    } finally {
      isLoading = false;
    }
  });

  function raiseProposal() {
    showConfirm = true;
  }

  async function confirmProposal() {
    isLoading = true;
    let result = await governanceStore.promoteFormerClub(selectedClubId);

    if (isError(result)) {
      isLoading = false;
      toastsError({
        msg: { text: "Error submitting proposal." },
      });
      console.error("Error submitting proposal");
      return;
    }
    isLoading = false;
    resetForm();
    cancelModal();
  }

  function resetForm() {
    selectedClubId = 0;
    showConfirm = false;
    formerClubs = [];
  }

  function cancelModal() {
    resetForm();
    closeModal();
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Promote Former Club</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full flex-col space-y-4 mb-2">
        <div class="flex-col space-y-2">
          <select
            class="p-2 fpl-dropdown min-w-[100px]"
            bind:value={selectedClubId}
          >
            <option value={0}>Select Club</option>
            {#each formerClubs as club}
              <option value={club.id}>{club.friendlyName}</option>
            {/each}
          </select>
        </div>

        <div class="border-b border-gray-200" />

        <div class="items-center flex space-x-4">
          <button
            class="px-4 py-2 default-button fpl-cancel-btn min-w-[150px]"
            type="button"
            on:click={cancelModal}
          >
            Cancel
          </button>
          <button
            class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                        px-4 py-2 default-button min-w-[150px]`}
            on:click={raiseProposal}
            disabled={isSubmitDisabled}
          >
            Raise Proposal
          </button>
        </div>

        {#if showConfirm}
          <div class="items-center flex">
            <p class="text-orange-400">
              Failed proposals will cost the proposer 10 $FPL tokens.
            </p>
          </div>
          <div class="items-center flex">
            <button
              class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
                            px-4 py-2 default-button w-full`}
              on:click={confirmProposal}
              disabled={isSubmitDisabled}
            >
              Confirm Submit Proposal
            </button>
          </div>
        {/if}
      </div>
    </div>

    {#if isLoading}
      <LocalSpinner />
    {/if}
  </div>
</Modal>
