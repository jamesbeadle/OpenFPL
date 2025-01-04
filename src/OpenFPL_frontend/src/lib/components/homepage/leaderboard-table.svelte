
<script lang="ts">
    import { formatE8s } from "$lib/utils/helpers";
    import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
    import Pagination from "../shared/pagination.svelte";
    import type { Writable } from "svelte/store";
  
    export let leaderboard: any;

    export let selectedGameweek: Writable<number>;
    export let currentPage: Writable<number>;
    export let totalPages: Writable<number>;

    export let changePage: (delta: number) => void;
    
</script>

<div class="flex flex-col">
    <div class="overflow-x-auto flex-1">
      <div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray">
        <div class="w-2/12 xs:w-2/12 px-4">Pos</div>
        <div class="w-3/12 xs:w-4/12 px-4">Manager</div>
        <div class="w-2/12 xs:w-2/12 px-4">Points</div>
        <div class="w-2/12 xs:w-2/12 px-4">FPL</div>
        <div class="w-3/12 xs:w-1/12 px-4">&nbsp;</div>
      </div>

      {#if leaderboard && leaderboard.entries && leaderboard.entries.length > 0}
        {#each leaderboard.entries as entry}
          <a href={`/manager?id=${entry.principalId}&gw=${$selectedGameweek}`}>
            <div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer">
              <div class="w-2/12 xs:w-2/12 px-4">{entry.positionText}</div>
              <div class="w-3/12 xs:w-4/12 px-4"> {entry.principalId === entry.username ? "Unknown" : entry.username}</div>
              <div class="w-2/12 xs:w-2/12 px-4">{entry.points}</div>
              <div class="w-2/12 xs:w-2/12 px-4">{ entry.reward == 0 ? 0 : formatE8s(entry.reward)} FPL</div>
              <div class="w-3/12 xs:w-1/12 flex items-center justify-center xs:justify-center">
                <span class="flex items-center">
                  <ViewDetailsIcon className="w-5 xs:w-6 lg:w-7" />
                  <span class="hidden xs:flex ml-1 lg:ml-2">View Details</span>
                </span>
              </div>
            </div>
          </a>
        {/each}
        <Pagination onPageChange={changePage} {currentPage} {totalPages} />
      {:else}
        <p class="w-full p-4">No leaderboard data.</p>
      {/if}
    </div>
  </div>