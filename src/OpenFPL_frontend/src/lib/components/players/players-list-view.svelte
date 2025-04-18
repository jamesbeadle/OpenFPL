<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { sortPlayersByClubThenValue } from "$lib/utils/pick-team.helpers";
  import { addTeamDataToPlayers, convertPositionToIndex, normaliseString } from "$lib/utils/helpers";
  
  import PlayerFilterRow from "./player-filter-row.svelte";
  import PlayerTableHaeder from "./player-table-header.svelte";
  import PlayerTableRow from "./player-table-row.svelte";
  import PlayerModalPagination from "./player-modal-pagination.svelte";
  import LocalSpinner from "../shared/local-spinner.svelte";
  import type { Player } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  export let filterPosition = writable(-1);

  const pageSize = 10;
  let filterTeam = writable(-1);
  let filterSurname = writable("");
  let minValue = writable(0);
  let maxValue = writable(0);
  let currentPage = writable(1);
  let filteredPlayers: Player[] = [];
  let isLoading = true;
  let sortField: 'value' | 'points' = 'value';
  let sortDirection: 'asc' | 'desc' = 'desc';

  let playerPoints = new Map<number, number>();

  $: paginatedPlayers = addTeamDataToPlayers(
    $clubStore, 
    [...filteredPlayers]
      .sort((a, b) => {
        const multiplier = sortDirection === 'asc' ? 1 : -1;
        if (sortField === 'value') {
          return (a.valueQuarterMillions - b.valueQuarterMillions) * multiplier;
        } else if (sortField === 'points') {
          const aPoints = playerPoints.get(a.id) ?? 0;
          const bPoints = playerPoints.get(b.id) ?? 0;
          return (aPoints - bPoints) * multiplier;
        }
        return 0;
      })
      .slice(($currentPage - 1) * pageSize, $currentPage * pageSize)
  );
  
  $: { 
    if ( $filterTeam !== -1 || $filterPosition !== -1 || $minValue !== 0 || $maxValue !== 0 || $filterSurname !== "" ) {
      filterPlayers();
      $currentPage = 1;
    }
  }

  onMount(async () => {
    resetFilters();
    await filterPlayers();
    isLoading = false;
  });
  
  async function filterPlayers() {
    console.log("filtering players");
    
    console.log($leagueStore)
    let gameweek = $leagueStore?.activeGameweek === 0 ? $leagueStore?.unplayedGameweek: $leagueStore?.activeGameweek || 0;
    console.log(gameweek)
    let players = await playerStore.getSnapshotPlayers({ seasonId: $leagueStore?.activeSeasonId ?? 1, gameweek});
    console.log(players);
    if(!players){return}
    filteredPlayers = players.players.filter((player) => {
      return (
        ($filterTeam === -1 || player.clubId === $filterTeam) &&
        ($filterPosition === -1 || convertPositionToIndex(player.position) === $filterPosition) &&
        ($minValue === 0 || player.valueQuarterMillions >= $minValue * 4) &&
        ($maxValue === 0 || player.valueQuarterMillions <= $maxValue * 4) &&
        ($filterSurname === "" || normaliseString(player.lastName.toLowerCase()).includes(normaliseString($filterSurname.toLowerCase())))
      );
    });
    sortPlayersByClubThenValue(filteredPlayers, $filterTeam);
  }

  function resetFilters(){
    $filterTeam = -1;
    $filterSurname = "";
    $minValue = 0;
    $maxValue = 0;
    $currentPage = 1;
  }

  function toggleSort(field: 'value' | 'points') {
    if (sortField === field) {
      sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
    } else {
      sortField = field;
      sortDirection = 'desc';
    }
  }
</script>

{#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="p-2">
      <PlayerFilterRow {filterTeam} {filterPosition} {filterSurname} {maxValue} {minValue} />
      <div class="flex-1 overflow-x-auto">
        <PlayerTableHaeder {sortField} {sortDirection} {toggleSort} />
        {#each paginatedPlayers as player, index}
          <PlayerTableRow {player} />
        {/each}
      </div>
      <PlayerModalPagination 
        {currentPage} 
        {filteredPlayers} 
      />
    </div>
  {/if}