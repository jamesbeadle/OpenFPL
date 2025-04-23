<script lang="ts">
    import { onMount } from "svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { seasonStore } from "../../stores/season-store";
    import { clubStore } from "$lib/stores/club-store";
    import { fixtureStore } from "$lib/stores/fixture-store";
    import { managerStore } from "$lib/stores/manager-store";
    import { playerEventsStore } from "$lib/stores/player-events-store";
    import { authStore } from "$lib/stores/auth-store";
    import type { GameweekData } from "$lib/interfaces/GameweekData";
    import FantasyPlayerDetailModal from "../fantasy-team/fantasy-player-detail-modal.svelte";
    import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
    import PointsTable from "./points/points-table.svelte";
    import { getGameweeks } from "$lib/utils/helpers";
    import { leagueStore } from "$lib/stores/league-store";
    import LocalSpinner from "../shared/local-spinner.svelte";
  
    import type { FantasyTeamSnapshot, Club } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
    let isLoading = $state(true);
    
    let selectedGameweek = $state(1);
    let isInitialLoad = true;
    let gameweeks: number[] = $state([]);
    let showModal = $state(false);
    let gameweekData: GameweekData[] = $state([]);
    let selectedTeam: Club | undefined = $state(undefined);
    let selectedOpponentTeam: Club| undefined = $state(undefined);
    let selectedGameweekData: GameweekData| undefined = $state(undefined);
    let activeSeasonName: string = $state("");
    let fantasyTeam: FantasyTeamSnapshot | null = $state(null);
  
    onMount(async () => {
      await storeManager.syncStores();
      activeSeasonName = await seasonStore.getSeasonName($leagueStore!.activeSeasonId ?? 0) ?? "";
      gameweeks = getGameweeks($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1);
      selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.completedGameweek : $leagueStore!.activeGameweek ?? 1;
      isInitialLoad = false;
      isLoading = false;
    });

    $effect(() => {
      if (!isInitialLoad && selectedGameweek && $authStore?.identity?.getPrincipal()) {
        let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
        if(principal != ""){
          loadGameweekPoints(principal);
        }
      }
    });
  
    async function loadGameweekPoints(principal: string) {
      isLoading = true;
      if (!principal) { 
        isLoading = false;
        return; 
      }
  
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
  
    const changeGameweek = (delta: number) => {
      selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), selectedGameweek + delta));
    };
  
    async function showDetailModal(gameweekData: GameweekData) {
      selectedGameweekData = gameweekData;
      let playerTeamId = gameweekData.player.clubId;
      selectedTeam = $clubStore.find((x) => x.id === playerTeamId)!;
  
      let playerFixture = $fixtureStore.find((x) =>
          x.gameweek === gameweekData.gameweek &&
          (x.homeClubId === playerTeamId || x.awayClubId === playerTeamId)
      );
      let opponentId = playerFixture?.homeClubId === playerTeamId ? playerFixture?.awayClubId : playerFixture?.homeClubId;
      selectedOpponentTeam = $clubStore.find((x) => x.id === opponentId)!;
      showModal = true;
    }
  </script>
  
  {#if isLoading}
    <LocalSpinner />
    <p class="pb-4 mb-4 text-center">Getting Gameweek {selectedGameweek} Data</p>
  {:else}
    {#if showModal}
      <FantasyPlayerDetailModal
        playerTeam={selectedTeam}
        opponentTeam={selectedOpponentTeam}
        seasonName={activeSeasonName}
        visible={showModal}
        gameweekData={selectedGameweekData}
      />
    {/if}
    <div class="flex flex-col">
      <GameweekFilter 
        {selectedGameweek} 
        {gameweeks} 
        {changeGameweek} 
        lastGameweek={$leagueStore!.completedGameweek}
      />
      <PointsTable {gameweekData} {showDetailModal} />
    </div>
  {/if}