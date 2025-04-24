<script lang="ts">
    import { onMount } from "svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { leagueStore } from "$lib/stores/league-store";
    import { clubStore } from "$lib/stores/club-store";
    import { leaderboardStore } from "$lib/stores/leaderboard-store";
    import { authSignedInStore } from "$lib/derived/auth.derived";
    import { userGetFavouriteTeam } from "$lib/derived/user.derived";
    import { LeaderboardType } from "$lib/enums/LeaderboardType";

    import LocalSpinner from "../shared/local-spinner.svelte";
    import LeaderboardTypeFilter from "./leaderboards/leaderboard-type-filter.svelte";
    import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
    import ClubFilter from "../shared/filters/club-filter.svelte";
    import MonthFilter from "../shared/filters/month-filter.svelte";
    import SeasonFilter from "../shared/filters/season-filter.svelte";
    import LeaderboardTable from "./leaderboards/leaderboard-table.svelte";
    import UserLeaderboardEntry from "./leaderboards/user-leaderboard-entry.svelte";
    import { toasts } from "$lib/stores/toasts-store";
    
    let isLoading = $state(true);
    let selectedLeaderboardType = $state(LeaderboardType.WEEKLY);
    let selectedSeasonId = $state(1);
    let selectedGameweek = $state(1);
    let selectedMonth = $state(0);
    let selectedClubId = $state(0);
    let searchTerm = $state("");
    let leaderboard: any = $state(undefined);
    let currentPage = $state(1);
    let totalPages = $state(0);
    
    onMount(async () => {
      await storeManager.syncStores();
      selectedSeasonId = $leagueStore!.activeSeasonId;
      selectedGameweek = $leagueStore!.completedGameweek;
      selectedMonth = $leagueStore!.activeMonth ?? 8;
      let firstClubId = $clubStore.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))[0].id
      selectedClubId = $authSignedInStore ? $userGetFavouriteTeam ?? firstClubId : firstClubId;
      await loadLeaderboardData();
      isLoading = false;
    });
    
    async function loadLeaderboardData() {
      try{
        isLoading = true;

        switch(selectedLeaderboardType){
          case LeaderboardType.WEEKLY:
            if (!selectedSeasonId || !selectedGameweek) { return; }
            leaderboard = await leaderboardStore.getWeeklyLeaderboard({
              seasonId: selectedSeasonId,
              page: BigInt(currentPage),
              searchTerm,
              gameweek: selectedGameweek
            });
            break;
          case LeaderboardType.MONTHLY:
            if (!selectedSeasonId || !selectedClubId || !selectedMonth) { return; }
            leaderboard = await leaderboardStore.getMonthlyLeaderboard({
              seasonId: selectedSeasonId,
              page: BigInt(currentPage),
              clubId: selectedClubId,
              month: selectedMonth
            });
            break;
          case LeaderboardType.SEASON:
            if (!selectedSeasonId) { return; }
            leaderboard = await leaderboardStore.getSeasonLeaderboard({
              seasonId: selectedSeasonId,
              page: BigInt(currentPage)
            });
            break;
          case LeaderboardType.TEAMVALUE:
            if (!selectedSeasonId) { return; }
            await leaderboardStore.getMostValuableTeamLeaderboard({
              seasonId: selectedSeasonId,
              page: BigInt(currentPage)
            });
            break;
        }

        if (leaderboard && leaderboard.totalEntries) {
            totalPages = Math.ceil(Number(leaderboard.totalEntries) / 25);
        }
      } catch {
        toasts.addToast({type: 'error', message: 'There was an error loading leaderboards.'})
      } finally {
        isLoading = false;
      }
    }
  
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

      <LeaderboardTypeFilter {selectedLeaderboardType} {changeLeaderboardType} />
      <SeasonFilter {selectedSeasonId} />

      {#if selectedLeaderboardType == LeaderboardType.WEEKLY}
        <GameweekFilter {selectedGameweek} />
      {/if}
    
      {#if selectedLeaderboardType == LeaderboardType.MONTHLY}
        <MonthFilter {selectedMonth} />
        <ClubFilter {selectedClubId} />
      {/if}

      <UserLeaderboardEntry />
      <LeaderboardTable {leaderboard} {searchTerm} onPageChange={handlePageChange} {currentPage} {totalPages} {selectedGameweek} />
    </div>
  {/if}