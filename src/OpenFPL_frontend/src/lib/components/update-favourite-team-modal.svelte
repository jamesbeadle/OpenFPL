<script lang="ts">
  export let showModal: boolean;
  export let closeModal: () => void;
</script>

{#if showModal}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={closeModal}
    on:keydown={closeModal}
  >
    <div
      class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
    >
      <div class="mt-3 text-center">
        <h3 class="text-lg leading-6 font-medium">Favourite team</h3>
        <p>Update favourite tean</p>
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-backdrop {
    z-index: 1000;
  }
</style>
