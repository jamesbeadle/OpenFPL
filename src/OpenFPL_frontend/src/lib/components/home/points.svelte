<script lang="ts">
  import { onMount } from "svelte";
  import { storeManager } from "$lib/managers/store-manager";
  import { authStore } from "$lib/stores/auth-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import type { FantasyTeamSnapshot, SeasonId } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  import LocalSpinner from "../shared/local-spinner.svelte";
  import SeasonFilter from "../shared/filters/season-filter.svelte";
  import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
  
  import PointsTable from "./points/points-table.svelte";
  import ManagerPlayerScoreModal from "./points/manager-player-score-modal.svelte";
  import { toasts } from "$lib/stores/toasts-store";
  
  let isLoading = $state(true);
  let selectedSeasonId = $state(0);
  let selectedGameweek = $state(1);
  let gameweekData: GameweekData[] = $state([]);
  let selectedGameweekData: GameweekData| undefined = $state(undefined);
  let fantasyTeam: FantasyTeamSnapshot | null = $state(null);
  let showModal = $state(false);

  onMount(async () => {
    try{
      await storeManager.syncStores();
      selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.completedGameweek : $leagueStore!.activeGameweek ?? 1;
      selectedSeasonId = $leagueStore?.activeSeasonId ?? 0;
    } catch {
      toasts.addToast({type: 'error', message: 'Error loading active season information'});
    } finally {
      isLoading = false;
    }
  });

  $effect(() => {
    if(isLoading || !selectedSeasonId || !selectedGameweek){
      return;
    }

    let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
    if(principal != ""){
      loadGameweekPoints(principal);
    }
  });

  function onSelectSeason(seasonId: SeasonId) {

  };

  async function loadGameweekPoints(principal: string) {
    
    isLoading = true;
    
    fantasyTeam = await managerStore.getFantasyTeamForGameweek(
      principal,
      selectedGameweek,
      $leagueStore!.activeSeasonId
    );

    if (!fantasyTeam) { 
      isLoading = false;
      return; 
    }

    let unsortedData = await playerEventsStore.getGameweekPlayers(fantasyTeam, $leagueStore!.activeSeasonId, selectedGameweek);
    gameweekData = unsortedData.sort((a, b) => b.points - a.points);
    isLoading = false;
  }
</script>
  
{#if isLoading}
  <LocalSpinner />
  <p class="pb-4 mb-4 text-center">Getting Gameweek {selectedGameweek} Data</p>
{:else}
  <div class="flex flex-col">
    <SeasonFilter {selectedSeasonId} />
    <GameweekFilter {selectedGameweek} />
    <PointsTable {gameweekData} showDetailModal={() => showModal = true} />
  </div>
{/if}

{#if showModal}
  <ManagerPlayerScoreModal 
    visible={showModal}
    gameweekData={selectedGameweekData!}
  />
{/if}