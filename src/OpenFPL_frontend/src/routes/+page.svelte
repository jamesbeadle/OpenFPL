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
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

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
    <LoadingIcon />
  {:else}
    <div class="m-4 xs:m-6 sm:m-8 lg:m-10">
      <div class="flex flex-col lg:flex-row lg:space-x-2">
        <div
          class="flex justify-start items-center text-white rounded-md bg-panel
          space-x-2 sm:space-x-3 md:space-x-4 flex-grow
          p-2 xs:p-3 sm:p-4
          mb-5 xs:mb-7 sm:mb-8 lg:mb-0"
        >
          <div class="flex-grow">
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              Gameweek
            </p>
            <p
              class="text-xs xs:text-sm sm:text-2xl md:text-3xl lg:text-lg mt-2 mb-2 font-bold"
            >
              {$systemStore?.activeGameweek}
            </p>
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              {$systemStore?.activeSeason.name}
            </p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              Managers
            </p>
            <p
              class="text-xs xs:text-sm sm:text-2xl md:text-3xl lg:text-lg mt-2 mb-2 font-bold"
            >
              {managerCount * 10000000}
            </p>
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">Total</p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p
              class="text-gray-300 hidden md:block text-xxs xs:text-sm sm:text-base"
            >
              Weekly Prize Pool
            </p>
            <p class="text-gray-300 md:hidden text-xxs xs:text-sm sm:text-base">
              Weekly
            </p>
            <p
              class="text-xs xs:text-sm sm:text-2xl md:text-3xl lg:text-lg mt-2 mb-2 font-bold"
            >
              5000
            </p>
            <p class="text-gray-300 text-xxs text-xxs xs:text-sm sm:text-base">
              $FPL
            </p>
          </div>
        </div>
        <div
          class="flex flex-col lg:flex-row justify-start lg:items-center text-white space-x-0 lg:space-x-4 flex-grow bg-panel p-4 rounded-md"
        >
          <div class="flex-grow mb-3 md:mb-4 lg:mb-0">
            <p
              class="text-gray-300 text-xxs xs:text-sm sm:text-base w-full text-center lg:w-auto lg:text-left"
            >
              Next Game
            </p>
            <div class="flex justify-center">
              <div
                class="flex justify-center items-center mb-2 text-xxs xs:text-sm sm:text-base"
              >
                <div class="ml-4 lg:ml-1 xl:ml-4 mr-4 lg:mr-1 xl:mr-4 flex">
                  <a
                    class="flex flex-col items-center justify-center mt-6 lg:mt-3 xl:mt-6"
                    href={`/club?id=${
                      nextFixtureHomeTeam ? nextFixtureHomeTeam.id : -1
                    }`}
                  >
                    <BadgeIcon
                      className="h-8 lg:h-7 xl:h-8 mb-4 lg:mb-2 xl:mb-4"
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
                    <span>
                      {nextFixtureHomeTeam
                        ? nextFixtureHomeTeam.abbreviatedName
                        : ""}
                    </span>
                  </a>
                </div>
                <div
                  class="w-v ml-1 mr-1 flex justify-center mt-6 lg:mt-2 xl:mt-6"
                >
                  <p class="text-xs mt-2 mb-2 font-bold">v</p>
                </div>
                <div class="ml-4 lg:ml-1 xl:ml-4 mr-4 lg:mr-1 xl:mr-4 flex">
                  <a
                    class="flex flex-col items-center justify-center mt-6 lg:mt-3 xl:mt-6"
                    href={`/club?id=${
                      nextFixtureAwayTeam ? nextFixtureAwayTeam.id : -1
                    }`}
                  >
                    <BadgeIcon
                      className="h-8 lg:h-7 xl:h-8 mb-4 lg:mb-2 xl:mb-4"
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
                    <span>
                      {nextFixtureAwayTeam
                        ? nextFixtureAwayTeam.abbreviatedName
                        : ""}
                    </span>
                  </a>
                </div>
              </div>
            </div>
          </div>
          <div
            class="h-px bg-gray-400 w-full lg:w-px lg:h-full lg:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />

          <div class="flex-grow mb-4 lg:mb-0">
            <p
              class="text-gray-300 text-xxs xs:text-sm sm:text-base mt-4 lg:mt-0"
            >
              Kick Off
            </p>
            <div class="flex">
              <p
                class="text-xs xs:text-sm sm:text-2xl md:text-3xl lg:text-lg mt-2 mb-2 font-bold"
              >
                {countdownDays}<span class="text-gray-300 text-xs ml-1">d</span>
                : {countdownHours}<span class="text-gray-300 text-xs ml-1"
                  >h</span
                >
                : {countdownMinutes}<span class="text-gray-300 text-xs ml-1"
                  >m</span
                >
              </p>
            </div>
            <p
              class="lg:hidden xl:flex text-gray-300 text-xxs xs:text-sm sm:text-base"
            >
              {nextFixtureDate} | {nextFixtureTime}
            </p>
            <p
              class="hidden lg:flex xl:hidden text-gray-300 text-xxs xs:text-sm sm:text-base"
            >
              {nextFixtureDateSmall}
            </p>
          </div>
          <div
            class="h-px bg-gray-400 w-full lg:w-px lg:h-full lg:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />
          <div class="flex-grow">
            <p
              class="text-gray-300 text-xxs xs:text-sm sm:text-base mt-4 lg:mt-0"
            >
              GW {$systemStore?.focusGameweek} High Score
            </p>
            <p
              class="text-xs xs:text-sm sm:text-2xl md:text-3xl lg:text-lg mt-2 mb-2 font-bold max-w-[200px] truncate"
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
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
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

    <div class="mx-4 xs:mx-6 sm:mx-8 lg:mx-10 mb-4 xs:mb-6 sm:mb-8">
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
    </div>
  {/if}
</Layout>

<style>
  .w-v {
    width: 20px;
  }
</style>
