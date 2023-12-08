<script lang="ts">
  import { Modal } from "@dfinity/gix-components";

  export let visible = false;
  export let onConfirm: () => void;
  export let closeModal: () => void;
</script>

<Modal {visible} on:nnsClose={closeModal}>
  <div class="p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Clear Draft</h3>
      <button class="times-button" on:click={closeModal}>&times;</button>
    </div>

    <p>Please confirm you want to clear the draft from your cache.</p>

    <div class="items-center py-3 flex space-x-4">
      <button
        class="px-4 py-2 fpl-cancel-btn text-white rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        on:click={closeModal}
      >
        Cancel
      </button>
      <button
        class="px-4 py-2 fpl-purple-btn text-white rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        on:click={onConfirm}
      >
        Clear
      </button>
    </div>
  </div>
</Modal>
