<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { countPlayersByTeam, reasonToDisablePlayer, sortPlayersByClubThenValue } from "$lib/utils/pick-team.helpers";
  import { addTeamDataToPlayers, convertPositionToIndex, normaliseString } from "$lib/utils/Helpers";
  
  import Modal from "$lib/components/shared/global/modal.svelte";
  import AddPlayerModalPagination from "./add-player-modal-pagination.svelte";
  import AddPlayerTableRow from "./add-player-table-row.svelte";
  import AddPlayerFilterRow from "./add-player-filter-row.svelte";
  import AddPlayerTableHaeder from "./add-player-table-haeder.svelte";
  import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";
  import type { Player, TeamSetup } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";


  interface Props {
    visible: boolean;
    handlePlayerSelection: (player: Player) => void;
    fantasyTeam: TeamSetup | undefined;
    filterPosition: number;
  }
  let { visible, handlePlayerSelection, fantasyTeam, filterPosition }: Props = $props();

  const pageSize = 10;
  let filterTeam = $state(-1);
  let filterSurname = $state("");
  let minValue = $state(0);
  let maxValue = $state(0);
  let currentPage = $state(1);
  let paginatedPlayers: Player[] = $state([]);
  let teamPlayerCounts: Record<number, number> = $state({});
  let filteredPlayers: Player[] = $state([]);
  let isLoading = $state(true);
  let sortField: 'value' | 'points' = $state('value');
  let sortDirection: 'asc' | 'desc' = $state('desc');

  let playerPoints = new Map<number, number>();

  let disableReasons: (string | null)[] = $state([]);
  
  $effect(() => {
    paginatedPlayers = addTeamDataToPlayers(
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
      .slice((currentPage - 1) * pageSize, currentPage * pageSize)
  );
  });


  $effect(() => {
    teamPlayerCounts = countPlayersByTeam($playerStore, fantasyTeam?.playerIds ?? []);
  });

$effect(() => {
  disableReasons = paginatedPlayers.map((player) => reasonToDisablePlayer(fantasyTeam!, $playerStore, player, teamPlayerCounts));
});

$effect(() => {
  if ( filterTeam !== -1 || filterPosition !== -1 || minValue !== 0 || maxValue !== 0 || filterSurname !== "" ) {
      filterPlayers();
      teamPlayerCounts = countPlayersByTeam($playerStore, fantasyTeam?.playerIds ?? []);
      currentPage = 1;
    }
});


  onMount(async () => {
    resetFilters();
    await filterPlayers();
    teamPlayerCounts = countPlayersByTeam($playerStore, fantasyTeam!.playerIds ?? []);
    isLoading = false;
  });
  
  async function filterPlayers() {
    filteredPlayers = $playerStore.filter((player) => {
      return (
        (filterTeam === -1 || player.clubId === filterTeam) &&
        (filterPosition === -1 || convertPositionToIndex(player.position) === filterPosition) &&
        (minValue === 0 || player.valueQuarterMillions >= minValue * 4) &&
        (maxValue === 0 || player.valueQuarterMillions <= maxValue * 4) &&
        (filterSurname === "" || normaliseString(player.lastName.toLowerCase()).includes(normaliseString(filterSurname.toLowerCase())))
      );
    });
    sortPlayersByClubThenValue(filteredPlayers, filterTeam);
  }


  function selectPlayer(player: Player) {
    handlePlayerSelection(player);
    closeModal();
    filteredPlayers = [];
  }

  function closeModal(){
    resetFilters();
    visible = false;
  }

  function resetFilters(){
    filterTeam = -1;
    filterSurname = "";
    minValue = 0;
    maxValue = 0;
    currentPage = 1;
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

<Modal showModal={visible} onClose={closeModal} title="Select Player">
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="p-2">
      <AddPlayerFilterRow {filterTeam} {filterPosition} {filterSurname} {maxValue} {minValue} />
      <div class="flex-1 overflow-x-auto">
        <AddPlayerTableHaeder {sortField} {sortDirection} {toggleSort} />
        {#each paginatedPlayers as player, index}
          <AddPlayerTableRow {player} {index} {disableReasons} {selectPlayer} />
        {/each}
      </div>
      <AddPlayerModalPagination 
        {currentPage} 
        {filteredPlayers} 
      />
    </div>
  {/if}
</Modal>