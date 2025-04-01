<script lang="ts">
  import { onMount } from "svelte";
  import { writable } from "svelte/store";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { seasonStore } from "$lib/stores/season-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import { calculateBonusPoints, sortPlayersByPointsThenValue } from "$lib/utils/pick-team.helpers";
  import ManagerGameweekDetailTable from "./manager-gameweek-detail-table.svelte";
  import ScoreAbbreviationKey from "../shared/score-abbreviation-key.svelte";
  import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
  import { getGameweeks } from "$lib/utils/helpers";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import type { FantasyTeamSnapshot } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  export let selectedGameweek = writable<number | null>(null);
  export let fantasyTeam = writable<FantasyTeamSnapshot | null>(null);

  let isLoading = false;
  let showModal = false;
  let lastGameweek: number;
  let activeSeasonName: string;

  let gameweekPlayers = writable<GameweekData[]>([]);
  let gameweeks: number[];

  $: if ($fantasyTeam && $selectedGameweek && $selectedGameweek > 0) {
    updateGameweekPlayers();
  }

  $: if ($selectedGameweek) {
    isLoading = true;
  }

  onMount(async () => {
    await storeManager.syncStores();
    gameweeks = getGameweeks($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1)
    lastGameweek = $leagueStore?.completedGameweek ?? 1;
    activeSeasonName = await seasonStore.getSeasonName($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 0) ?? "";
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
  <LocalSpinner />
{:else}
  <div class="flex flex-col">
      <GameweekFilter {lastGameweek} {selectedGameweek} {gameweeks} {changeGameweek} />
  </div>
  <ManagerGameweekDetailTable {activeSeasonName} {fantasyTeam} {gameweekPlayers} {showModal} />
  <ScoreAbbreviationKey />
{/if}