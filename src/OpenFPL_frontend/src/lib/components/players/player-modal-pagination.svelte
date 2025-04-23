<script lang="ts">
    import type { Player } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    interface Props {
      filteredPlayers: Player[];
      currentPage: number;
    }
    let { filteredPlayers, currentPage  }: Props = $props();

    const pageSize = 10;
    
    function goToPage(page: number) {
        currentPage = page;
    }

</script>

<div class="justify-center pb-4 mt-4 overflow-x-auto">
    <div class="flex space-x-1 min-w-max">
      {#each Array(Math.ceil(filteredPlayers.length / pageSize)) as _, index}
        <button
          class={`px-4 py-2 rounded-md ${
            index + 1 === currentPage ? "fpl-button" : ""
          }`}
          onclick={() => goToPage(index + 1)}
        >
          {index + 1}
        </button>
      {/each}
    </div>
  </div>