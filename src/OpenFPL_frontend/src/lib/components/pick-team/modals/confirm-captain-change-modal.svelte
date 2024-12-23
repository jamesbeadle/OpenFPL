<script lang="ts">
    import Modal from "$lib/components/shared/modal.svelte";
  import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
  export let visible = false;
  export let onConfirm: () => void;
  export let onClose: () => void;
  export let newCaptain = "";
</script>

<Modal showModal={visible} onClose={onClose} title="Captain Change">
  <div class="p-4">
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
