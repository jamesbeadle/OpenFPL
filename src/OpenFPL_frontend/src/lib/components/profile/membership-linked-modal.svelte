<script lang="ts">
    import { goto } from "$app/navigation";
    import Modal from "../shared/modal.svelte";
    
    export let visible: boolean = false;

    function begin() {
      goto('/');
    }

    function onClose(){
      visible = false;
    }
</script>

<Modal showModal={visible} {onClose} title="Membership Linked">
  <p>Congratulations your membership is now linked, you can begin using OpenFPL.</p>
  <button class="brand-button" on:click={begin}>Begin</button>
</Modal>
