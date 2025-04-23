<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { clubStore } from "$lib/stores/club-store";
  import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { userGetFavouriteTeam } from "$lib/derived/user.derived";
  import { getGameweeks } from "$lib/utils/helpers";
  import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
  import LeaderboardFilter from "./leaderboard-filter.svelte";
  import LeaderboardMonthFilter from "./leaderboard-month-filter.svelte";
  import LeaderboardTable from "./leaderboard-table.svelte";
    import LocalSpinner from "../shared/local-spinner.svelte";

  let isLoading = true;
  let gameweeks: number[];
  let currentPage = 1;
  let selectedLeaderboardType = writable<number>(1);
  let totalPages = 0;
  let selectedTeamIndex = writable<number>(0);
  let itemsPerPage = 25;
  let selectedSeasonId = writable(1);
  let selectedGameweek = writable(1);
  let selectedMonth = writable(0);
  let selectedTeamId = writable(0);
  let leaderboard: any;
  let searchQuery = writable("");

  $: selectedTeamIndex.set(
    $clubStore.findIndex((team) => team.id === $selectedTeamId)
  );

  $: {
    $selectedLeaderboardType;
    $selectedTeamIndex;
    $selectedGameweek;
    $selectedMonth;
    $selectedTeamId;
    currentPage;
    $searchQuery;
    loadLeaderboardData();
  }

  $: if (leaderboard && leaderboard.totalEntries) {
    totalPages = Math.ceil(Number(leaderboard.totalEntries) / 25);
  }

  onMount(async () => {
    await storeManager.syncStores();
    gameweeks = getGameweeks($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1 ) 
    $selectedSeasonId = $leagueStore!.activeSeasonId;
    $selectedGameweek = $leagueStore!.completedGameweek;
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
        leaderboard = await weeklyLeaderboardStore.getWeeklyLeaderboard(
          $selectedSeasonId, 
          $selectedGameweek, 
          currentPage,
          $searchQuery
        );
        const rewardsResult = await weeklyLeaderboardStore.getWeeklyRewards($selectedSeasonId, $selectedGameweek);
        if(leaderboard && rewardsResult){
          //leaderboard.entries = mergeLeaderboardWithRewards(leaderboard.entries, rewardsResult.rewards);
        }
        break;
      case 2:
        //leaderboard = await monthlyLeaderboardStore.getMonthlyLeaderboard($selectedSeasonId, $selectedTeamId, $selectedMonth, currentPage, "");
        break;
    }
    isLoading = false;
  }

  const changeGameweek = (delta: number) => {
    $selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), $selectedGameweek + delta));
  };

  

  function handlePageChange(newPage: number) {
    currentPage = Math.max(1, Math.min(newPage, totalPages));
  }

  function changeLeaderboardType(change: number) {
    $selectedLeaderboardType += change;
    $selectedLeaderboardType = $selectedLeaderboardType > 3 ? 1 : ($selectedLeaderboardType < 1) ? 3 : $selectedLeaderboardType;
  }
</script>

{#if isLoading}
  <LocalSpinner />
  <p class="pb-4 mb-4 text-center">Getting Leaderboard for Gameweek {$selectedGameweek}</p>
{:else}
  <div class="flex flex-col">
    <div class="flex flex-col gap-4 sm:flex-row sm:gap-8">
      <div class="flex flex-col gap-4 sm:flex-row sm:gap-8">
        <LeaderboardFilter {selectedLeaderboardType} {changeLeaderboardType} />
        {#if $selectedLeaderboardType === 1}
          <GameweekFilter {selectedGameweek} {gameweeks} {changeGameweek} lastGameweek={$leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1} />
        {/if}
        {#if $selectedLeaderboardType === 2}
          <LeaderboardMonthFilter {selectedMonth} {selectedTeamId} {selectedTeamIndex} />
        {/if}
      </div>
    </div>
    <LeaderboardTable {leaderboard} {searchQuery} onPageChange={handlePageChange} {currentPage} {totalPages} {selectedGameweek} />
  </div>
{/if}