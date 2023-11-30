<script lang="ts">
  import { onMount } from "svelte";
  import { authStore } from "$lib/stores/auth";
  import { toastStore } from "$lib/stores/toast-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { leaderboardStore } from "$lib/stores/leaderboard-store";
  import Layout from "./Layout.svelte";
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponents from "$lib/components/gameweek-points.svelte";
  import LeaderboardsComponent from "$lib/components/leaderboards.svelte";
  import LeagueTableComponent from "$lib/components/league-table.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import {
    formatUnixDateToReadable,
    formatUnixTimeToTime,
    getCountdownTime,
  } from "../lib/utils/Helpers";
  import type {
    LeaderboardEntry,
    Team,
  } from "../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { isLoading } from "$lib/stores/global-stores";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { teamStore } from "$lib/stores/team-store";

  let activeTab: string = "fixtures";
  let activeGameweek = -1;
  let activeSeason = "-";
  let managerCount = -1;
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  let focusGameweek = -1;
  let weeklyLeader: LeaderboardEntry;
  let nextFixtureHomeTeam: Team | undefined = undefined;
  let nextFixtureAwayTeam: Team | undefined = undefined;

  let isLoggedIn = false;

  onMount(async () => {
    isLoading.set(true);
    try {
      await systemStore.sync();
      await teamStore.sync();
      await fixtureStore.sync();
      await leaderboardStore.syncWeeklyLeaderboard();
      await authStore.sync();

      authStore.subscribe((store) => {
        isLoggedIn = store.identity !== null && store.identity !== undefined;
      });

      managerCount = await managerStore.getTotalManagers();

      let systemState = await systemStore.getSystemState();
      console.log(systemState);
      activeGameweek = systemState?.activeGameweek ?? activeGameweek;
      activeSeason = systemState?.activeSeason.name ?? activeSeason;
      focusGameweek = systemState?.focusGameweek ?? activeGameweek;

      let nextFixture = await fixtureStore.getNextFixture();

      nextFixtureHomeTeam = await teamStore.getTeamById(
        nextFixture ? nextFixture.homeTeamId : 0
      );
      nextFixtureAwayTeam = await teamStore.getTeamById(
        nextFixture ? nextFixture.awayTeamId : 0
      );
      nextFixtureDate = formatUnixDateToReadable(
        nextFixture ? Number(nextFixture.kickOff) : 0
      );
      nextFixtureTime = formatUnixTimeToTime(
        nextFixture ? Number(nextFixture.kickOff) : 0
      );

      let countdownTime = getCountdownTime(
        nextFixture ? Number(nextFixture.kickOff) : 0
      );
      countdownDays = countdownTime.days.toString();
      countdownHours = countdownTime.hours.toString();
      countdownMinutes = countdownTime.minutes.toString();

      weeklyLeader = await leaderboardStore.getLeadingWeeklyTeam();
    } catch (error) {
      toastStore.show("Error fetching homepage data.", "error");
      console.error("Error fetching homepage data:", error);
    } finally {
      isLoading.set(false);
    }
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>
  <div class="m-4">
    <div class="flex flex-col lg:flex-row">
      <div
        class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
      >
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Gameweek</p>
          <p class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold">
            {activeGameweek}
          </p>
          <p class="text-gray-300 text-xs">{activeSeason}</p>
        </div>
        <div
          class="flex-shrink-0 w-px bg-gray-400 self-stretch"
          style="min-width: 2px; min-height: 50px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Managers</p>
          <p class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold">
            {managerCount}
          </p>
          <p class="text-gray-300 text-xs">Total</p>
        </div>
        <div
          class="flex-shrink-0 w-px bg-gray-400 self-stretch"
          style="min-width: 2px; min-height: 50px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Weekly Prize Pool</p>
          <p class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold">0</p>
          <p class="text-gray-300 text-xs">$FPL</p>
        </div>
      </div>
      <div
        class="flex flex-col lg:flex-row justify-start lg:items-center text-white space-x-0 lg:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
      >
        <div class="flex-grow mb-4 lg:mb-0">
          <p class="text-gray-300 text-xs">Next Game:</p>
          <div class="flex justify-center mb-2 mt-2">
            <div class="flex justify-center items-center">
              <div class="w-10 ml-4 mr-4">
                <a
                  href={`/club?id=${
                    nextFixtureHomeTeam ? nextFixtureHomeTeam.id : -1
                  }`}
                >
                  <BadgeIcon
                    primaryColour={nextFixtureHomeTeam
                      ? nextFixtureHomeTeam.primaryColourHex
                      : ""}
                    secondaryColour={nextFixtureHomeTeam
                      ? nextFixtureHomeTeam.secondaryColourHex
                      : ""}
                    thirdColour={nextFixtureHomeTeam
                      ? nextFixtureHomeTeam.thirdColourHex
                      : ""}
                  />
                </a>
              </div>
              <div class="w-v ml-1 mr-1 flex justify-center">
                <p class="text-xs mt-2 mb-2 font-bold">v</p>
              </div>
              <div class="w-10 ml-4">
                <a
                  href={`/club?id=${
                    nextFixtureAwayTeam ? nextFixtureAwayTeam.id : -1
                  }`}
                >
                  <BadgeIcon
                    primaryColour={nextFixtureAwayTeam
                      ? nextFixtureAwayTeam.primaryColourHex
                      : ""}
                    secondaryColour={nextFixtureAwayTeam
                      ? nextFixtureAwayTeam.secondaryColourHex
                      : ""}
                    thirdColour={nextFixtureAwayTeam
                      ? nextFixtureAwayTeam.thirdColourHex
                      : ""}
                  />
                </a>
              </div>
            </div>
          </div>
          <div class="flex justify-center">
            <div class="w-10 ml-4 mr-4">
              <p class="text-gray-300 text-xs text-center">
                <a
                  class="text-gray-300 text-xs text-center"
                  href={`/club?id=${
                    nextFixtureHomeTeam ? nextFixtureHomeTeam.id : -1
                  }`}
                >
                  {nextFixtureHomeTeam
                    ? nextFixtureHomeTeam.abbreviatedName
                    : ""}</a
                >
              </p>
            </div>
            <div class="w-v ml-1 mr-1" />
            <div class="w-10 ml-4">
              <p class="text-gray-300 text-xs text-center">
                <a
                  class="text-gray-300 text-xs text-center"
                  href={`/club?id=${
                    nextFixtureAwayTeam ? nextFixtureAwayTeam.id : -1
                  }`}
                >
                  {nextFixtureAwayTeam
                    ? nextFixtureAwayTeam.abbreviatedName
                    : ""}</a
                >
              </p>
            </div>
          </div>
        </div>
        <div
          class="h-px bg-gray-400 w-full lg:w-px lg:h-full lg:self-stretch"
          style="min-height: 2px; min-width: 2px;"
        />

        <div class="flex-grow mb-4 lg:mb-0">
          <p class="text-gray-300 text-xs mt-4 lg:mt-0">Kick Off:</p>
          <div class="flex">
            <p class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold">
              {countdownDays}<span class="text-gray-300 text-xs ml-1">d</span>
              : {countdownHours}<span class="text-gray-300 text-xs ml-1">h</span
              >
              : {countdownMinutes}<span class="text-gray-300 text-xs ml-1"
                >m</span
              >
            </p>
          </div>
          <p class="text-gray-300 text-xs">
            {nextFixtureDate} | {nextFixtureTime}
          </p>
        </div>
        <div
          class="h-px bg-gray-400 w-full lg:w-px lg:h-full lg:self-stretch"
          style="min-height: 2px; min-width: 2px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs mt-4 lg:mt-0">
            GW {focusGameweek} High Score
          </p>
          <p
            class="text-2xl sm:text-3xl lg:text-4xl mt-2 mb-2 font-bold max-w-[200px] truncate"
          >
            {#if weeklyLeader}
              <a
                href={`/manager?id=${weeklyLeader.principalId}&gw=${activeGameweek}`}
                >{weeklyLeader.username}</a
              >
            {:else}
              -
            {/if}
          </p>
          <p class="text-gray-300 text-xs">
            {#if weeklyLeader}
              {weeklyLeader.points} points
            {:else}
              -
            {/if}
          </p>
        </div>
      </div>
    </div>
  </div>

  <div class="mx-4">
    <div class="bg-panel rounded-md mx-4">
      <ul class="flex bg-light-gray px-4 pt-2 text-sm sm:text-base md:text-lg">
        <li class={`mr-4 ${activeTab === "fixtures" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "fixtures" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("fixtures")}
          >
            Fixtures
          </button>
        </li>
        {#if isLoggedIn}
          <li class={`mr-4 ${activeTab === "points" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "points" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("points")}
            >
              Points
            </button>
          </li>
        {/if}
        <li class={`mr-4 ${activeTab === "leaderboards" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "leaderboards" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("leaderboards")}
          >
            Leaderboards
          </button>
        </li>
        <li class={`mr-4 ${activeTab === "league-table" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "league-table" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("league-table")}
          >
            Table
          </button>
        </li>
      </ul>

      {#if activeTab === "fixtures"}
        <FixturesComponent />
      {:else if activeTab === "points"}
        <GamweekPointsComponents />
      {:else if activeTab === "leaderboards"}
        <LeaderboardsComponent />
      {:else if activeTab === "league-table"}
        <LeagueTableComponent />
      {/if}
    </div>
  </div>
</Layout>

<style>
  .w-v {
    width: 20px;
  }
</style>
