<script lang="ts">
  import { formatE8s } from "$lib/utils/helpers";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import Pagination from "../../shared/pagination.svelte";

  interface Props {
    leaderboard: any;
    selectedGameweek: number;
    currentPage: number;
    totalPages: number;
    onPageChange: (page: number) => void;
    searchTerm: string;
  }
  let { leaderboard, selectedGameweek, currentPage, totalPages, onPageChange, searchTerm }: Props = $props();

  let searchInput: string = $state("");

  function executeSearch() {
    searchTerm = searchInput;
    currentPage = 1;
    onPageChange(1);
  }

  function resetSearch() {
    searchInput = "";
    searchTerm = "";
    currentPage = 1;
    onPageChange(1);
  }

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === 'Enter') {
      executeSearch();
    }
  }
</script>

<div class="px-4 mb-6">
  <div class="relative flex gap-2">
    <div class="relative flex-1">
      <input
        type="text"
        placeholder="Search by username..."
        onkeydown={handleKeydown}
        value={searchInput}
        class="w-full px-4 py-3 text-white transition-colors border border-gray-700 rounded-lg bg-BrandGray focus:outline-none focus:border-BrandGreen"
      />
      <svg class="absolute right-4 top-3.5 md:h-5 md:w-5 h-3 w-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
      </svg>
    </div>
    <button
      onclick={executeSearch}
      class="px-4 py-2 text-white transition-colors border border-gray-700 rounded-lg bg-BrandGray hover:bg-BrandGrayShade1 focus:outline-none focus:border-BrandGreen"
    >
      Search
    </button>
    <button
      onclick={resetSearch}
      class="px-4 py-2 text-white transition-colors border border-gray-700 rounded-lg bg-BrandGray hover:bg-BrandGrayShade1 focus:outline-none focus:border-BrandGreen"
    >
      Reset
    </button>
  </div>
</div>

<div class="flex flex-col overflow-hidden border border-gray-700 rounded-lg">
  <div class="flex-1 overflow-x-auto">
    <div class="flex justify-between p-2 py-4 border border-gray-700 bg-BrandGray">
      <div class="w-2/12 px-4 xs:w-2/12">Pos</div>
      <div class="w-3/12 px-4 xs:w-4/12">Manager</div>
      <div class="w-2/12 px-4 xs:w-2/12">Points</div>
      <div class="w-2/12 px-4 xs:w-2/12">Prizes</div>
      <div class="w-3/12 px-4 xs:w-1/12">&nbsp;</div>
    </div>

    {#if leaderboard && leaderboard.entries && leaderboard.entries.length > 0}
      {#each leaderboard.entries as entry}
        <a href={`/manager?id=${entry.principalId}&gw=${selectedGameweek}`}>
          <div class="flex items-center justify-between p-2 py-4 border-b border-gray-700 cursor-pointer hover:bg-BrandGrayShade1">
            <div class="w-2/12 px-4 xs:w-2/12">{entry.positionText}</div>
            <div class="w-3/12 px-4 xs:w-4/12">{entry.principalId === entry.username ? "Unknown" : entry.username}</div>
            <div class="w-2/12 px-4 xs:w-2/12">{entry.points}</div>
            <div class="w-2/12 px-4 xs:w-2/12">{entry.reward ? entry.reward == 0 ? 0 : formatE8s(entry.reward) : '-'} ICFC</div>
            <div class="flex items-center justify-center w-3/12 xs:w-1/12 xs:justify-center">
              <span class="flex items-center">
                  <ViewDetailsIcon className="w-5 xs:w-6 lg:w-7" />
                  <span class="hidden ml-1 xs:flex lg:ml-2">View Details</span>
              </span>
            </div>
          </div>
        </a>
      {/each}
      {#if leaderboard.entries.length === 0}
          <p class="w-full p-4">No managers found matching "{searchTerm}"</p>
      {:else}
        <Pagination
          {currentPage}
          {totalPages}
          {onPageChange}
        />
      {/if}
    {:else}
      <p class="w-full p-4">No leaderboard data.</p>
    {/if}
  </div>
</div>