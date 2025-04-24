<script lang="ts">
  import Modal from "$lib/components/shared/global/modal.svelte";

  interface Props {
    visible: boolean;
    onConfirm: () => void;
    newCaptain : string;
  }
  let { visible, onConfirm, newCaptain }: Props = $props();


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
        onclick={onClose}>Cancel</button
      >
      <button class="default-button fpl-button" onclick={onConfirm}>Confirm</button>
    </div>
  </div>
</Modal>
