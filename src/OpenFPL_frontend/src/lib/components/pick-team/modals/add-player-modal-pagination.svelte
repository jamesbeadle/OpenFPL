<script lang="ts">
    import type { Writable } from "svelte/store";
    import type { PlayerDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    export let filteredPlayers: PlayerDTO[];
    export let currentPage: Writable<number>;
    const pageSize = 10;

    function goToPage(page: number) {
        $currentPage = page;
    }

</script>

<div class="justify-center mt-4 pb-4 overflow-x-auto">
    <div class="flex space-x-1 min-w-max">
      {#each Array(Math.ceil(filteredPlayers.length / pageSize)) as _, index}
        <button
          class={`px-4 py-2 rounded-md ${
            index + 1 === $currentPage ? "fpl-button" : ""
          }`}
          on:click={() => goToPage(index + 1)}
        >
          {index + 1}
        </button>
      {/each}
    </div>
  </div>