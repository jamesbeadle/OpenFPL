<script lang="ts">
  import { formatE8s } from "$lib/utils/Helpers";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";

  interface Props {
    leaderboard: any;
    selectedGameweek: number;
  }
  let { leaderboard, selectedGameweek }: Props = $props();

</script>

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
    {:else}
      <p class="w-full p-4">No leaderboard data.</p>
    {/if}
  </div>
</div>