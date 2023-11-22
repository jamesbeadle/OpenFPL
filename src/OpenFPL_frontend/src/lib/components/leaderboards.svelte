<script lang="ts">
  import { onMount } from "svelte";
  import type {
    LeaderboardEntry,
    PaginatedLeaderboard,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { SystemService } from "$lib/services/SystemService";
  import { TeamService } from "$lib/services/TeamService";
  import { LeaderboardService } from "$lib/services/LeaderboardService";
    import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  const teamService = new TeamService();
  const systemService = new SystemService();
  const leaderboardService = new LeaderboardService();

  let selectedLeaderboardType: number = 1;
  let selectedGameweek: number = 1;
  let selectedMonth: number = 1;
  let selectedTeamId: number;
  let teams: Team[] = [];
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let currentPage = 1;
  let itemsPerPage = 25;
  let leaderboard: any;
  let isLoading = true;
  let progress = 0;
  let currentGameweek: number;
  let focusGameweek: number;
  let totalPages: number = 0;
  
  $: if (leaderboard && leaderboard.totalEntries) {
    totalPages = Math.ceil(Number(leaderboard.totalEntries) / itemsPerPage);
  }

  onMount(async () => {
    try {
      await systemService.updateSystemStateData();
      await leaderboardService.updateWeeklyLeaderboardData();
      await leaderboardService.updateMonthlyLeaderboardData();
      await leaderboardService.updateSeasonLeaderboardData();
      await teamService.updateTeamsData();
      const fetchedTeams = await teamService.getTeams();
      teams = fetchedTeams;
      selectedTeamId = fetchedTeams[0].id;

      let systemState = await systemService.getSystemState();
      currentGameweek = systemState?.activeGameweek ?? 1;
      focusGameweek = systemState?.focusGameweek ?? 1;
      selectedGameweek = systemState?.focusGameweek ?? selectedGameweek;
      selectedMonth = systemState?.activeMonth ?? selectedMonth;

      let leaderboardData = await leaderboardService.getWeeklyLeaderboard();

      leaderboard = leaderboardData;
      isLoading = false;
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  });

  $: selectedLeaderboardType, selectedGameweek, selectedMonth, selectedTeamId, loadLeaderboardData();

  async function loadLeaderboardData() {
    try {
      isLoading = true;
      if (selectedLeaderboardType === 1) {
        if (selectedGameweek === focusGameweek && currentPage <= 4) {
          leaderboard = await leaderboardService.getWeeklyLeaderboard();
        } else if (selectedGameweek < focusGameweek || (selectedGameweek === focusGameweek && currentPage > 4)) {
          leaderboard = await leaderboardService.getWeeklyLeaderboardPage(selectedGameweek, currentPage);
        } else if (selectedGameweek > currentGameweek) {
          leaderboard = null;
        }
      } else if (selectedLeaderboardType === 2) {
        leaderboard = await leaderboardService.getMonthlyLeaderboard(selectedTeamId);
      } else if (selectedLeaderboardType === 3) {
        leaderboard = await leaderboardService.getSeasonLeaderboard();
      }
    } catch (error) {
      console.error("Error fetching leaderboard data:", error);
    } finally {
      isLoading = false;
    }
  }

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  const changeMonth = (delta: number) => {
    selectedMonth = Math.max(1, Math.min(12, selectedMonth + delta));
  };

  
  function changePage(delta: number) {
    currentPage = Math.max(1, Math.min(totalPages, currentPage + delta));
    loadLeaderboardData();
  }

</script>
{#if isLoading}
    <LoadingIcon {progress} />
{:else}
<div class="container-fluid mt-4">
  <div class="flex flex-col space-y-4">
    <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
      <div class="flex items-center space-x-2 ml-4">
        <div class="flex items-center md:mx-4">
          <p class="text-sm md:text-xl">Leadboard:</p>
          <select
            class="p-2 fpl-dropdown text-sm md:text-xl text-center"
            bind:value={selectedLeaderboardType}
          >
            <option value={1}>Weekly</option>
            <option value={2}>Monthly</option>
            <option value={3}>Season</option>
          </select>
        </div>

        {#if selectedLeaderboardType == 1}
          <div>
            <button
              class="text-2xl rounded fpl-button px-2 py-1"
              on:click={() => changeGameweek(-1)}
              disabled={selectedGameweek === 1}
            >
              &lt;
            </button>

            <select
              class="p-2 fpl-dropdown text-sm md:text-xl text-center"
              bind:value={selectedGameweek}
            >
              {#each gameweeks as gameweek}
                <option value={gameweek}>Gameweek {gameweek}</option>
              {/each}
            </select>

            <button
              class="text-2xl rounded fpl-button px-2 py-1"
              on:click={() => changeGameweek(1)}
              disabled={selectedGameweek === 38}
            >
              &gt;
            </button>
          </div>
        {/if}

        {#if selectedLeaderboardType == 2}
          <div>
            <select
              class="p-2 fpl-dropdown text-sm md:text-xl text-center"
              bind:value={selectedTeamId}
            >
              {#each teams as team}
                <option value={team.id}>{team.friendlyName}</option>
              {/each}
            </select>
          </div>

          <div>
            <button
              class="text-2xl rounded fpl-button px-2 py-1"
              on:click={() => changeMonth(-1)}
            >
              &lt;
            </button>

            <select
              class="p-2 fpl-dropdown text-sm md:text-xl text-center"
              bind:value={selectedMonth}
            >
              <option value={1}>January</option>
              <option value={2}>February</option>
              <option value={3}>March</option>
              <option value={4}>April</option>
              <option value={5}>May</option>
              <option value={6}>June</option>
              <option value={7}>July</option>
              <option value={8}>August</option>
              <option value={9}>September</option>
              <option value={10}>October</option>
              <option value={11}>November</option>
              <option value={12}>December</option>
            </select>

            <button
              class="text-2xl rounded fpl-button px-2 py-1"
              on:click={() => changeMonth(1)}
            >
              &gt;
            </button>
          </div>
        {/if}
      </div>
    </div>
    <div class="flex flex-col space-y-4 mt-4 text-lg">
      <div class="overflow-x-auto flex-1">
        <div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray">
          <div class="w-1/6 text-center mx-4">Pos</div>
          <div class="w-1/3 px-4">Manager</div>
          <div class="w-1/2 text-center">Points</div>
        </div>
  
        {#if leaderboard && leaderboard.entries.length > 0}
          {#each leaderboard.entries as entry}
            <div class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer">
              <div class="w-1/12 text-center">{entry.positionText}</div>
              <div class="w-1/12 text-center">{entry.username}</div>
              <div class="w-1/12 text-center">{entry.points}</div>
            </div>
          {/each}
          <div class="flex justify-center items-center mt-4 mb-4">
            <button 
              on:click={() => changePage(-1)} 
              disabled={currentPage === 1}
              class="px-4 py-2 mx-2 bg-blue-500 text-white rounded hover:bg-blue-600 disabled:bg-gray-400 disabled:cursor-not-allowed">
              Previous
            </button>
          
            <span class="px-4">Page {currentPage}</span>
          
            <button on:click={() => changePage(1)} disabled={currentPage >= totalPages} 
              class="px-4 py-2 mx-2 bg-blue-500 text-white rounded hover:bg-blue-600 disabled:bg-gray-400 disabled:cursor-not-allowed">Next</button>

            </div>
        {:else}
            <p class="w-100 p-4">No leaderboard data.</p>
        {/if}
        
      </div>
    </div>
    
  </div>
</div>

{/if}
