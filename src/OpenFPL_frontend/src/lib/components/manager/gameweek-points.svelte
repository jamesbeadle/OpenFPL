<script lang="ts">
  import { onMount } from "svelte";
  import { storeManager } from "$lib/managers/store-manager";
  import { seasonStore } from "../../stores/season-store";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { authStore } from "$lib/stores/auth.store";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import type { ClubDTO, LeagueStatus } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import FantasyPlayerDetailModal from "../fantasy-team/fantasy-player-detail-modal.svelte";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
  import { writable } from "svelte/store";
  import GameweekPointsTable from "./gameweek-points-table.svelte";
  import { getGameweeks } from "$lib/utils/helpers";
    import { leagueStore } from "$lib/stores/league-store";

  let isLoading = true;
  let selectedGameweek = writable(1);
  let gameweeks: number[];
  let showModal = false;
  let gameweekData = writable<GameweekData[]>([]);
  let selectedTeam: ClubDTO;
  let selectedOpponentTeam: ClubDTO;
  let selectedGameweekData: GameweekData;
  let activeSeasonName: string;

  onMount(async () => {
    await storeManager.syncStores();
    activeSeasonName = await seasonStore.getSeasonName($leagueStore!.activeSeasonId ?? 0) ?? "";
    gameweeks = getGameweeks($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1);
    $selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1;
    let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
    if(principal == ""){
      return;
    }
    await loadGameweekPoints(principal);
    isLoading = false;
  });

  $: if ($selectedGameweek && $authStore?.identity?.getPrincipal()) {
    let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
    if(principal != ""){
      loadGameweekPoints(principal);
    }
  }

  async function loadGameweekPoints(principal: string) {
    if (!principal) { return; }

    let fantasyTeam = await managerStore.getFantasyTeamForGameweek(
      principal,
      $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1,
      $selectedGameweek
    );

    if (!fantasyTeam) { return; }

    let unsortedData = await playerEventsStore.getGameweekPlayers(fantasyTeam, $leagueStore!.activeSeasonId, $selectedGameweek);
    $gameweekData = unsortedData.sort((a, b) => b.points - a.points);
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
  <WidgetSpinner />
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
    <GameweekFilter {selectedGameweek} {changeGameweek} {gameweeks} />
    <GameweekPointsTable {gameweekData} {showDetailModal} />
  </div>
{/if}