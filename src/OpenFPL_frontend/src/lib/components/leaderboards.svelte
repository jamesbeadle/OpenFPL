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
  const itemsPerPage = 25;
  let leaderboard: PaginatedLeaderboard;

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
      selectedGameweek = systemState?.activeGameweek ?? selectedGameweek;
      selectedMonth = systemState?.activeMonth ?? selectedMonth;

      let leaderboardData = await leaderboardService.getWeeklyLeaderboard();

      leaderboard = leaderboardData;
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  });

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  const changeMonth = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(12, selectedMonth + delta));
  };

  function changePage(leaderboardType: number, delta: number) {
    currentPage = Math.max(1, currentPage + delta);
    if (currentPage > 4) {
    } else {
    }
  }
</script>

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
    <div />
  </div>
</div>
