<script lang="ts">
  export let show = false;
  export let onConfirm: () => void;
  export let closeModal: () => void;

  function handleKeydown(event: KeyboardEvent): void {
    if (!(event.target instanceof HTMLInputElement) && event.key === "Escape") {
      closeModal();
    }
  }
</script>

{#if show}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={closeModal}
    on:keydown={handleKeydown}
    role="dialog"
  >
    <div
      class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
      on:click|stopPropagation
      on:keydown={handleKeydown}
    >
      <div class="mt-3 text-center">
        <h3 class="text-lg leading-6 font-medium mb-2">
          Please confirm you want to clear the draft from your cache.
        </h3>
      </div>

      <div class="items-center py-3 flex space-x-4">
        <button
          class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
          on:click={closeModal}
        >
          Cancel
        </button>
        <button
          class="px-4 py-2 fpl-purple-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
          on:click={onConfirm}
        >
          Clear
        </button>
      </div>
    </div>
  </div>
{/if}
