<script lang="ts">
  export let currentPage: number;
  export let totalPages: number;
  export let onPageChange: (page: number) => void;

  let firstVisiblePage = 1;

  $: if (currentPage !== firstVisiblePage) {
    firstVisiblePage = currentPage;
  }

  function goTo(page: number) {
    page = Math.max(1, Math.min(page, totalPages));

    onPageChange(page);

    firstVisiblePage = page;
    currentPage = page;
  }

  function previous() {
    if (firstVisiblePage > 1) {
      goTo(firstVisiblePage - 1);
    }
  }

  function next() {
    if (firstVisiblePage < totalPages) {
      goTo(firstVisiblePage + 1);
    }
  }

  function getPages(): Array<number | '…'> {
    const pages: Array<number | '…'> = [];

    let end = firstVisiblePage + 2;
    if (end > totalPages) {
      end = totalPages;
    }

    for (let p = firstVisiblePage; p <= end; p++) {
      pages.push(p);
    }

    if (end < totalPages) {
      pages.push('…');
      pages.push(totalPages);
    }

    return pages;
  }
</script>

<div class="flex flex-wrap items-center justify-center my-4 gap-1">
  <button
    on:click={previous}
    disabled={currentPage <= 1}
    class="px-3 py-1 mx-1 text-sm border rounded-md hover:bg-gray-200 disabled:opacity-50"
  >
    Previous
  </button>

  {#each getPages() as page}
    {#if page === '…'}
      <span class="px-3 py-1 text-sm mx-1">…</span>
    {:else}
      <button
        class="px-3 py-1 mx-1 text-sm border rounded-md hover:bg-gray-200"
        class:selected={page === currentPage}
        on:click={() => goTo(page)}
      >
        {page}
      </button>
    {/if}
  {/each}

  <button
    on:click={next}
    disabled={currentPage >= totalPages}
    class="px-3 py-1 mx-1 text-sm border rounded-md hover:bg-gray-200 disabled:opacity-50"
  >
    Next
  </button>
</div>

<style>
  .selected {
    background-color: #7F56F1;
    color: white;
    border-color: #7F56F1;
  }
</style>
