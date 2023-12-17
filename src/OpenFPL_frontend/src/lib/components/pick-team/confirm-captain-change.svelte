<script lang="ts">
  import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
  import { Modal } from "@dfinity/gix-components";
  export let visible = false;
  export let onConfirm: () => void;
  export let onClose: () => void;
  export let newCaptain = "";
</script>

<Modal {visible} on:nnsClose={onClose}>
  <div class="p-4">
    <div class="flex justify-between items-center my-2">
      <h4 class="flex items-center">
        <ActiveCaptainIcon className="w-6 mr-2" />Captain Change
      </h4>
      <button class="text-black" on:click={onClose}>✕</button>
    </div>
    <div class="my-5">
      <h1>Please confirm your captain change to {newCaptain}</h1>
      <p class="text-gray-600">
        This will only take effect after you save your team.
      </p>
    </div>
    <div class="flex justify-end gap-3">
      <button
        class="default-button fpl-cancel-btn"
        type="button"
        on:click={onClose}>Cancel</button
      >
      <button class="default-button fpl-button" on:click={onConfirm}
        >Confirm</button
      >
    </div>
  </div>
</Modal>
