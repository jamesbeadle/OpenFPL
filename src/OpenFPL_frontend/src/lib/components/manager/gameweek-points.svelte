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
  import { writable } from "svelte/store";
  import GameweekPointsTable from "./gameweek-points-table.svelte";
  import { getGameweeks } from "$lib/utils/helpers";
  import { leagueStore } from "$lib/stores/league-store";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import type { Club } from "../../../../../declarations/data_canister/data_canister.did";
    import type { FantasyTeamSnapshot } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  let isLoading = true;
  let selectedGameweek = writable(1);
  let isInitialLoad = true;
  let gameweeks: number[];
  let showModal = false;
  let gameweekData = writable<GameweekData[]>([]);
  let selectedTeam: Club;
  let selectedOpponentTeam: Club;
  let selectedGameweekData: GameweekData;
  let activeSeasonName: string;
  let fantasyTeam: FantasyTeamSnapshot | null = null;

  onMount(async () => {
    await storeManager.syncStores();
    activeSeasonName = await seasonStore.getSeasonName($leagueStore!.activeSeasonId ?? 0) ?? "";
    gameweeks = getGameweeks($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1);
    $selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.completedGameweek : $leagueStore!.activeGameweek ?? 1;
    isInitialLoad = false;
    isLoading = false;
  });

  $: if (!isInitialLoad && $selectedGameweek && $authStore?.identity?.getPrincipal()) {
    let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
    if(principal != ""){
      loadGameweekPoints(principal);
    }
  }

  async function loadGameweekPoints(principal: string) {
    isLoading = true;
    if (!principal) { 
      isLoading = false;
      return; 
    }

    fantasyTeam = await managerStore.getFantasyTeamForGameweek(
      principal,
      $selectedGameweek,
      $leagueStore!.activeSeasonId
    );

    if (!fantasyTeam) { 
      isLoading = false;
      return; 
    }

    let unsortedData = await playerEventsStore.getGameweekPlayers(fantasyTeam, $leagueStore!.activeSeasonId, $selectedGameweek);
    $gameweekData = unsortedData.sort((a, b) => b.points - a.points);
    isLoading = false;
  }

  const changeGameweek = (delta: number) => {
    $selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), $selectedGameweek + delta));
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
  <p class="pb-4 mb-4 text-center">Getting Gameweek {$selectedGameweek} Data</p>
{:else}
  {#if showModal}
    <FantasyPlayerDetailModal
      playerTeam={selectedTeam}
      opponentTeam={selectedOpponentTeam}
      seasonName={activeSeasonName}
      bind:visible={showModal}
      gameweekData={selectedGameweekData}
    />
  {/if}
  <div class="flex flex-col">
    <GameweekFilter 
      {selectedGameweek} 
      {gameweeks} 
      {changeGameweek} 
      lastGameweek={$leagueStore!.completedGameweek}
      weeklyPoints={fantasyTeam?.points}
    />
    <GameweekPointsTable {gameweekData} {showDetailModal} />
  </div>
{/if}