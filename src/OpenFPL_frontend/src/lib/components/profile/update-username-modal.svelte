<script lang="ts">
  import { userStore } from "$lib/stores/user-store";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import { loadingText } from "$lib/stores/global-stores";
  import { Modal } from "@dfinity/gix-components";

  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  export let newUsername: string = "";
  export let isLoading: boolean;

  function isDisplayNameValid(displayName: string): boolean {
    if (displayName.length < 3 || displayName.length > 20) {
      return false;
    }

    return /^[a-zA-Z0-9 ]+$/.test(displayName);
  }

  $: isSubmitDisabled = !isDisplayNameValid(newUsername);

  async function updateUsername() {
    isLoading = true;
    loadingText.set("Updating Display Name");
    try {
      await userStore.updateUsername(newUsername);
      userStore.sync();
      await closeModal();
      toastsShow({
        text: "Display name updated.",
        level: "success",
        duration: 2000,
      });
    } catch (error) {
      toastsError({
        msg: { text: "Error updating username." },
        err: error,
      });
      console.error("Error updating username:", error);
      cancelModal();
    } finally {
      isLoading = false;
      loadingText.set("Loading");
    }
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mt-3 text-center">
    <h3 class="text-lg leading-6 font-medium mb-2">Update Display Name</h3>
    <form on:submit|preventDefault={updateUsername}>
      <div class="mt-4">
        <input
          type="text"
          class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
          placeholder="New Username"
          bind:value={newUsername}
        />
      </div>
      <div class="items-center py-3 flex space-x-4">
        <button
          class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
          on:click={cancelModal}
        >
          Cancel
        </button>
        <button
          class={`px-4 py-2 ${
            isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"
          } text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
          type="submit"
          disabled={isSubmitDisabled}
        >
          Update
        </button>
      </div>
    </form>
  </div>
</Modal>
