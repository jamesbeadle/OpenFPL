<script lang="ts">
  import { userStore } from "$lib/stores/user-store";
  import { toastStore } from "$lib/stores/toast-store";
  import type { Writable } from "svelte/store";
  import { loadingText } from "$lib/stores/global-stores";

  export let showModal: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  export let newUsername: string = "";
  export let isLoading: Writable<boolean | null>;

  function isDisplayNameValid(displayName: string): boolean {
    if (displayName.length < 3 || displayName.length > 20) {
      return false;
    }

    return /^[a-zA-Z0-9 ]+$/.test(displayName);
  }

  $: isSubmitDisabled = !isDisplayNameValid(newUsername);

  async function updateUsername() {
    isLoading.set(true);
    loadingText.set("Updating Display Name");
    try {
      await userStore.updateUsername(newUsername);
      await closeModal();
      toastStore.show("Display name updated.", "success");
    } catch (error) {
      toastStore.show("Error updating username.", "error");
      console.error("Error updating username:", error);
      cancelModal();
    } finally {
      isLoading.set(false);
      loadingText.set("Loading");
    }
  }

  function handleKeydown(event: KeyboardEvent): void {
    if (!(event.target instanceof HTMLInputElement) && event.key === "Escape") {
      closeModal();
    }
  }
</script>

{#if showModal}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={cancelModal}
    on:keydown={handleKeydown}
  >
    <div
      class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
      on:click|stopPropagation
      on:keydown={handleKeydown}
    >
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
              Use
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-backdrop {
    z-index: 1000;
  }
</style>
