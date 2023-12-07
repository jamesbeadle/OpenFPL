<script lang="ts">
  import { Position } from "$lib/enums/Position";
    import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import {
    calculateAgeFromNanoseconds,
    getFlagComponent,
    getPositionAbbreviation,
    getPositionText,
  } from "../utils/Helpers";
  export let players: PlayerDTO[] = [];
  let selectedPosition = -1;
  $: filteredPlayers =
    selectedPosition === -1
      ? players
      : players.filter((p) => p.position === selectedPosition);
  let positionValues: number[] = Object.values(Position).filter(
    (value) => typeof value === "number"
  ) as number[];
</script>

<div class="container-fluid">
  <div class="flex flex-col space-y-4">
    <div>
      <div class="flex p-4">
        <div class="flex items-center">
          <p class="text-sm md:text-xl">Position:</p>
          <select
            class="px-2 fpl-dropdown text-xs xs:text-sm md:text-base text-center mx-0 md:mx-2 min-w-[100px]"
            bind:value={selectedPosition}
          >
            <option value={-1}>All</option>
            {#each positionValues as position}
              <option value={position}>{getPositionText(position)}</option>
            {/each}
          </select>
        </div>
      </div>
      <div class="flex border-b border-gray-700 bg-light-gray text-xs xs:text-sm md:text-base p-2 xs:py-3 md:py-4 px-4">
        <div class="flex sm:hidden w-2/12">No.</div>
        <div class="hidden sm:flex w-2/12">Number</div>
        <div class="flex sm:hidden w-2/12">Pos.</div>
        <div class="hidden sm:flex w-2/12">Position</div>
        <div class="flex w-6/12 sm:w-4/12 lg:w-3/12 xl:w-3/12">Player Name</div>
        <div class="hidden xl:flex w-1/12">Age</div>
        <div class="hidden sm:flex w-2/12">Value</div>
        <div class="hidden lg:flex w-1/12">Points</div>
        <div class="flex 2/12 xl:w-1/12">&nbsp;</div>
      </div>
      {#each filteredPlayers as player}
        <div class="flex items-center p-2 xs:py-3 md:py-4 px-4 border-b border-gray-700 text-white cursor-pointer text-xs xs:text-sm md:text-base">
          <a
            class="flex-grow flex items-center justify-start"
            href={`/player?id=${player.id}`}
          >
            <div class="flex items-center w-2/12">
              {player.shirtNumber === 0 ? "-" : player.shirtNumber}
            </div>
            <div class="flex items-center w-2/12">
              {getPositionAbbreviation(player.position)}
            </div>
            <div class="flex items-center w-6/12 sm:w-4/12 lg:w-3/12 xl:w-3/12">
              <svelte:component
                this={getFlagComponent(player.nationality)}
                class="w-4 h-4 mr-2 hidden xs:flex"
              />
              {player.firstName} {player.lastName}
            </div>
            <div class="hidden xl:flex items-center w-1/12">
              {calculateAgeFromNanoseconds(Number(player.dateOfBirth))}
            </div>
            <div class="hidden sm:flex items-center w-2/12">
              £{(Number(player.value) / 4).toFixed(2)}m
            </div>
            <div class="hidden lg:flex items-center w-1/12">
              {player.totalPoints}
            </div>
            <div class="flex w-2/12 justify-center xl:justify-start xl:w-1/12">
              <ViewDetailsIcon className='w-4 sm:w-5 md:w-6 xl:w-7' />
            </div>
          </a>
        </div>
      {/each}
    </div>
  </div>
</div>
