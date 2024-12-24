<script lang="ts">
    import Modal from "$lib/components/shared/modal.svelte";
  import { userStore } from "$lib/stores/user-store";
  import type { Writable } from "svelte/store";

  export let visible: boolean;
  export let setUsername: () => void;
  export let cancelModal: () => void;
  export let newUsername: Writable<string>;

  let isUsernameAvailable = false;

  function isDisplayNameValid(displayName: string): boolean {
    if (!displayName) {
      return false;
    }

    if (displayName.length < 3 || displayName.length > 20) {
      return false;
    }

    return /^[a-zA-Z0-9 ]+$/.test(displayName);
  }

  async function checkDisplayNameAvailability(displayName: string) {
    if (isDisplayNameValid(displayName)) {
      isUsernameAvailable = await isDisplayNameAvailable(displayName);
    } else {
      isUsernameAvailable = false;
    }
  }

  async function isDisplayNameAvailable(displayName: string): Promise<boolean> {
    return await userStore.isUsernameAvailable(displayName);
  }

  $: checkDisplayNameAvailability($newUsername);
  $: isSubmitDisabled =
    !isDisplayNameValid($newUsername) || !isUsernameAvailable;
</script>

<Modal showModal={visible} onClose={cancelModal} title="Set Fantasy Team Name">
  <div class="mx-4 p-4">
    <p>Please enter a team name for the OpenFPL leaderboards:</p>
    <form on:submit|preventDefault={setUsername}>
      <div class="mt-4">
        <input
          type="text"
          class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
          placeholder="New Team Name"
          bind:value={$newUsername}
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
            isSubmitDisabled ? "bg-gray-500" : "bg-BrandPurple"
          } default-button`}
          type="submit"
          disabled={isSubmitDisabled}
        >
          Update
        </button>
      </div>
    </form>
  </div>
</Modal>
