<script lang="ts">
  import { onMount } from "svelte";
  import { adminStore } from "$lib/stores/admin-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import type {
    AdminMainCanisterInfo,
    AdminWeeklyCanisterList,
    AdminMonthlyCanisterList,
    AdminSeasonCanisterList,
    AdminProfilePictureCanisterList,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { authStore } from "$lib/stores/auth.store";
  //have a different array for each canister type as the table produces will have slightly different columns
  //leaderboards will have season and gameweek etc
  //profiles sho;ld have the number of pictures stored

  let selectedCansiterType = "WeeklyLeaderboard";
  let mainCanisterInfo: AdminMainCanisterInfo | null;
  let weeklyLeaderboardCanisters: AdminWeeklyCanisterList | null;
  let monthlyLeaderboardCanisters: AdminMonthlyCanisterList | null;
  let seasonLeaderboardCanisters: AdminSeasonCanisterList | null;
  let profilePictureCanisters: AdminProfilePictureCanisterList | null;
  let currentPage = 1;
  let itemsPerPage = 25;
  let totalPages: number = 0;
  let isLoading = true;

  onMount(async () => {
    try {
      authStore.sync();
      await loadCanisterInfo();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching canister info." },
        err: error,
      });
      console.error("Error fetching gameweek points:", error);
    } finally {
      isLoading = false;
    }
  });

  async function changePage(delta: number) {
    currentPage = Math.max(1, Math.min(totalPages, currentPage + delta));
    await loadCanisterInfo();
  }

  async function loadCanisterInfo() {
    console.log(selectedCansiterType)
    mainCanisterInfo = await adminStore.getMainCanisterInfo();

    switch (selectedCansiterType) {
      case "WeeklyLeaderboard":
        weeklyLeaderboardCanisters = await adminStore.getWeeklyCanisters(
          itemsPerPage,
          currentPage
        );
        console.log(weeklyLeaderboardCanisters);
        break;
      case "MonthlyLeaderboard":
        monthlyLeaderboardCanisters = await adminStore.getMonthlyCanisters(
          itemsPerPage,
          currentPage
        );
        break;
      case "SeasonLeaderboard":
        seasonLeaderboardCanisters = await adminStore.getSeasonCanisters(
          itemsPerPage,
          currentPage
        );
        break;
      case "Profile":
        profilePictureCanisters = await adminStore.getProfilePictureCanisters(
          itemsPerPage,
          currentPage
        );
        break;
    }
  }

  async function changeCanisterType() {
    currentPage = 1;
    await loadCanisterInfo();
  }
</script>

{#if !isLoading}
  <div class="m-4">
    <p>OpenFPL Main Canister</p>
    <p>Id: {mainCanisterInfo?.canisterId}</p>
    <p>Cycles: {mainCanisterInfo?.cycles}</p>

    <div class="flex p-4">
      <div class="flex items-center">
        <p>Type:</p>
        <select
          class="px-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
          on:change={() => changeCanisterType()}
          bind:value={selectedCansiterType}
        >
          <option value={"WeeklyLeaderboard"}>WeeklyLeaderboard</option>
          <option value={"MonthlyLeaderboard"}>MonthlyLeaderboard</option>
          <option value={"SeasonLeaderboard"}>SeasonLeaderboard</option>
          <option value={"Profile"}>Profile</option>
        </select>
      </div>
    </div>

    <div class="flex">
      <div class="w-1/4">
        <p>Canister Id</p>
      </div>
      <div class="w-1/4">
        <p>Cycles Balanace</p>
      </div>
      <div class="w-1/4">
        <p>Options</p>
      </div>
    </div>

    {#if selectedCansiterType === "WeeklyLeaderboard" && weeklyLeaderboardCanisters}
      {#each weeklyLeaderboardCanisters.canisters as canister}
        <div class="flex">
          <div class="w-1/4">
            <p>{canister.canister}</p>
          </div>
          <div class="w-1/4">
            <p>{canister.cycles}</p>
          </div>
          <div class="w-1/4">
            <p>...</p>
          </div>
        </div>
      {/each}
    {/if}

    {#if selectedCansiterType === "monthlyLeaderboard" && monthlyLeaderboardCanisters}
      {#each monthlyLeaderboardCanisters.canisters as canister}
        <div class="flex">
          <div class="w-1/4">
            <p>{canister.canister}</p>
          </div>
          <div class="w-1/4">
            <p>{canister.cycles}</p>
          </div>
          <div class="w-1/4">
            <p>...</p>
          </div>
        </div>
      {/each}
    {/if}

    {#if selectedCansiterType === "SeasonLeaderboard" && seasonLeaderboardCanisters}
      {#each seasonLeaderboardCanisters.canisters as canister}
        <div class="flex">
          <div class="w-1/4">
            <p>{canister.canister}</p>
          </div>
          <div class="w-1/4">
            <p>{canister.cycles}</p>
          </div>
          <div class="w-1/4">
            <p>...</p>
          </div>
        </div>
      {/each}
    {/if}

    {#if selectedCansiterType === "Profile" && profilePictureCanisters}
      {#each profilePictureCanisters.canisters as canister}
        <div class="flex">
          <div class="w-1/4">
            <p>{canister.canisterId}</p>
          </div>
          <div class="w-1/4">
            <p>{canister.cycles}</p>
          </div>
          <div class="w-1/4">
            <p>...</p>
          </div>
        </div>
      {/each}
    {/if}

    <div class="flex justify-center items-center mt-4 mb-4">
      <button
        on:click={() => changePage(-1)}
        disabled={currentPage === 1}
        class={`${currentPage === 1 ? "bg-gray-500" : "fpl-button"}
        disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
      >
        Previous
      </button>

      <span class="px-4">Page {currentPage}</span>

      <button
        on:click={() => changePage(1)}
        disabled={currentPage >= totalPages}
        class={`${currentPage >= totalPages ? "bg-gray-500" : "fpl-button"} 
          disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
      >
        Next
      </button>
    </div>
  </div>
{/if}
