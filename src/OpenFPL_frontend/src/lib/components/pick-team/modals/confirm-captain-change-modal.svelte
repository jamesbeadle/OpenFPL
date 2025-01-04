<script lang="ts">
  import Modal from "$lib/components/shared/modal.svelte";
  export let visible = false;
  export let onConfirm: () => void;
  export let newCaptain = "";

  function onClose() {
    visible = false;
  }
</script>

<Modal showModal={visible} onClose={onClose} title="Captain Change">
  <div>
    <div class="my-5">
      <h1>Please confirm your captain change to {newCaptain}</h1>
      <p class="text-sm mt-2">
        This will only take effect after you save your team.
      </p>
    </div>
    <div class="flex justify-end gap-3">
      <button
        class="default-button fpl-cancel-btn"
        type="button"
        on:click={onClose}>Cancel</button
      >
      <button class="default-button fpl-button" on:click={onConfirm}>Confirm</button>
    </div>
  </div>
</Modal>
