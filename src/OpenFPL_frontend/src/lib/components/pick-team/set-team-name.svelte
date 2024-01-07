<script lang="ts">
  import { Modal } from "@dfinity/gix-components";

  export let visible: boolean;
  export let setUsername: () => void;
  export let cancelModal: () => void;
  export let newUsername: string = "";

  function isDisplayNameValid(displayName: string): boolean {
    if (!displayName) {
      return false;
    }

    if (displayName.length < 3 || displayName.length > 20) {
      return false;
    }

    return /^[a-zA-Z0-9 ]+$/.test(displayName);
  }

  function isDisplayNameAvailable(displayName: string): boolean{
    return false;
  }

  $: isSubmitDisabled = !isDisplayNameValid(newUsername) && isDisplayNameAvailable(newUsername);

</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Set Fantasy Team Name</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>
    <p>Please enter a team name for the OpenFPL leaderboards:</p>
    <form on:submit|preventDefault={setUsername}>
      <div class="mt-4">
        <input
          type="text"
          class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
          placeholder="New Team Name"
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
</Modal>
