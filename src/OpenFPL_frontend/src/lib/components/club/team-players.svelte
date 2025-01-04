<script lang="ts">
  import { Position } from "$lib/enums/Position";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
    import { onMount } from "svelte";
  import type { PlayerDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import {
    calculateAgeFromNanoseconds,
    convertPositionToIndex,
    getFlagComponent,
    getPositionAbbreviation,
    getPositionIndexToText,
  } from "../../utils/helpers";
    import { playerStore } from "$lib/stores/player-store";
    import { writable } from "svelte/store";
    import PositionFilter from "../shared/position-filter.svelte";
    import TeamPlayersTableHeader from "./team-players-table-header.svelte";
  export let clubId;


  onMount(async () => {
    players = $playerStore.filter((x) => x.clubId == clubId)
  });

  let players: PlayerDTO[] = [];
  let selectedPosition = writable(-1);
  $: filteredPlayers =
    $selectedPosition === -1
      ? players
      : players.filter(
          (p) => convertPositionToIndex(p.position) === $selectedPosition
        );
  
</script>

<div class="flex flex-col">
    <PositionFilter {selectedPosition} />

    <TeamPlayersTableHeader />
    {#each filteredPlayers as player}
      <div class="flex items-center p-2 xs:py-3 md:py-4 px-4 border-b border-gray-700 text-white cursor-pointer">
        <a class="flex-grow flex items-center justify-start" href={`/player?id=${player.id}`}>
          <div class="flex items-center w-2/12">
            {player.shirtNumber === 0 ? "-" : player.shirtNumber}
          </div>
          <div class="flex items-center w-2/12">
            {getPositionAbbreviation(convertPositionToIndex(player.position))}
          </div>
          <div class="flex items-center w-6/12 sm:w-4/12 lg:w-3/12 xl:w-3/12">
            <svelte:component
              this={getFlagComponent(player.nationality)}
              class="w-4 h-4 mr-2 hidden xs:flex"
            />
            {player.firstName}
            {player.lastName}
          </div>
          <div class="hidden xl:flex items-center w-1/12">
            {calculateAgeFromNanoseconds(Number(player.dateOfBirth))}
          </div>
          <div class="hidden sm:flex items-center w-2/12">
            £{(player.valueQuarterMillions / 4).toFixed(2)}m
          </div>
          <div class="hidden lg:flex items-center w-1/12">
            {0} <!-- //TODO -->
          </div>
          <div class="flex w-2/12 justify-center xl:justify-start xl:w-1/12">
            <ViewDetailsIcon className="w-4 sm:w-5 md:w-6 xl:w-7" />
          </div>
        </a>
      </div>
    {/each}
</div>
