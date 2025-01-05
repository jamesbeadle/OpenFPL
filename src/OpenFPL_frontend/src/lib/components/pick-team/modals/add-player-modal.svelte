<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";
  import { countPlayersByTeam, reasonToDisablePlayer, sortPlayersByClubThenValue } from "$lib/utils/pick-team.helpers";
  import { addTeamDataToPlayers, convertPositionToIndex, normaliseString } from "$lib/utils/helpers";
  import type { PlayerDTO, PickTeamDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import Modal from "$lib/components/shared/modal.svelte";
  import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
  import AddPlayerModalPagination from "./add-player-modal-pagination.svelte";
  import AddPlayerTableRow from "./add-player-table-row.svelte";
  import AddPlayerFilterRow from "./add-player-filter-row.svelte";
  import AddPlayerTableHaeder from "./add-player-table-haeder.svelte";

  export let visible: boolean;
  export let handlePlayerSelection: (player: PlayerDTO) => void;
  export let fantasyTeam: Writable<PickTeamDTO | undefined>;
  export let filterPosition = writable(-1);

  const pageSize = 10;
  let filterTeam = writable(-1);
  let filterSurname = writable("");
  let minValue = writable(0);
  let maxValue = writable(0);
  let currentPage = writable(1);
  let filteredPlayers: PlayerDTO[] = [];
  let isLoading = true;

  $: paginatedPlayers = addTeamDataToPlayers($clubStore, filteredPlayers.slice(($currentPage - 1) * pageSize, $currentPage * pageSize));
  $: teamPlayerCounts = countPlayersByTeam($playerStore, $fantasyTeam?.playerIds ?? []);
  $: disableReasons = paginatedPlayers.map((player) => reasonToDisablePlayer($fantasyTeam!, $playerStore, player, teamPlayerCounts));

  $: { 
    if ( $filterTeam !== -1 || $filterPosition !== -1 || $minValue !== 0 || $maxValue !== 0 || $filterSurname !== "" ) {
      filterPlayers();
      teamPlayerCounts = countPlayersByTeam($playerStore, $fantasyTeam?.playerIds ?? []);
      $currentPage = 1;
    }
  }

  onMount(async () => {
    resetFilters();
    await filterPlayers();
    teamPlayerCounts = countPlayersByTeam($playerStore, $fantasyTeam!.playerIds ?? []);
    isLoading = false;
  });
  
  function filterPlayers() {
    filteredPlayers = $playerStore.filter((player) => {
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

  function selectPlayer(player: PlayerDTO) {
    handlePlayerSelection(player);
    closeModal();
    filteredPlayers = [];
  }

  function closeModal(){
    resetFilters();
    visible = false;
  }

  function resetFilters(){
    $filterTeam = -1;
    $filterSurname = "";
    $minValue = 0;
    $maxValue = 0;
    $currentPage = 1;
  }
  
</script>

<Modal showModal={visible} onClose={closeModal} title="Select Player">
  {#if isLoading}
    <WidgetSpinner />
  {:else}
    <div class="p-2">
      <AddPlayerFilterRow {filterTeam} {filterPosition} />
      <div class="overflow-x-auto flex-1">
        <AddPlayerTableHaeder />
        {#each paginatedPlayers as player, index}
          <AddPlayerTableRow {player} {index} {disableReasons} {selectPlayer} />
        {/each}
      </div>
      <AddPlayerModalPagination {currentPage} {filteredPlayers} />
    </div>
  {/if}
</Modal>