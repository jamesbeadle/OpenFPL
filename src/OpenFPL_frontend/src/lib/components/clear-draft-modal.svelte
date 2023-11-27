<script lang="ts">
    export let show = false;
    export let onHide: () => void;
    export let onConfirm: () => void;
  </script>
  
  {#if show}
    <div class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full">
      <div class="relative top-20 mx-auto p-5 border w-3/4 shadow-lg rounded-md bg-white">
        <div class="flex justify-between items-center">
          <h4 class="text-lg font-bold">Confirm Clear Draft</h4>
          <button class="text-black" on:click={onHide}>✕</button>
        </div>
        <div class="my-5">
          <h1>Please confirm you want to clear the draft from your cache.</h1>
        </div>
        <div class="flex justify-end gap-3">
          <button class="px-4 py-2 border rounded text-black" on:click={onHide}>Cancel</button>
          <button class="px-4 py-2 bg-blue-500 text-white rounded" on:click={onConfirm}>Confirm</button>
        </div>
      </div>
    </div>
  {/if}
  