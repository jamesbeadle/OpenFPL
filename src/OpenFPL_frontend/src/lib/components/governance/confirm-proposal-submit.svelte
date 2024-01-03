<script lang="ts">
  import { Modal } from "@dfinity/gix-components";

  export let visible = false;
  export let onConfirm: () => void;
  export let closeModal: () => void;

  export let proposalTitle: string;

</script>

<Modal {visible} on:nnsClose={closeModal}>
  <div class="p-4">
    <div class="flex justify-between items-center my-2">
      <h4>Confirm Proposal Submission</h4>
      <button class="text-black" on:click={closeModal}>✕</button>
    </div>
    <div class="my-5">
      <h1>{proposalTitle}</h1>
      <p class="text-gray-600">
        Failed proposals will cost you 10 $FPL.
      </p>
    </div>
    <div class="flex justify-end gap-3">
      <button
        class="default-button fpl-cancel-btn"
        type="button"
        on:click={closeModal}>Cancel</button
      >
      <button class="default-button fpl-button" on:click={onConfirm}
        >Confirm</button
      >
    </div>
  </div>
</Modal>
