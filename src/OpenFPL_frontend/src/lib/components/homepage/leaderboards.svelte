<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { clubStore } from "$lib/stores/club-store";
  import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";
  import { monthlyLeaderboardStore } from "$lib/stores/monthly-leaderboard-store";
  import { seasonLeaderboardStore } from "$lib/stores/season-leaderboard-store";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { userGetFavouriteTeam } from "$lib/derived/user.derived";
  import { getGameweeks, mergeLeaderboardWithRewards } from "$lib/utils/helpers";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
  import LeaderboardFilter from "./leaderboard-filter.svelte";
  import LeaderboardMonthFilter from "./leaderboard-month-filter.svelte";
  import LeaderboardTable from "./leaderboard-table.svelte";

  let isLoading = true;
  let gameweeks: number[];
  let currentPage = writable<number>(1);
  let selectedLeaderboardType = writable<number>(1);
  let totalPages = writable<number>(0);
  let selectedTeamIndex = writable<number>(0);
  let itemsPerPage = 25;
  let selectedSeasonId: number;
  let selectedGameweek = writable(1);
  let selectedMonth = writable(0);
  let selectedTeamId = writable(0);
  let leaderboard: any;

  $: $selectedTeamIndex = $clubStore.findIndex((team) => team.id === $selectedTeamId);
  $: selectedLeaderboardType, selectedTeamIndex, selectedGameweek, selectedMonth, selectedTeamId, currentPage, loadLeaderboardData();
  $: if (leaderboard && leaderboard.totalEntries) { $totalPages = Math.ceil(Number(leaderboard.totalEntries) / itemsPerPage); }

  onMount(async () => {
    await storeManager.syncStores();
    gameweeks = getGameweeks($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1 ) 
    selectedSeasonId = $leagueStore!.activeSeasonId;
    $selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.completedGameweek : $leagueStore!.activeGameweek ?? 1;
    $selectedMonth = $leagueStore!.activeMonth ?? 8;
    let firstClubId = $clubStore.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))[0].id
    $selectedTeamId = $authSignedInStore ? $userGetFavouriteTeam ?? firstClubId : firstClubId;
    await loadLeaderboardData();
    isLoading = false;
  });
  
  async function loadLeaderboardData() {
    if (!selectedGameweek) { return; }
    isLoading = true;
    switch ($selectedLeaderboardType) {
      case 1:
        leaderboard = await weeklyLeaderboardStore.getWeeklyLeaderboard(selectedSeasonId, $selectedGameweek, $currentPage);
        const rewardsResult = await weeklyLeaderboardStore.getWeeklyRewards(selectedSeasonId, $selectedGameweek);
        if(leaderboard && rewardsResult){
          leaderboard.entries = mergeLeaderboardWithRewards(leaderboard.entries, rewardsResult ? rewardsResult.rewards : []);
        }
        break;
      case 2:
        leaderboard = await monthlyLeaderboardStore.getMonthlyLeaderboard(selectedSeasonId, $selectedTeamId, $selectedMonth, $currentPage, "");
        break;
      case 3:
        leaderboard = await seasonLeaderboardStore.getSeasonLeaderboard(selectedSeasonId, $currentPage, "");
        break;
    }
    isLoading = false;
  }

  const changeGameweek = (delta: number) => {
    $selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), $selectedGameweek + delta));
  };

  function changePage(delta: number) {
    $currentPage = Math.max(1, Math.min($totalPages, $currentPage + delta));
  }

  function changeLeaderboardType(change: number) {
    $selectedLeaderboardType += change;
    $selectedLeaderboardType = $selectedLeaderboardType > 3 ? 1 : ($selectedLeaderboardType < 1) ? 3 : $selectedLeaderboardType;
  }
</script>

{#if isLoading}
  <WidgetSpinner />
{:else}
  <div class="flex flex-col">
    <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
      <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
        <LeaderboardFilter {selectedLeaderboardType} {changeLeaderboardType} />
        {#if $selectedLeaderboardType === 1}
          <GameweekFilter {selectedGameweek} {changeGameweek} leagueStatus={$leagueStore!} {gameweeks} />
        {/if}
        {#if $selectedLeaderboardType === 2}
          <LeaderboardMonthFilter {selectedMonth} {selectedTeamId} {selectedTeamIndex} />
        {/if}
      </div>
    </div>
    <LeaderboardTable {leaderboard} {changePage} {currentPage} {totalPages} {selectedGameweek} />
  </div>
{/if}