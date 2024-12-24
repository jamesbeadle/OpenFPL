<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { clubStore } from "$lib/stores/club-store";
  import { storeManager } from "$lib/managers/store-manager";
    import { toasts } from "$lib/stores/toasts-store";
    import Modal from "$lib/components/shared/modal.svelte";

  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  export let newFavouriteTeam: number = 0;

  let isLoading = true;

  let isSubmitDisabled: boolean = true;
  $: isSubmitDisabled = newFavouriteTeam <= 0;

  onMount(async () => {
    await storeManager.syncStores();
    await userStore.sync();
  });

  async function updateFavouriteTeam() {
    isLoading = true;

    try {
      await userStore.updateFavouriteTeam(newFavouriteTeam);
      await userStore.sync();
      await closeModal();
      toasts.addToast({
        message: "Favourite team updated.",
        type: "success",
        duration: 2000,
      });
    } catch (error) {
      toasts.addToast({
        message: "Error updating favourite team.",
        type: "error",
      });
      console.error("Error updating favourite team:", error);
      cancelModal();
    } finally {
      isLoading = false;
    }
  }
</script>

<Modal showModal={visible} onClose={cancelModal} title="Update Favourite Team">
  {#if isLoading}

  {:else}
    <div class="mx-4 p-4">
      <div class="w-full border border-gray-500 mt-4 mb-2">
        <select
          bind:value={newFavouriteTeam}
          class="w-full p-2 rounded-md fpl-dropdown"
        >
          <option value={0}>Select Team</option>
          {#each $clubStore as team}
            <option value={team.id}>{team.friendlyName}</option>
          {/each}
        </select>
      </div>

      <div
        class="bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-1 mt-4"
        role="alert"
      >
        <p>Warning</p>
        <p>You can only set your favourite team once per season.</p>
      </div>

      <div class="items-center py-3 flex space-x-4">
        <button
          class="px-4 py-2 default-button fpl-cancel-btn"
          type="button"
          on:click={cancelModal}
        >
          Cancel
        </button>
        <button
          class={`px-4 py-2 ${
            isSubmitDisabled ? "bg-gray-500" : "bg-BrandPurple"
          } 
          default-button bg-BrandPurplebtn`}
          on:click={updateFavouriteTeam}
          disabled={isSubmitDisabled}>Update</button
        >
      </div>
    </div>
  {/if}
</Modal>
