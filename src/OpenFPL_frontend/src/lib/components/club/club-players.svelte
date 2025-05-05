<script lang="ts">
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import { onMount } from "svelte";
  import {
    calculateAgeFromNanoseconds,
    convertPositionToIndex,
    getFlagComponent,
    getPositionAbbreviation
  } from "$lib/utils/Helpers";
  import { playerStore } from "$lib/stores/player-store";
  import PositionFilter from "../shared/filters/position-filter.svelte";
  import type { Player } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  interface Props {
    clubId: number;
  }
  let { clubId }: Props = $props();

  let filteredPlayers: Player[] = $state([]);

  onMount(async () => {
    players = $playerStore.filter((x) => x.clubId == clubId)
  });

  let players: Player[] = [];
  let selectedPosition = $state(-1);
  $effect(() => {
    filteredPlayers = selectedPosition === -1
      ? players
      : players.filter(
          (p) => convertPositionToIndex(p.position) === selectedPosition
        );
  });
  
</script>

<div class="flex flex-col">
    <PositionFilter {selectedPosition} />

    <div class="flex border-b border-gray-700 bg-light-gray p-2 xs:py-3 md:py-4 px-4">
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
      <div class="flex items-center p-2 px-4 text-white border-b border-gray-700 cursor-pointer xs:py-3 md:py-4">
        <a class="flex items-center justify-start flex-grow" href={`/player?id=${player.id}`}>
          <div class="flex items-center w-2/12">
            {player.shirtNumber === 0 ? "-" : player.shirtNumber}
          </div>
          <div class="flex items-center w-2/12">
            {getPositionAbbreviation(convertPositionToIndex(player.position))}
          </div>
          <div class="flex items-center w-6/12 sm:w-4/12 lg:w-3/12 xl:w-3/12">
            {#if player.nationality > 0}
              {@const FlagComponent = getFlagComponent(player.nationality)}
              <FlagComponent className="w-4 xs:w-6 mx-1" size="16" ariaLabel={`flag of ${player.nationality}`} role='img' />
            {/if}
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
