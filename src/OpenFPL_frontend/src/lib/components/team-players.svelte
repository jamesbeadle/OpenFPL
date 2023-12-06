<script lang="ts">
  import { Position } from "$lib/enums/Position";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import {
    calculateAgeFromNanoseconds,
    getFlagComponent,
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
        <div class="flex items-center ml-4">
          <p class="text-sm md:text-xl mr-4">Position:</p>
          <select
            class="p-2 fpl-dropdown text-xs sm:text-sm md:text-base text-center mx-0 md:mx-2 min-w-[100px] "
            bind:value={selectedPosition}
          >
            <option value={-1}>All</option>
            {#each positionValues as position}
              <option value={position}>{getPositionText(position)}</option>
            {/each}
          </select>
        </div>
      </div>
      <div
        class="flex justify-between p-2 border-b border-gray-700 py-4 bg-light-gray"
      >
        <div class="flex-grow px-4 w-1/2">Number</div>
        <div class="flex-grow px-4 w-1/2">First Name</div>
        <div class="flex-grow px-4 w-1/2">Last Name</div>
        <div class="flex-grow px-4 w-1/2">Position</div>
        <div class="flex-grow px-4 w-1/2">Age</div>
        <div class="flex-grow px-4 w-1/2">Nationality</div>
        <div class="flex-grow px-4 w-1/2">Season Points</div>
        <div class="flex-grow px-4 w-1/2">Value</div>
      </div>
      {#each filteredPlayers as player}
        <div
          class="flex items-center justify-between py-2 border-b border-gray-700 text-white cursor-pointer"
        >
          <a
            class="flex-grow flex items-center justify-start space-x-2 px-4"
            href={`/player?id=${player.id}`}
          >
            <div class="flex items-center w-1/2 px-3">
              {player.shirtNumber === 0 ? "-" : player.shirtNumber}
            </div>
            <div class="flex items-center w-1/2 px-3">
              {player.firstName === "" ? "-" : player.firstName}
            </div>
            <div class="flex items-center w-1/2 px-3">
              {player.lastName}
            </div>
            <div class="flex items-center w-1/2 px-3">
              {getPositionText(player.position)}
            </div>
            <div class="flex items-center w-1/2 px-3">
              {calculateAgeFromNanoseconds(Number(player.dateOfBirth))}
            </div>
            <div class="flex items-center w-1/2 px-3">
              <svelte:component
                this={getFlagComponent(player.nationality)}
                class="w-10 h-10"
                size="100"
              />
            </div>
            <div class="flex items-center w-1/2 px-3">
              {player.totalPoints}
            </div>
            <div class="flex items-center w-1/2 px-3">
              £{(Number(player.value) / 4).toFixed(2)}m
            </div>
          </a>
        </div>
      {/each}
    </div>
  </div>
</div>
