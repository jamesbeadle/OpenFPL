<script lang="ts">
    interface Props {
      pageCount: number;
      changePage : (page: number) => void;
    }
    let { pageCount, changePage }: Props = $props();

    let currentPage: number = $state(1);

    function selectPage(newPage: number){
      currentPage = newPage;
      changePage(currentPage);
    }
</script>

<div class="justify-center pb-4 mt-4 overflow-x-auto">
  <div class="flex space-x-1 min-w-max">
    {#each Array(Math.ceil(pageCount)) as _, index}
      <button 
        class={`px-4 py-2 rounded-md ${ index + 1 === currentPage ? "fpl-button" : "" }`} 
        onclick={() => selectPage(index + 1)}
      >
        {index + 1}
      </button>
    {/each}
  </div>
</div>