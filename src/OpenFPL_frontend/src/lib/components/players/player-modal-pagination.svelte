<script lang="ts">
    import type { Writable } from "svelte/store";
    import type { PlayerDTO } from "../../../../../external_declarations/data_canister/data_canister.did";
    export let filteredPlayers: PlayerDTO[];
    export let currentPage: Writable<number>;
    export let onPageChange: () => void;
    const pageSize = 10;

    function goToPage(page: number) {
        $currentPage = page;
        onPageChange();
    }

</script>

<div class="justify-center pb-4 mt-4 overflow-x-auto">
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