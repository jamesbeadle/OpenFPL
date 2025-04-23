<script lang="ts">
    import type { GameweekData } from "$lib/interfaces/GameweekData";
    import type { Writable } from "svelte/store";
    import { convertPositionToIndex, getPlayerName, getPositionAbbreviation } from "$lib/utils/helpers";
    import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
    
    interface Props {
      gameweekData: Writable<GameweekData[]>;
      showDetailModal: (gameweekData: GameweekData) => void;
    }
    let { gameweekData, showDetailModal }: Props = $props();

</script>
<div class="flex flex-col">
    <div class="flex-1 overflow-x-auto">
      <div class="flex justify-between p-4 border-t border-b border-BrandGray lg:text-center bg-BrandGray/60 lg:px-10">
        <div class="w-2/12 xs:w-2/12">Pos</div>
        <div class="w-6/12 xs:w-4/12">Player</div>
        <div class="w-3/12 xs:w-3/12">Points</div>
        <div class="w-2/12 xs:w-3/12">&nbsp;</div>
      </div>
      {#if $gameweekData.length > 0}
        {#each $gameweekData as playerGameweek}
          <button
            class="flex justify-between w-full p-4 text-center border-b cursor-pointer border-BrandGray lg:text-center lg:px-10"
            onclick={() => showDetailModal(playerGameweek)}
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
            <div class="w-2/12 xs:w-3/12">{playerGameweek.points}</div>
            <div
              class="flex items-center justify-center w-2/12 xs:w-3/12 xs:justify-start"
            >
              <span class="flex items-center">
                <ViewDetailsIcon className="w-5 xs:w-6 lg:w-7" /><span
                  class="hidden ml-1 xs:flex lg:ml-2">View Details</span
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