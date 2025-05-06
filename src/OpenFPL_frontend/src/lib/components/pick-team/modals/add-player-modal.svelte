<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";
  import { countPlayersByTeam, reasonToDisablePlayer, sortPlayersByClubThenValue } from "$lib/utils/pick-team.helpers";
  import { addTeamDataToPlayers, convertPositionToIndex, normaliseString } from "$lib/utils/Helpers";
  import type { Player, TeamSetup } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  import Modal from "$lib/components/shared/global/modal.svelte";
  import AddPlayerModalPagination from "./add-player-modal-pagination.svelte";
  import AddPlayerTableRow from "./add-player-table-row.svelte";
  import AddPlayerModalFilters from "./add-player-modal-filters.svelte";
  import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";

  interface Props {
    handlePlayerSelection: (player: Player) => void;
    fantasyTeam: TeamSetup | undefined;
    filterPosition: number;
    onClose: () => void;
  }
  
  let { handlePlayerSelection, fantasyTeam, filterPosition, onClose }: Props = $props();

  const pageSize = 10;
  
  let isLoading = $state(true);
  
  let teamPlayerCounts: Record<number, number> = $state({});
  let disableReasons: (string | null)[] = $state([]);
  let filteredPlayers: Player[] = $state([]); 
  let paginatedPlayers: Player[] = $state([]); 
  let currentPage = $state(1);

  onMount(async () => {
    teamPlayerCounts = countPlayersByTeam($playerStore, fantasyTeam!.playerIds ?? []);
    disableReasons = filteredPlayers.map((player) => reasonToDisablePlayer(fantasyTeam!, $playerStore, player, teamPlayerCounts));
    filteredPlayers = $playerStore;
    changePage(1);
    isLoading = false;
  });

  $effect(() => {
    const sortedPlayers = [...filteredPlayers].sort((a, b) => b.valueQuarterMillions - a.valueQuarterMillions);
    const start = (currentPage - 1) * pageSize;
    const end = start + pageSize;
    paginatedPlayers = addTeamDataToPlayers($clubStore, sortedPlayers.slice(start, end));
  });


  function filterPlayers(filterTeam: number, filterPosition: number, minValue: number, maxValue: number, filterSurname: string){
    filteredPlayers = $playerStore.filter((player) => {
      return (
        (filterTeam === -1 || player.clubId === filterTeam) &&
        (filterPosition === -1 || convertPositionToIndex(player.position) === filterPosition) &&
        (minValue === 0 || player.valueQuarterMillions >= minValue * 4) &&
        (maxValue === 0 || player.valueQuarterMillions <= maxValue * 4) &&
        (filterSurname === "" || normaliseString(player.lastName.toLowerCase()).includes(normaliseString(filterSurname.toLowerCase())))
      );
    });
    currentPage = 1; 
  }

  function changePage(page: number) {
    currentPage = page;
  }

  function selectPlayer(player: Player) {
    handlePlayerSelection(player);
    onClose();
    filteredPlayers = [];
  }

</script>

<Modal onClose={onClose} title="Select Player">
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="p-2">
      <AddPlayerModalFilters {filterPlayers} {filterPosition} />
      <div class="flex-1 overflow-x-auto">
        <div class="flex items-center justify-between py-2 border-b border-gray-700">
          <div class="w-1/12 text-center">Pos</div>
          <div class="w-2/12">Player</div>
          <div class="w-2/12">Team</div>
          <div class="w-2/12">Value</div>
          <div class="w-2/12"></div>
      </div>
        {#each paginatedPlayers as player, index}
          {@const club = $clubStore.find(x => x.id == player.clubId)}
          <AddPlayerTableRow {player} {index} {disableReasons} {selectPlayer} {club} />
        {/each}
      </div>
      <AddPlayerModalPagination {changePage} pageCount={filteredPlayers.length / pageSize} />
    </div>
  {/if}
</Modal>