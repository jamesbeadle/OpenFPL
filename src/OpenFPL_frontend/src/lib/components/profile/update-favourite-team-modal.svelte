<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { clubStore } from "$lib/stores/club-store";
  import { storeManager } from "$lib/managers/store-manager";
    import Modal from "$lib/components/shared/modal.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import { authStore } from "$lib/stores/auth-store";

  
    interface Props {
      visible: boolean; 
      newFavouriteTeam: number
    }
    let { visible, newFavouriteTeam }: Props = $props();

  let isLoading = true;

  let isSubmitDisabled: boolean = true;
  $: isSubmitDisabled = newFavouriteTeam <= 0;

  onMount(async () => {
    await storeManager.syncStores();
    await userStore.sync();
    isLoading = false;
  });

  async function updateFavouriteTeam() {
    isLoading = true;

    try {
      await userStore.updateFavouriteTeam(newFavouriteTeam, $authStore.identity?.getPrincipal().toString() ?? "");
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
  
  async function closeModal() {
    await userStore.cacheProfile();
    visible = false;
  }

  function cancelModal() {
    visible = false;
  }
</script>

<Modal showModal={visible} onClose={cancelModal} title="Update Favourite Team">
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="p-4 mx-4">
      <div class="w-full mt-4 mb-2 border border-gray-500">
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

      <div class="p-4 mt-4 mb-1 text-orange-700 bg-orange-100 border-l-4 border-orange-500" role="alert">
        <p>Warning</p>
        <p>You can only set your favourite team once per season.</p>
      </div>

      <div class="flex items-center py-3 space-x-4">
        <button class="px-4 py-2 default-button fpl-cancel-btn" type="button" on:click={cancelModal}>
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
