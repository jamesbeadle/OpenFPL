<script lang="ts">
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import { onMount } from "svelte";
  import {
    calculateAgeFromNanoseconds,
    convertPositionToIndex,
    getFlagComponent,
    getPositionAbbreviation
  } from "../../utils/helpers";
  import { playerStore } from "$lib/stores/player-store";
  import { writable } from "svelte/store";
  import PositionFilter from "../shared/position-filter.svelte";
  import TeamPlayersTableHeader from "./team-players-table-header.svelte";
  import type { Player__1 } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  export let clubId;

  onMount(async () => {
    players = $playerStore.filter((x) => x.clubId == clubId)
  });

  let players: Player__1[] = [];
  let selectedPosition = writable(-1);
  $: filteredPlayers = $selectedPosition === -1
      ? players
      : players.filter(
          (p) => convertPositionToIndex(p.position) === $selectedPosition
        );
  
</script>

<div class="flex flex-col">
    <PositionFilter {selectedPosition} />

    <TeamPlayersTableHeader />
    {#each filteredPlayers as player}
      <div class="flex items-center p-2 px-4 text-white border-b border-gray-700 cursor-pointer xs:py-3 md:py-4">
        <a class="flex items-center justify-start flex-grow" href={`/player?id=${player.id}`}>
          <div class="flex items-center w-2/12">
            {player.shirtNumber === 0 ? "-" : player.shirtNumber}
          </div>
          <div class="flex items-center w-2/12">
            {getPositionAbbreviation(convertPositionToIndex(player.position))}
          </div>
          <div class="flex items-center w-6/12 sm:w-4/12 lg:w-3/12 xl:w-3/12">
            <svelte:component
              this={getFlagComponent(player.nationality)}
              class="hidden w-4 h-4 mr-2 xs:flex"
            />
            {player.firstName}
            {player.lastName}
          </div>
          <div class="items-center hidden w-1/12 xl:flex">
            {calculateAgeFromNanoseconds(Number(player.dateOfBirth))}
          </div>
          <div class="items-center hidden w-2/12 sm:flex">
            £{(player.valueQuarterMillions / 4).toFixed(2)}m
          </div>
          <div class="items-center hidden w-1/12 lg:flex">
            {0} <!-- //TODO - Why no points -->
          </div>
          <div class="flex justify-center w-2/12 xl:justify-start xl:w-1/12">
            <ViewDetailsIcon className="w-4 sm:w-5 md:w-6 xl:w-7" />
          </div>
        </a>
      </div>
    {/each}
</div>
