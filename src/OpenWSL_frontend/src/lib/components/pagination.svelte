<script lang="ts">
  export let currentPage: number;
  export let totalPages: number;
  export let onPageChange: (page: number) => void;

  const pages = Array.from({ length: totalPages }, (_, i) => i + 1);
</script>

<div class="flex justify-center mt-4">
  <button
    class="px-3 py-1 mx-1 text-sm border rounded-md hover:bg-gray-200"
    on:click={() => onPageChange(currentPage - 1)}
    disabled={currentPage === 1}
  >
    Previous
  </button>
  
  {#each pages as page}
    <button
      class="px-3 py-1 mx-1 text-sm border rounded-md hover:bg-gray-200 {page === currentPage ? 'bg-gray-300' : ''}"
      on:click={() => onPageChange(page)}
    >
      {page}
    </button>
  {/each}
  
  <button
    class="px-3 py-1 mx-1 text-sm border rounded-md hover:bg-gray-200"
    on:click={() => onPageChange(currentPage + 1)}
    disabled={currentPage === totalPages}
  >
    Next
  </button>
</div>
