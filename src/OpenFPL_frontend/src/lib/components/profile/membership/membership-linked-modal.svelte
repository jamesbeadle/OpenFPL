<script lang="ts">
    import { goto } from "$app/navigation";
    import Modal from "../../shared/global/modal.svelte";
    
    interface Props {
      onClose: () => void;
    }
    let { onClose }: Props = $props();

    function begin() {
      goto('/');
    }
    
</script>

<Modal {onClose} title="Membership Linked">
  <p>Congratulations your membership is now linked, you can begin using OpenFPL.</p>
  <button class="brand-button" onclick={begin}>Begin</button>
</Modal>
