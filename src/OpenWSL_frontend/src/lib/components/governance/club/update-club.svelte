<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { Modal } from "@dfinity/gix-components";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import type { ShirtType } from "../../../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import { isError } from "$lib/utils/helpers";
  import { storeManager } from "$lib/managers/store-manager";

  export let visible: boolean;
  export let closeModal: () => void;

  let selectedClubId: number = 0;
  let name = "";
  let friendlyName = "";
  let abbreviatedName = "";
  let primaryColourHex = "";
  let secondaryColourHex = "";
  let thirdColourHex = "";
  let shirtType: ShirtType = { Filled: null };

  let isLoading = true;
  let showConfirm = false;

  $: isSubmitDisabled =
    selectedClubId <= 0 ||
    name.length <= 0 ||
    name.length > 100 ||
    friendlyName.length <= 0 ||
    friendlyName.length > 50 ||
    abbreviatedName.length != 3;

  $: if (isSubmitDisabled && showConfirm) {
    showConfirm = false;
  }

  let shirtTypes: ShirtType[] = [{ Filled: null }, { Striped: null }];

  onMount(async () => {
    try {
      await storeManager.syncStores();
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
    let result = await governanceStore.updateClub(
      selectedClubId,
      name,
      friendlyName,
      primaryColourHex,
      secondaryColourHex,
      thirdColourHex,
      abbreviatedName,
      shirtType
    );
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
    closeModal();
  }

  function resetForm() {
    selectedClubId = 0;
    name = "";
    friendlyName = "";
    abbreviatedName = "";
    primaryColourHex = "";
    secondaryColourHex = "";
    thirdColourHex = "";
    shirtType = { Filled: null };
  }

  function handlePrimaryColorChange(event: Event) {
    const input = event.target as HTMLInputElement;
    primaryColourHex = input.value;
  }

  function handleSecondaryColorChange(event: Event) {
    const input = event.target as HTMLInputElement;
    secondaryColourHex = input.value;
  }

  function handleThirdColorChange(event: Event) {
    const input = event.target as HTMLInputElement;
    thirdColourHex = input.value;
  }

  function cancelModal() {
    resetForm();
    closeModal();
  }

  $: if (selectedClubId) {
    loadClub();
  }

  async function loadClub() {
    isLoading = true;

    let clubs = $clubStore;
    let selectedClub = clubs.find((x) => x.id == selectedClubId);

    if (!selectedClub) {
      isLoading = false;
      return;
    }

    name = selectedClub.name;
    friendlyName = selectedClub.friendlyName;
    abbreviatedName = selectedClub.abbreviatedName;
    primaryColourHex = selectedClub.primaryColourHex;
    secondaryColourHex = selectedClub.secondaryColourHex;
    thirdColourHex = selectedClub.thirdColourHex;

    isLoading = false;
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Update Club</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full flex-col space-y-4 mb-2">
        <select
          class="p-2 fpl-dropdown min-w-[100px]"
          bind:value={selectedClubId}
        >
          <option value={0}>Select Club</option>
          {#each $clubStore as club}
            <option value={club.id}>{club.friendlyName}</option>
          {/each}
        </select>
        {#if selectedClubId > 0}
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="Club Full Name"
            bind:value={name}
          />

          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="Club Friendly Name"
            bind:value={friendlyName}
          />

          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="Abbreviated Name"
            bind:value={abbreviatedName}
          />

          <input
            type="color"
            bind:value={primaryColourHex}
            on:input={handlePrimaryColorChange}
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
          />

          <input
            type="color"
            bind:value={secondaryColourHex}
            on:input={handleSecondaryColorChange}
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
          />

          <input
            type="color"
            bind:value={thirdColourHex}
            on:input={handleThirdColorChange}
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
          />

          <select
            class="p-2 fpl-dropdown my-4 min-w-[100px]"
            bind:value={shirtType}
          >
            {#each shirtTypes as shirt}
              <option value={shirt}>{shirt}</option>
            {/each}
          </select>
        {/if}

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
