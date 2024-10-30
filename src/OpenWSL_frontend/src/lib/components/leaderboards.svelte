<script lang="ts">
  import { onMount } from "svelte";
  import { toastsError } from "$lib/stores/toasts-store";
  import { clubStore } from "$lib/stores/club-store";
  import { systemStore } from "$lib/stores/system-store";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { userGetFavouriteTeam } from "$lib/derived/user.derived";
  import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";
  import { monthlyLeaderboardStore } from "$lib/stores/monthly-leaderboard-store";
  import { seasonLeaderboardStore } from "$lib/stores/season-leaderboard-store";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
    import LocalSpinner from "./local-spinner.svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { page } from "$app/stores";

  let isLoading = true;
  let gameweeks = Array.from(
    { length: $systemStore?.calculationGameweek ?? 1 },
    (_, i) => i + 1
  );
  let currentPage = 1;
  let itemsPerPage = 25;

  let selectedLeaderboardType: number = 1;
  let selectedSeasonId: number;
  let selectedGameweek: number;
  let selectedMonth: number;
  let selectedTeamId: number;

  let leaderboard: any;
  let totalPages: number = 0;
  let selectedTeamIndex: number = 0;
  let searchTerm = "";
  let searchInput = "";

  $: selectedTeamIndex = $clubStore.findIndex(
    (team) => team.id === selectedTeamId
  );

  $: if (leaderboard && leaderboard.totalEntries) {
    totalPages = Math.ceil(Number(leaderboard.totalEntries) / itemsPerPage);
  }

  onMount(async () => {
    try {
      await storeManager.syncStores();
      
      await monthlyLeaderboardStore.sync(
        $systemStore?.calculationSeasonId ?? 1,
        $systemStore?.calculationMonth ?? 8,
        1 //TODO
      );
      
      await seasonLeaderboardStore.sync(
        $systemStore?.calculationSeasonId ?? 1
      );

      selectedSeasonId = $systemStore?.calculationSeasonId ?? 1;
      selectedGameweek = $systemStore?.calculationGameweek ?? 1;
      selectedMonth = $systemStore?.calculationMonth ?? 8;
      selectedTeamId = $authSignedInStore
        ? $userGetFavouriteTeam ??
          $clubStore.sort((a, b) =>
            a.friendlyName.localeCompare(b.friendlyName)
          )[0].id
        : $clubStore.sort((a, b) =>
            a.friendlyName.localeCompare(b.friendlyName)
          )[0].id;


      let leaderboardData = await weeklyLeaderboardStore.getWeeklyLeaderboard(
        selectedSeasonId,
        selectedGameweek,
        currentPage,
        25
      );
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

  function performSearch() {
    searchTerm = searchInput;
    loadLeaderboardData();
  }

  function handleKeydown(event: KeyboardEvent) {
    if (event.key === "Enter") {
      performSearch();
    }
  }

  async function loadLeaderboardData() {
    if (!selectedGameweek) {
      return;
    }

    isLoading = true;
    try {
      switch (selectedLeaderboardType) {
        case 1:
          leaderboard = await weeklyLeaderboardStore.getWeeklyLeaderboard(
            selectedSeasonId,
            selectedGameweek,
            currentPage,
            25
          );
          break;
        case 2:
          leaderboard = await monthlyLeaderboardStore.getMonthlyLeaderboard(
            selectedSeasonId,
            selectedTeamId,
            selectedMonth,
            currentPage,
            searchTerm
          );
          break;
        case 3:
          leaderboard = await seasonLeaderboardStore.getSeasonLeaderboard(
            selectedSeasonId,
            currentPage,
            searchTerm
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
    selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), selectedGameweek + delta));
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
      (selectedTeamIndex + delta + $clubStore.length) % $clubStore.length;

    if (selectedTeamIndex > $clubStore.length - 1) {
      selectedTeamIndex = 0;
    }

    selectedTeamId = $clubStore[selectedTeamIndex].id;
    loadLeaderboardData();
  }
</script>

{#if isLoading}
  <LocalSpinner />
  <p class="w-full px-4 mb-4">Loading leaderboard.</p>
{:else}
  <div class="flex flex-col space-y-4">
    <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
      <div class="flex flex-col sm:flex-row justify-between sm:items-center">
        <div class="md:flex md:items-center md:mt-0 ml-2 md:ml-4">
          <button
            class="default-button fpl-button"
            on:click={() => changeLeaderboardType(-1)}>&lt;</button
          >
          <select
            class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[125px]"
            bind:value={selectedLeaderboardType}
          >
            <option value={1}>Weekly</option>
            <option value={2}>Monthly</option>
            <option value={3}>Season</option>
          </select>
          <button
            class="default-button fpl-button ml-2"
            on:click={() => changeLeaderboardType(1)}>&gt;</button
          >
        </div>

        {#if selectedLeaderboardType === 1}
          <div class="md:flex md:items-center mt-2 sm:mt-0 ml-2">
            <button
              class={`${
                selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
              } default-button mr-1`}
              on:click={() => changeGameweek(-1)}
              disabled={selectedGameweek === 1}>&lt;</button
            >
            <select
              class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[125px]"
              bind:value={selectedGameweek}
            >
              {#each gameweeks as gameweek}
                <option value={gameweek}>Gameweek {gameweek}</option>
              {/each}
            </select>
            <button
              class={`${
                selectedGameweek === $systemStore?.calculationGameweek
                  ? "bg-gray-500"
                  : "fpl-button"
              } default-button ml-1`}
              on:click={() => changeGameweek(1)}
              disabled={selectedGameweek === $systemStore?.calculationGameweek}
              >&gt;</button
            >
          </div>
        {/if}

        {#if selectedLeaderboardType === 2}
          <div class="sm:flex sm:items-center sm:mt-0 mt-2 ml-2">
            <button
              class="fpl-button default-button"
              on:click={() => changeTeam(-1)}
            >
              &lt;
            </button>

            <select
              class="p-2 fpl-dropdown my-4 min-w-[100px]"
              bind:value={selectedTeamId}
            >
              {#each $clubStore.sort( (a, b) => a.friendlyName.localeCompare(b.friendlyName) ) as team}
                <option value={team.id}>{team.friendlyName}</option>
              {/each}
            </select>

            <button
              class="default-button fpl-button ml-1"
              on:click={() => changeTeam(1)}
            >
              &gt;
            </button>
          </div>

          <div class="sm:flex sm:items-center sm:mt-0 mt-2 ml-2">
            <button
              class="fpl-button default-button"
              on:click={() => changeMonth(-1)}
            >
              &lt;
            </button>

            <select
              class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
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
              class="default-button fpl-button ml-1"
              on:click={() => changeMonth(1)}
            >
              &gt;
            </button>
          </div>
        {/if}
      </div>
    </div>

    <div class="flex items-center mb-4 mx-3">
      <input
        type="text"
        class="input-field p-2"
        placeholder="Search for manager..."
        bind:value={searchInput}
        on:keydown={handleKeydown}
      />
      <button
        class="ml-2 py-2 px-4 rounded fpl-button"
        on:click={performSearch}
      >
        Search
      </button>
    </div>

    <div class="flex flex-col space-y-4 mt-4">
      <div class="overflow-x-auto flex-1">
        <div
          class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
        >
          <div class="w-2/12 xs:w-2/12 px-4">Pos</div>
          <div class="w-5/12 xs:w-4/12 px-4">Manager</div>
          <div class="w-2/12 xs:w-2/12 px-4">Points</div>
          <div class="w-3/12 xs:w-4/12 px-4">&nbsp;</div>
        </div>

        {#if leaderboard && leaderboard.entries && leaderboard.entries.length > 0}
          {#each leaderboard.entries as entry}
            <a href={`/manager?id=${entry.principalId}&gw=${selectedGameweek}`}>
              <div
                class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer"
              >
                <div class="w-2/12 xs:w-2/12 px-4">{entry.positionText}</div>
                <div class="w-5/12 xs:w-4/12 px-4">
                  {entry.principalId === entry.username
                    ? "Unknown"
                    : entry.username}
                </div>
                <div class="w-2/12 xs:w-2/12 px-4">{entry.points}</div>
                <div
                  class="w-3/12 xs:w-4/12 flex items-center justify-center xs:justify-center"
                >
                  <span class="flex items-center">
                    <ViewDetailsIcon className="w-5 xs:w-6 lg:w-7" />
                    <span class="hidden xs:flex ml-1 lg:ml-2">View Details</span
                    >
                  </span>
                </div>
              </div>
            </a>
          {/each}
          <div class="flex justify-center items-center mt-4 mb-4">
            <button
              on:click={() => changePage(-1)}
              disabled={currentPage === 1}
              class={`${selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"}
              disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
            >
              Previous
            </button>

            <span class="px-4">Page {currentPage}</span>

            <button
              on:click={() => changePage(1)}
              disabled={currentPage >= totalPages}
              class={`${
                selectedGameweek === $systemStore?.calculationGameweek
                  ? "bg-gray-500"
                  : "fpl-button"
              } 
                disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
            >
              Next
            </button>
          </div>
        {:else}
          <p class="w-full p-4">No leaderboard data.</p>
        {/if}
      </div>
    </div>
  </div>
{/if}
