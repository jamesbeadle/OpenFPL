<script lang="ts">
    import type { GameweekData } from "$lib/interfaces/GameweekData";
    import type { Writable } from "svelte/store";
    import { convertPositionToIndex, getPlayerName, getPositionAbbreviation } from "$lib/utils/helpers";
    import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
    
    export let gameweekData: Writable<GameweekData[]>;
    export let showDetailModal: (gameweekData: GameweekData) => void;

</script>
<div class="flex flex-col">
    <div class="overflow-x-auto flex-1">
      <div class="flex justify-between border-b border-t border-gray-700 p-4 bg-light-gray lg:px-8">
        <div class="w-2/12 xs:w-2/12">Pos</div>
        <div class="w-6/12 xs:w-4/12">Player</div>
        <div class="w-3/12 xs:w-3/12">Points</div>
        <div class="w-2/12 xs:w-3/12">&nbsp;</div>
      </div>
      {#if $gameweekData.length > 0}
        {#each $gameweekData as playerGameweek}
          <button
            class="flex justify-between p-4 border-b border-gray-700 cursor-pointer lg:px-8 w-full"
            on:click={() => showDetailModal(playerGameweek)}
          >
            <div class="w-2/12 xs:w-2/12">
              {getPositionAbbreviation(
                convertPositionToIndex(playerGameweek.player.position)
              )}
            </div>
            <div class="w-6/12 xs:w-4/12">
              <a href={`/player?id=${playerGameweek.player.id}`}>
                {getPlayerName(playerGameweek.player)}
                </a>
            </div>
            <div class="w-3/12 xs:w-3/12">{playerGameweek.points}</div>
            <div
              class="w-2/12 xs:w-3/12 flex items-center justify-center xs:justify-start"
            >
              <span class="flex items-center">
                <ViewDetailsIcon className="w-5 xs:w-6 lg:w-7" /><span
                  class="hidden xs:flex ml-1 lg:ml-2">View Details</span
                >
              </span>
            </div>
          </button>
        {/each}
      {:else}
        <p class="w-full p-4">You have no data for the selected gameweek.</p>
      {/if}
    </div>
  </div>