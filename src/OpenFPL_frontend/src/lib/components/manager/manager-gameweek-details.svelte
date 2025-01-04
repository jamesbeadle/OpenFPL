<script lang="ts">
  import { onMount } from "svelte";
  import { writable } from "svelte/store";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { seasonStore } from "$lib/stores/season-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import type { ClubDTO, FantasyTeamSnapshot, LeagueStatus } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import { calculateBonusPoints, sortPlayersByPointsThenValue } from "$lib/utils/pick-team.helpers";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import ManagerGameweekDetailTable from "./manager-gameweek-detail-table.svelte";
  import ScoreAbbreviationKey from "../shared/score-abbreviation-key.svelte";
  import FantasyPlayerDetailModal from "../fantasy-team/fantasy-player-detail-modal.svelte";
  import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
    import { getGameweeks } from "$lib/utils/helpers";
  
  export let selectedGameweek = writable<number | null>(null);
  export let fantasyTeam = writable<FantasyTeamSnapshot | null>(null);

  let isLoading = false;
  let showModal = false;
  let selectedTeam: ClubDTO;
  let selectedOpponentTeam: ClubDTO;
  let selectedGameweekData: GameweekData;
  let activeSeasonName: string;

  let gameweekPlayers = writable<GameweekData[]>([]);
  let leagueStatus: LeagueStatus;
  let gameweeks: number[];

  $: if ($fantasyTeam && $selectedGameweek && $selectedGameweek > 0) {
    updateGameweekPlayers();
  }

  $: if ($selectedGameweek) {
    isLoading = true;
  }

  onMount(async () => {
    await storeManager.syncStores();
    leagueStatus = $leagueStore!;
    gameweeks = getGameweeks(leagueStatus.activeGameweek == 0 ? leagueStatus.unplayedGameweek : leagueStatus.activeGameweek ?? 1)
    activeSeasonName = await seasonStore.getSeasonName(leagueStatus.activeGameweek == 0 ? leagueStatus.unplayedGameweek : leagueStatus.activeGameweek ?? 0) ?? "";
    if (!$fantasyTeam) { return; }
    updateGameweekPlayers();
    isLoading = false;
  });

  async function updateGameweekPlayers() {
    let fetchedPlayers = await playerEventsStore.getGameweekPlayers($fantasyTeam!, $leagueStore?.activeSeasonId!, $selectedGameweek!);
    calculateBonusPoints(fetchedPlayers, $fantasyTeam!);
    sortPlayersByPointsThenValue(fetchedPlayers);
    gameweekPlayers.set(fetchedPlayers);
  }

  const changeGameweek = (delta: number) => {
    isLoading = true;
    $selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), $selectedGameweek! + delta));
  };

  function closeDetailModal() {
    showModal = false;
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
      <GameweekFilter {selectedGameweek} {gameweeks} {leagueStatus} {changeGameweek} />
  </div>
  <ManagerGameweekDetailTable {fantasyTeam} {selectedGameweekData} {gameweekPlayers} {selectedTeam} {selectedOpponentTeam} {showModal} />
  <ScoreAbbreviationKey />
{/if}