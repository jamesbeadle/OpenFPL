<script lang="ts">
    import { toasts } from "$lib/stores/toasts-store";
  import { userStore } from "$lib/stores/user-store";
  import Modal from "$lib/components/shared/modal.svelte";
    import WidgetSpinner from "../shared/widget-spinner.svelte";

  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  export let newUsername: string = "";

  let isLoading = false;

  function isDisplayNameValid(displayName: string): boolean {
    if (!displayName) {
      return false;
    }

    if (displayName.length < 3 || displayName.length > 20) {
      return false;
    }

    return /^[a-zA-Z0-9 ]+$/.test(displayName);
  }

  $: isSubmitDisabled = !isDisplayNameValid(newUsername);

  async function updateUsername() {
    isLoading=true;
    try {
      await userStore.updateUsername(newUsername);
      await userStore.sync();
      await closeModal();
      toasts.addToast({
        message: "Username updated.",
        type: "success",
        duration: 2000,
      });
    } catch (error) {
      toasts.addToast({
        message:  "Error updating username.",
        type: "error",
      });
      console.error("Error updating username:", error);
      cancelModal();
    } finally {
      isLoading = false;
    }
  }
</script>

<Modal showModal={visible} onClose={cancelModal} title="Update Username">
  {#if isLoading}
    <WidgetSpinner />
  {:else}
  <div class="mx-4 p-4">
    <form on:submit|preventDefault={updateUsername}>
      <div class="mt-4">
        <input
          type="text"
          class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
          placeholder="New Username"
          bind:value={newUsername}
        />
      </div>
      <div class="items-center py-3 flex space-x-4 flex-row">
        <button
          class="px-4 py-2 default-button fpl-cancel-btn"
          type="button"
          on:click={cancelModal}
        >
          Cancel
        </button>
        <button
          class={`px-4 py-2 ${
            isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"
          } default-button fpl-purple-btn`}
          type="submit"
          disabled={isSubmitDisabled}
        >
          Update
        </button>
      </div>
    </form>
  </div>
  {/if}
</Modal>
