<script lang="ts">
  import { onMount } from "svelte";
  import { toastsError } from "$lib/stores/toasts-store";
  import { teamStore } from "$lib/stores/team-store";
  import { systemStore } from "$lib/stores/system-store";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { userGetFavouriteTeam } from "$lib/derived/user.derived";
  import { leaderboardStore } from "$lib/stores/leaderboard-store";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  let isLoading = true;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let selectedGameweek: number = $systemStore?.focusGameweek ?? 1;
  let currentPage = 1;
  let itemsPerPage = 25;

  let selectedLeaderboardType: number = 1;
  let selectedMonth: number = $systemStore?.activeMonth ?? 8;
  let selectedTeamId: number = $authSignedInStore
    ? $userGetFavouriteTeam ?? $teamStore[0].id
    : $teamStore[0].id;

  let leaderboard: any;
  let totalPages: number = 0;
  let selectedTeamIndex: number = 0;

  $: selectedTeamIndex = $teamStore.findIndex(
    (team) => team.id === selectedTeamId
  );

  $: if (leaderboard && leaderboard.totalEntries) {
    totalPages = Math.ceil(Number(leaderboard.totalEntries) / itemsPerPage);
  }

  onMount(async () => {
    try {
      await teamStore.sync();
      await systemStore.sync();
      await leaderboardStore.syncWeeklyLeaderboard();
      await leaderboardStore.syncMonthlyLeaderboards();
      await leaderboardStore.syncSeasonLeaderboard();

      let leaderboardData = await leaderboardStore.getWeeklyLeaderboard();
      leaderboard = leaderboardData;
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching leaderboard data." },
        err: error,
      });
      console.error("Error fetching leaderboard data:", error);
    } finally {
      isLoading = false;
    }
  });

  $: selectedLeaderboardType,
    selectedGameweek,
    selectedMonth,
    selectedTeamId,
    loadLeaderboardData();

  async function loadLeaderboardData() {
    isLoading = true;
    try {
      switch (selectedLeaderboardType) {
        case 1:
          leaderboard = await leaderboardStore.getWeeklyLeaderboardPage(
            selectedGameweek,
            currentPage
          );
          break;
        case 2:
          leaderboard = await leaderboardStore.getMonthlyLeaderboard(
            selectedTeamId,
            selectedMonth,
            currentPage
          );
          break;
        case 3:
          leaderboard = await leaderboardStore.getSeasonLeaderboardPage(
            currentPage
          );
          break;
      }
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching leaderboard data." },
        err: error,
      });
      console.error("Error fetching leaderboard data:", error);
    } finally {
      isLoading = false;
    }
  }

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  function changeMonth(delta: number) {
    selectedMonth += delta;
    if (selectedMonth > 12) {
      selectedMonth = 1;
    } else if (selectedMonth < 1) {
      selectedMonth = 12;
    }
    loadLeaderboardData();
  }

  function changePage(delta: number) {
    currentPage = Math.max(1, Math.min(totalPages, currentPage + delta));
    loadLeaderboardData();
  }

  function changeLeaderboardType(delta: number) {
    selectedLeaderboardType += delta;
    if (selectedLeaderboardType > 3) {
      selectedLeaderboardType = 1;
    } else if (selectedLeaderboardType < 1) {
      selectedLeaderboardType = 3;
    }
    loadLeaderboardData();
  }

  function changeTeam(delta: number) {
    selectedTeamIndex =
      (selectedTeamIndex + delta + $teamStore.length) % $teamStore.length;
    selectedTeamId = $teamStore[selectedTeamIndex].id;
    loadLeaderboardData();
  }
</script>

{#if isLoading}
  <LoadingIcon />
{:else}
  <div class="container-fluid mt-4">
    <div class="flex flex-col space-y-4 text-xs md:text-base">
      <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
        <div class="flex flex-col sm:flex-row justify-between sm:items-center">
          <div class="md:flex md:items-center md:mt-0 ml-2 md:ml-4">
            <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
              on:click={() => changeLeaderboardType(-1)}>&lt;</button>
            <select class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]"
              bind:value={selectedLeaderboardType}>
              <option value={1}>Weekly</option>
              <option value={2}>Monthly</option>
              <option value={3}>Season</option>
            </select>
            <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
              on:click={() => changeLeaderboardType(1)}>&gt;</button>
          </div>

          {#if selectedLeaderboardType === 1}
            <div class="md:flex md:items-center mt-2 sm:mt-0 ml-2">
              <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
                on:click={() => changeGameweek(-1)}
                disabled={selectedGameweek === 1}>&lt;</button>
              <select class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px] md:min-w-[140px]"
                bind:value={selectedGameweek}>
                {#each gameweeks as gameweek}
                  <option value={gameweek}>Gameweek {gameweek}</option>
                {/each}
              </select>
              <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
                on:click={() => changeGameweek(1)}
                disabled={selectedGameweek === 38}>&gt;</button>
            </div>
          {/if}

          {#if selectedLeaderboardType === 2}
            <div class="sm:flex sm:items-center sm:mt-0 mt-2 ml-2">
              <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
                on:click={() => changeTeam(-1)}>
                &lt;
              </button>

              <select class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]"
                bind:value={selectedTeamId}>
                {#each $teamStore.sort((a,b) => a.friendlyName.localeCompare(b.friendlyName)) as team}
                  <option value={team.id}>{team.friendlyName}</option>
                {/each}
              </select>

              <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
                on:click={() => changeTeam(1)}>
                &gt;
              </button>
            </div>

            <div class="sm:flex sm:items-center sm:mt-0 mt-2 ml-2">
              <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
                on:click={() => changeMonth(-1)}>
                &lt;
              </button>

              <select class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px] md:min-w-[150px]"
                bind:value={selectedMonth}>
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

              <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
                on:click={() => changeMonth(1)}>
                &gt;
              </button>
            </div>
          {/if}
        </div>
      </div>
      <div class="flex flex-col space-y-4 mt-4 text-xs md:text-base">
        <div class="overflow-x-auto flex-1">
          <div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray">
            <div class="w-1/6 px-4">Pos</div>
            <div class="w-1/3 px-4">Manager</div>
            <div class="w-1/2 px-4">Points</div>
          </div>

          {#if leaderboard && leaderboard.entries.length > 0}
            {#each leaderboard.entries as entry}
              <div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer">
                <div class="w-1/6 px-4">{entry.positionText}</div>
                <div class="w-1/3 px-4">
                  <a href={`/manager?id=${entry.principalId}&gw=${selectedGameweek}`}>{entry.principalId === entry.username ? "Unknown" : entry.username}</a>
                </div>
                <div class="w-1/2 px-4">{entry.points}</div>
              </div>
            {/each}
            <div class="flex justify-center items-center mt-4 mb-4">
              <button on:click={() => changePage(-1)} disabled={currentPage === 1}
                class="px-4 py-2 mx-2 fpl-button rounded disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] text-sm">
                Previous
              </button>

              <span class="px-4">Page {currentPage}</span>

              <button on:click={() => changePage(1)} disabled={currentPage >= totalPages} 
                class="px-4 py-2 mx-2 fpl-button rounded disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] text-sm">
                Next
              </button>
            </div>
          {:else}
            <p class="w-100 p-4">No leaderboard data.</p>
          {/if}
        </div>
      </div>
    </div>
  </div>
{/if}
