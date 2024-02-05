<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { authStore } from "$lib/stores/auth.store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { teamStore } from "$lib/stores/team-store";
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
    ClubDTO,
  } from "../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import Layout from "./Layout.svelte";
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponents from "$lib/components/gameweek-points.svelte";
  import LeaderboardsComponent from "$lib/components/leaderboards.svelte";
  import LeagueTableComponent from "$lib/components/league-table.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { Spinner } from "@dfinity/gix-components";
  import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";
  import OpenFplIcon from "$lib/icons/OpenFPLIcon.svelte";

  let activeTab: string = "fixtures";
  let managerCount = 0;
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let nextFixtureDate = "-";
  let nextFixtureDateSmall = "-";
  let nextFixtureTime = "-";
  let weeklyLeader: LeaderboardEntry;
  let nextFixtureHomeTeam: ClubDTO | undefined = undefined;
  let nextFixtureAwayTeam: ClubDTO | undefined = undefined;
  let isLoggedIn = false;
  let isLoading = true;

  onMount(async () => {
    try {
      await authStore.sync();
      await systemStore.sync();
      await teamStore.sync();
      await fixtureStore.sync($systemStore?.calculationSeasonId ?? 1);

      if ($teamStore.length == 0) return;
      if ($fixtureStore.length == 0) return;

      await weeklyLeaderboardStore.sync(
        $systemStore?.calculationSeasonId ?? 1,
        $systemStore?.calculationGameweek ?? 1
      );

      authStore.subscribe((store) => {
        isLoggedIn = store.identity !== null && store.identity !== undefined;
      });

      managerCount = await managerStore.getTotalManagers();

      if ($teamStore.length == 0) {
        return [];
      }

      let nextFixture = await fixtureStore.getNextFixture();

      nextFixtureHomeTeam = await teamStore.getTeamById(
        nextFixture ? nextFixture.homeClubId : 0
      );
      nextFixtureAwayTeam = await teamStore.getTeamById(
        nextFixture ? nextFixture.awayClubId : 0
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

      weeklyLeader = await weeklyLeaderboardStore.getLeadingWeeklyTeam(
        $systemStore?.calculationSeasonId ?? 1,
        $systemStore?.calculationGameweek ?? 1
      );
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

  //TODO: Remove when the game begins:

  const targetDate = new Date("June 1, 2024 00:00:00").getTime();
  let countdown: string = "00d 00h 00m 00s";
  let interval: ReturnType<typeof setInterval>;

  onMount(() => {
    // Start the countdown timer
    interval = setInterval(() => {
      const now = new Date().getTime();
      const timeLeft = targetDate - now;

      if (timeLeft < 0) {
        clearInterval(interval);
        countdown = "EXPIRED";
        return;
      }

      // Time calculations for days, hours, minutes and seconds
      const days = Math.floor(timeLeft / (1000 * 60 * 60 * 24))
        .toString()
        .padStart(2, "0");
      const hours = Math.floor(
        (timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
      )
        .toString()
        .padStart(2, "0");
      const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60))
        .toString()
        .padStart(2, "0");
      const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000)
        .toString()
        .padStart(2, "0");

      countdown = `${days}d ${hours}h ${minutes}m ${seconds}s`;
    }, 1000);
  });

  onDestroy(() => {
    // Clear the interval when the component is destroyed
    clearInterval(interval);
  });
</script>

<Layout>
  {#if isLoading || !$systemStore}
    <Spinner />
  {:else}
    <!-- Todo: This will be removed when the game begins -->
    <div class="flex flex-col lg:flex-row w-full mt-4">
      <div
        class="flex flex-col items-center text-center p-4 lg:p-8 rounded-lg shadow-lg bg-panel-color w-full mx-2 lg:mx-16"
      >
        <OpenFplIcon className="h-16 lg:h-64 w-auto mb-2 lg:mb-4" />
        <div class="text-xl lg:text-3xl font-bold my-2 lg:my-4">
          {countdown}
        </div>
        <h2 class="text-md lg:text-xl my-2 lg:my-4">Until OpenFPL Begins</h2>
        <div class="horizontal-divider my-2 lg:my-4" />
        <h2 class="text-md lg:text-xl">2024/25 Prize Pool:</h2>
        <h2 class="text-lg lg:text-2xl font-bold">1,875,000 $FPL</h2>
        <div class="horizontal-divider my-2 lg:my-4" />
        <div
          class="flex flex-col lg:flex-row space-y-2 lg:space-y-0 lg:space-x-4 w-full mt-2"
        >
          <a class="w-full lg:flex-grow" href="/whitepaper">
            <button
              class="fpl-purple-btn w-full lg:flex-grow p-2 lg:p-4 rounded-md"
              >Whitepaper</button
            >
          </a>
          <a class="w-full lg:flex-grow" href="/clubs">
            <button
              class="fpl-purple-btn w-full lg:flex-grow p-2 lg:p-4 rounded-md"
              >Clubs</button
            >
          </a>
          <a class="w-full lg:flex-grow" href="/governance">
            <button
              class="fpl-purple-btn w-full lg:flex-grow p-2 lg:p-4 rounded-md"
              >Proposals</button
            >
          </a>
        </div>
      </div>

      <div class="lg:w-1/4 w-full my-4 lg:my-0">
        <img alt="play" class="rounded-lg mx-auto" src="play.png" />
      </div>
    </div>

    <!-- Todo: This will be added back in when the game begins -->
    <!-- 
      <div class="page-header-wrapper flex">
        <div class="content-panel lg:w-1/2">
          <div class="flex-grow">
            <p class="content-panel-header">Gameweek</p>
            <p class="content-panel-stat">
              {$systemStore?.pickTeamGameweek}
            </p>
            <p class="content-panel-header">
              {$systemStore?.pickTeamSeasonName}
            </p>
          </div>
          <div class="vertical-divider" />
          <div class="flex-grow">
            <p class="content-panel-header">Managers</p>
            <p class="content-panel-stat">
              {managerCount}
            </p>
            <p class="content-panel-header">Total</p>
          </div>
          <div class="vertical-divider" />
          <div class="flex-grow">
            <p class="hidden md:block content-panel-header">Weekly Prize Pool</p>
            <p class="md:hidden content-panel-header">Weekly</p>
            <p class="content-panel-stat">0</p>
            <p class="content-panel-header">$FPL</p>
          </div>
        </div>

        <div class="flex lg:hidden">
          <div class="content-panel">
            <div class="flex flex flex-col mt-2 xs:mr-2">
              <p class="content-panel-header">Next Game</p>

              <div class="flex justify-start ml-1 items-center mb-2">
                <div class="flex">
                  <a
                    class="flex flex-col items-center justify-center"
                    href={`/club?id=${
                      nextFixtureHomeTeam ? nextFixtureHomeTeam.id : -1
                    }`}
                  >
                    <BadgeIcon
                      className="h-4 sm:h-6 my-2 sm:my-4"
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
                    <span class="content-panel-header"
                      >{nextFixtureHomeTeam
                        ? nextFixtureHomeTeam.abbreviatedName
                        : "-"}</span
                    >
                  </a>
                </div>
                <div class="w-v ml-1 mr-1 flex justify-center">
                  <p class="mt-2 mb-2">v</p>
                </div>
                <div class="flex">
                  <a
                    class="flex flex-col items-center justify-center"
                    href={`/club?id=${
                      nextFixtureAwayTeam ? nextFixtureAwayTeam.id : -1
                    }`}
                  >
                    <BadgeIcon
                      className="h-4 sm:h-6 my-2 sm:my-4"
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
                    <span class="content-panel-header"
                      >{nextFixtureAwayTeam
                        ? nextFixtureAwayTeam.abbreviatedName
                        : "-"}</span
                    >
                  </a>
                </div>
              </div>
            </div>
            <div class="vertical-divider" />
            <div class="flex-grow">
              <p class="content-panel-header">Kick Off</p>
              <div class="flex">
                <p class="content-panel-stat">
                  {countdownDays}<span class="countdown-text">d</span>
                  : {countdownHours}<span class="countdown-text">h</span>
                  : {countdownMinutes}<span class="countdown-text">m</span>
                </p>
              </div>
              <p class="hidden xs:flex content-panel-header">
                {nextFixtureDate}
              </p>
              <p class="xs:hidden content-panel-header">
                {nextFixtureDateSmall}
              </p>
            </div>
          </div>
        </div>

        <div class="hidden lg:flex w-1/2">
          <div class="content-panel">
            <div class="flex-grow">
              <p class="content-panel-header">Next Game</p>
              <div class="flex flex-row">
                <div class="flex justify-center">
                  <a
                    class="flex flex-col items-center justify-left mt-5"
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
                      {nextFixtureHomeTeam
                        ? nextFixtureHomeTeam.abbreviatedName
                        : "-"}
                    </span>
                  </a>
                </div>
                <div
                  class="w-v ml-1 mr-1 flex justify-center mt-6 lg:mt-2 xl:mt-6"
                >
                  <p class="mt-2 mb-2">v</p>
                </div>
                <div class="flex justify-center">
                  <a
                    class="flex flex-col items-center justify-center mt-5"
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
                      {nextFixtureAwayTeam
                        ? nextFixtureAwayTeam.abbreviatedName
                        : "-"}
                    </span>
                  </a>
                </div>
              </div>
            </div>
            <div class="vertical-divider" />
            <div class="flex-grow">
              <p class="content-panel-header">Kick Off</p>
              <p class="content-panel-stat">
                {countdownDays}<span class="countdown-text">d</span>
                : {countdownHours}<span class="countdown-text">h</span>
                : {countdownMinutes}<span class="countdown-text">m</span>
              </p>
              <p class="hidden md:flex content-panel-header">
                {nextFixtureDate}
              </p>
            </div>
            <div class="vertical-divider" />
            <div class="flex-grow">
              <p class="content-panel-header">
                GW {$systemStore?.calculationGameweek} High Score
              </p>
              <p class="content-panel-stat max-w-[200px] truncate">
                {#if weeklyLeader}
                  <a
                    href={`/manager?id=${weeklyLeader.principalId}&gw=${$systemStore?.calculationGameweek}`}
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
          class="flex bg-light-gray px-1 md:px-4 pt-2 contained-text border-b border-gray-700 mb-4"
        >
          <li
            class={`mr-1 md:mr-4 ${activeTab === "fixtures" ? "active-tab" : ""}`}
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
              class={`mr-1 md:mr-4 ${activeTab === "points" ? "active-tab" : ""}`}
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
       -->
  {/if}
</Layout>

<style>
  .w-v {
    width: 20px;
  }
</style>
