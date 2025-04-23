<script lang="ts">
    import { onMount } from "svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { leagueStore } from "$lib/stores/league-store";
    import { clubStore } from "$lib/stores/club-store";
    import { leaderboardStore } from "$lib/stores/leaderboard-store";
    import { authSignedInStore } from "$lib/derived/auth.derived";
    import { userGetFavouriteTeam } from "$lib/derived/user.derived";
    import { getGameweeks } from "$lib/utils/helpers";
    import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
    import LeaderboardFilter from "./leaderboards/leaderboard-type-filter.svelte";
    import LeaderboardMonthFilter from "./leaderboards/leaderboard-month-filter.svelte";
    import LeaderboardTable from "./leaderboards/leaderboard-table.svelte";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import type { GetWeeklyLeaderboard } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
    let isLoading = $state(true);
    let gameweeks: number[] = $state([]);
    let currentPage = $state(1);
    let selectedLeaderboardType = $state(1);
    let totalPages = $state(0);
    let selectedTeamIndex = $state(0);
    let selectedSeasonId = $state(1);
    let selectedGameweek = $state(1);
    let selectedMonth = $state(0);
    let selectedTeamId = $state(0);
    let leaderboard: any = $state(undefined);
    let searchQuery = $state("");
  
    $effect(() => {
        selectedTeamIndex = $clubStore.findIndex((team) => team.id === selectedTeamId);
        loadLeaderboardData();
        if (leaderboard && leaderboard.totalEntries) {
            totalPages = Math.ceil(Number(leaderboard.totalEntries) / 25);
        }
    });
  
    onMount(async () => {
      await storeManager.syncStores();
      gameweeks = getGameweeks($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1 ) 
      selectedSeasonId = $leagueStore!.activeSeasonId;
      selectedGameweek = $leagueStore!.completedGameweek;
      selectedMonth = $leagueStore!.activeMonth ?? 8;
      let firstClubId = $clubStore.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))[0].id
      selectedTeamId = $authSignedInStore ? $userGetFavouriteTeam ?? firstClubId : firstClubId;
      await loadLeaderboardData();
      isLoading = false;
    });
    
    async function loadLeaderboardData() {
      /*
      if (!selectedGameweek) { return; }
      isLoading = true;
      switch (selectedLeaderboardType) {
        case 1:
            let dto: GetWeeklyLeaderboard = {
                page: BigInt(currentPage),
                seasonId: selectedSeasonId,
                searchTerm: searchQuery,
                gameweek: selectedGameweek,
            };
            
            leaderboard = await leaderboardStore.getWeeklyLeaderboard(dto);
          break;
        case 2:
            let dto: GetMonthlyLeaderboard = {
                selectedSeasonId, selectedTeamId, selectedMonth, currentPage, ""
            };
          leaderboard = await leaderboardStore.getMonthlyLeaderboard();
          break;
        case 3:
          leaderboard = await leaderboardStore.getSeasonLeaderboard(selectedSeasonId, selectedTeamId, selectedMonth, currentPage, "");
          break;
        case 4:
          leaderboard = await leaderboardStore.getMostValuableTeamsLeaderboard(selectedSeasonId, selectedTeamId, selectedMonth, currentPage, "");
          break;
      }
      isLoading = false;
      */
    }
  
    const changeGameweek = (delta: number) => {
      selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), selectedGameweek + delta));
    };
  
    
  
    function handlePageChange(newPage: number) {
      currentPage = Math.max(1, Math.min(newPage, totalPages));
    }
  
    function changeLeaderboardType(change: number) {
      selectedLeaderboardType += change;
      selectedLeaderboardType = selectedLeaderboardType > 3 ? 1 : (selectedLeaderboardType < 1) ? 3 : selectedLeaderboardType;
    }
  </script>
  
  {#if isLoading}
    <LocalSpinner />
    <p class="pb-4 mb-4 text-center">Getting Leaderboard for Gameweek {selectedGameweek}</p>
  {:else}
    <div class="flex flex-col">
      <div class="flex flex-col gap-4 sm:flex-row sm:gap-8">
        <div class="flex flex-col gap-4 sm:flex-row sm:gap-8">
          <LeaderboardFilter {selectedLeaderboardType} {changeLeaderboardType} />
          <!--  
          {#if selectedLeaderboardType === 1}
          {#if weeklyPoints !== undefined}
              <div class="flex items-center gap-2 px-4 py-2 text-lg font-medium rounded-md bg-BrandGray/60">
                <span class="text-gray-300">Total Gameweek Points:</span>
                <span class="text-white">{weeklyPoints}</span>
              </div>
            {/if}
            <GameweekFilter {selectedGameweek} {gameweeks} {changeGameweek} lastGameweek={$leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1} />
          {/if}
          {#if selectedLeaderboardType === 2}
            <LeaderboardMonthFilter {selectedMonth} {selectedTeamId} {selectedTeamIndex} />
          {/if}
          -->
        </div>
      </div>
      <LeaderboardTable {leaderboard} {searchQuery} onPageChange={handlePageChange} {currentPage} {totalPages} {selectedGameweek} />
    </div>
  {/if}