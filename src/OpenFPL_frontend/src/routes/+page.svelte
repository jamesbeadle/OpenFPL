<script lang="ts">
  import { onMount } from "svelte";
  import { authStore } from "$lib/stores/auth.store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { teamStore } from "$lib/stores/team-store";
  import { leaderboardStore } from "$lib/stores/leaderboard-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { managerStore } from "$lib/stores/manager-store";
  import {
    formatUnixDateToReadable,
    formatUnixDateToSmallReadable,
    formatUnixTimeToTime,
    getCountdownTime,
  } from "../lib/utils/Helpers";
  import type {
    LeaderboardEntry,
    Team,
  } from "../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import Layout from "./Layout.svelte";
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponents from "$lib/components/gameweek-points.svelte";
  import LeaderboardsComponent from "$lib/components/leaderboards.svelte";
  import LeagueTableComponent from "$lib/components/league-table.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { Spinner } from "@dfinity/gix-components";

  let activeTab: string = "fixtures";
  let managerCount = -1;
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let nextFixtureDate = "-";
  let nextFixtureDateSmall = "-";
  let nextFixtureTime = "-";
  let weeklyLeader: LeaderboardEntry;
  let nextFixtureHomeTeam: Team | undefined = undefined;
  let nextFixtureAwayTeam: Team | undefined = undefined;
  let isLoggedIn = false;
  let isLoading = true;

  onMount(async () => {
    try {
      await authStore.sync();
      await systemStore.sync();
      await fixtureStore.sync();
      await teamStore.sync();
      await leaderboardStore.syncWeeklyLeaderboard();

      authStore.subscribe((store) => {
        isLoggedIn = store.identity !== null && store.identity !== undefined;
      });

      managerCount = await managerStore.getTotalManagers();

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
      nextFixtureDateSmall = formatUnixDateToSmallReadable(
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
      toastsError({
        msg: { text: "Error fetching homepage data." },
        err: error,
      });
      console.error("Error fetching homepage data:", error);
    } finally {
      isLoading = false;
    }
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <div class="page-header-wrapper">
      <div class="content-panel w-1/2">
        <div class="flex-grow">
          <p class="content-panel-header">
            Gameweek
          </p>
          <p class="content-panel-stat">
            {$systemStore?.activeGameweek}
          </p>
          <p class="content-panel-header">
            {$systemStore?.activeSeason.name}
          </p>
        </div>
        <div class="vertical-divider" />
        <div class="flex-grow">
          <p class="content-panel-header">
            Managers
          </p>
          <p class="content-panel-stat">
            {managerCount}
          </p>
          <p class="content-panel-header">Total</p>
        </div>
        <div class="vertical-divider" />
        <div class="flex-grow">
          <p class="hidden md:block content-panel-header">
            Weekly Prize Pool
          </p>
          <p class="md:hidden content-panel-header">
            Weekly
          </p>
          <p class="content-panel-stat">
            0
          </p>
          <p class="content-panel-header">
            $FPL
          </p>
        </div>
      </div>

      <div class="flex xs:hidden">
        <div class="content-panel">
          <div class="flex flex-grow flex-col mt-2 w-1/3">
            <p class="content-panel-header">
              Next Game
            </p>
            
            <div class="flex justify-start ml-1 items-center mb-2">
              <div class="flex">
                <a
                  class="flex flex-col items-center justify-center"
                  href={`/club?id=${
                    nextFixtureHomeTeam ? nextFixtureHomeTeam.id : -1
                  }`}
                >
                  <BadgeIcon
                    className="h-5 mb-2 mt-2"
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
                  <span class="content-panel-header">{nextFixtureHomeTeam ? nextFixtureHomeTeam.abbreviatedName : ""}</span>
                </a>
              </div>
              <div class="w-v ml-1 mr-1 flex justify-center">
                <p class="text-xs mt-2 mb-2 font-bold">v</p>
              </div>
              <div class="flex">
                <a
                  class="flex flex-col items-center justify-center"
                  href={`/club?id=${
                    nextFixtureAwayTeam ? nextFixtureAwayTeam.id : -1
                  }`}
                >
                  <BadgeIcon
                    className="h-5 mb-2 mt-2"
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
                  <span class="content-panel-header">{nextFixtureAwayTeam ? nextFixtureAwayTeam.abbreviatedName: ""}</span>
                </a>
              </div>
            </div>
          </div>
          <div class="vertical-divider" />
          <div class="flex-grow">
            <p class="content-panel-header">
              Kick Off
            </p>
            <div class="flex">
              <p class="content-panel-stat">
                {countdownDays}<span class="text-gray-300 text-xs ml-1">d</span>
                : {countdownHours}<span class="text-gray-300 text-xs ml-1"
                  >h</span
                >
                : {countdownMinutes}<span class="text-gray-300 text-xs ml-1"
                  >m</span
                >
              </p>
            </div>
            <p class="lg:hidden 2xl:hidden content-panel-header">
              {nextFixtureDateSmall}
            </p>
          </div>
        </div>
      </div>
      
      <div class="hidden xs:flex w-1/2">
        <div class="content-panel">
          <div class="flex-grow">
            <p class="content-panel-header">
              Next Game
            </p>
            <div class="flex flex-row">
              <div class="flex justify-center">
                <a
                  class="flex flex-col items-center justify-left mt-4 lg:mt-3 xl:mt-6"
                  href={`/club?id=${
                    nextFixtureHomeTeam ? nextFixtureHomeTeam.id : -1
                  }`}
                >
                  <BadgeIcon
                    className="h-6 mb-4"
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
                  <span class="content-panel-header">
                    {nextFixtureHomeTeam ? nextFixtureHomeTeam.abbreviatedName : ""}
                  </span>
                </a>
              </div>
              <div class="w-v ml-1 mr-1 flex justify-center mt-6 lg:mt-2 xl:mt-6">
                <p class="text-xs mt-2 mb-2 font-bold">v</p>
              </div>
              <div class="flex justify-center">
                <a
                  class="flex flex-col items-center justify-center mt-4 lg:mt-3 xl:mt-6"
                  href={`/club?id=${
                    nextFixtureAwayTeam ? nextFixtureAwayTeam.id : -1
                  }`}
                >
                  <BadgeIcon
                    className="h-6 mb-4"
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
                  <span class="content-panel-header">
                    {nextFixtureAwayTeam ? nextFixtureAwayTeam.abbreviatedName : ""}
                  </span>
                </a>
              </div>
            </div>
          </div>
          <div class="vertical-divider" />
          <div class="flex-grow">
            <p class="content-panel-header">
              Kick Off
            </p>
            <p class="content-panel-stat">
              {countdownDays}<span class="text-gray-300 text-xs ml-1">d</span>
              : {countdownHours}<span class="text-gray-300 text-xs ml-1">h</span>
              : {countdownMinutes}<span class="text-gray-300 text-xs ml-1">m</span>
            </p>
            <p class="md:hidden content-panel-header">
              {nextFixtureDateSmall}
            </p>
            <p class="hidden md:flex content-panel-header">
              {nextFixtureDate}
            </p>
          </div>
          <div class="vertical-divider" />
          <div class="flex-grow">
            <p class="content-panel-header">
              GW {$systemStore?.focusGameweek} High Score
            </p>
            <p
              class="content-panel-stat max-w-[200px] truncate"
            >
              {#if weeklyLeader}
                <a
                  href={`/manager?id=${weeklyLeader.principalId}&gw=${$systemStore?.focusGameweek}`}
                  >{weeklyLeader.principalId === weeklyLeader.username
                    ? "Unknown"
                    : weeklyLeader.username}</a
                >
              {:else}
                -
              {/if}
            </p>
            <p class="content-panel-header">
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
    
    <div class="bg-panel rounded-md">
      <ul
        class="flex bg-light-gray px-1 md:px-4 pt-2 text-xxs sm:text-base md:text-lg border-b border-gray-700"
      >
        <li
          class={`mr-1 md:mr-4 ${
            activeTab === "fixtures" ? "active-tab" : ""
          }`}
        >
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
          <li
            class={`mr-1 md:mr-4 ${
              activeTab === "points" ? "active-tab" : ""
            }`}
          >
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
        <li
          class={`mr-1 md:mr-4 ${
            activeTab === "leaderboards" ? "active-tab" : ""
          }`}
        >
          <button
            class={`p-2 ${
              activeTab === "leaderboards" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("leaderboards")}
          >
            Leaderboards
          </button>
        </li>
        <li
          class={`mr-1 md:mr-4 ${
            activeTab === "league-table" ? "active-tab" : ""
          }`}
        >
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
  {/if}
</Layout>

<style>
  .w-v {
    width: 20px;
  }
</style>
