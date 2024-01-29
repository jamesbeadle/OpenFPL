<script lang="ts">
  import { onMount } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { countriesStore } from "$lib/stores/country-store";
  import { Modal } from "@dfinity/gix-components";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import type { PlayerPosition } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { isError } from "$lib/utils/Helpers";

  export let visible: boolean;
  export let closeModal: () => void;

  let selectedClubId: number = 0;
  let selectedPosition: PlayerPosition;
  let firstName = "";
  let lastName = "";
  let dateOfBirth = "";
  let shirtNumber = 0;
  let value = 0;
  let nationalityId = 0;

  let isLoading = true;
  let showConfirm = false;

  $: isSubmitDisabled =
    selectedClubId <= 0 ||
    nationalityId <= 0 ||
    lastName.length <= 0 ||
    lastName.length > 50 ||
    dateOfBirth == "" ||
    shirtNumber <= 0 ||
    shirtNumber > 99 ||
    value <= 0 ||
    value > 200 ||
    nationalityId == 0;

  $: if (isSubmitDisabled) {
    console.log(`isSubmitDisabled: ${isSubmitDisabled}`);
    console.log(`selectedClubId: ${selectedClubId}`);
    console.log(`nationalityId: ${nationalityId}`);
    console.log(`lastName.length: ${lastName.length}`);
    console.log(`dateOfBirth: ${dateOfBirth}`);
    console.log(`shirtNumber: ${shirtNumber}`);
    console.log(`value: ${value}`);
  }


  $: if (isSubmitDisabled && showConfirm) {
    showConfirm = false;
  }

  onMount(async () => {
    try {
      await teamStore.sync();
      await countriesStore.sync();
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
    const valueInQuarterMillions = value * 4;
    let result = await governanceStore.createPlayer(
      selectedClubId,
      selectedPosition,
      firstName,
      lastName,
      shirtNumber,
      valueInQuarterMillions,
      dateOfBirth,
      nationalityId
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
    selectedPosition = { Goalkeeper: null };
    firstName = "";
    lastName = "";
    dateOfBirth = "";
    shirtNumber = 0;
    value = 0;
    nationalityId = 0;
  }

  function cancelModal() {
    resetForm();
    closeModal();
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Create Player</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <div class="w-full flex-col space-y-4 mb-2">
        <div class="flex-col space-y-2">
          <p>Select Club:</p>

          <select
            class="p-2 fpl-dropdown min-w-[100px]"
            bind:value={selectedClubId}
          >
            <option value={0}>Select Club</option>
            {#each $teamStore as club}
              <option value={club.id}>{club.friendlyName}</option>
            {/each}
          </select>
        </div>
        <div class="flex-col space-y-2">
          <p>Select Position:</p>
          <select
            class="p-2 fpl-dropdown my-4 min-w-[100px]"
            bind:value={selectedPosition}
          >
            <option value={{ Goalkeeper: null }}>Goalkeeper</option>
            <option value={{ Defender: null }}>Defender</option>
            <option value={{ Midfielder: null }}>Midfielder</option>
            <option value={{ Forward: null }}>Forward</option>
          </select>
        </div>
        <div class="flex-col space-y-2">
          <p class="py-2">First Name:</p>

          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="First Name"
            bind:value={firstName}
          />
        </div>
        <div class="flex-col space-y-2">
          <p class="py-2">Last Name:</p>

          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="First Name"
            bind:value={lastName}
          />
        </div>
        <div class="flex-col space-y-2">
          <p class="py-2">Shirt Number:</p>

          <input
            type="number"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="Shirt Number"
            min="1"
            max="99"
            step="1"
            bind:value={shirtNumber}
          />
        </div>
        <div class="flex-col space-y-2">
          <p class="py-2">Value (£m):</p>

          <input
            type="number"
            step="0.25"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="Value"
            bind:value
          />
        </div>
        <div class="flex-col space-y-2">
          <p class="py-2">Date of Birth:</p>

          <input
            type="date"
            bind:value={dateOfBirth}
            class="input input-bordered"
          />
        </div>
        <div class="flex-col space-y-2">
          <p class="py-2">Nationality:</p>

          <select
            class="p-2 fpl-dropdown min-w-[100px] mb-2"
            bind:value={nationalityId}
          >
            
            <option value={0}>Select Nationality</option>
            {#each $countriesStore as country}
              <option value={country.id}>{country.name}</option>
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
