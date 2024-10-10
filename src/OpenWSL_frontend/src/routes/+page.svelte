<script lang="ts">
  import { onMount } from "svelte";
  import { authStore } from "$lib/stores/auth.store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { clubStore } from "$lib/stores/club-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { managerStore } from "$lib/stores/manager-store";
  import {
    formatUnixDateToReadable,
    formatUnixDateToSmallReadable,
    formatUnixTimeToTime,
    getCountdownTime,
  } from "../lib/utils/helpers";
  import type {
    LeaderboardEntry,
    ClubDTO,
  } from "../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import Layout from "./Layout.svelte";
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponent from "$lib/components/gameweek-points.svelte";
  import LeaderboardsComponent from "$lib/components/leaderboards.svelte";
  import LeagueTableComponent from "$lib/components/league-table.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";
  import RelativeSpinner from "$lib/components/relative-spinner.svelte";
    import { seasonStore } from "$lib/stores/season-store";
    import { storeManager } from "$lib/managers/store-manager";

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
  let section1Loading = true;
  let section2Loading = true;
  let section3Loading = true;
  let seasonName = "";

  onMount(async () => {
    try {


      await storeManager.syncStores();

      authStore.subscribe((store) => {
        isLoggedIn = store.identity !== null && store.identity !== undefined;
      });
      
      seasonName = await seasonStore.getSeasonName($systemStore?.pickTeamSeasonId ?? 0) ?? "";
      
      loadSection1();
      loadSection2();
      loadSection3();
      
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

  async function loadSection1(): Promise<void> {
    try {
      managerCount = await managerStore.getTotalManagers();
    } catch (error) {
      console.error("Error loading section 1:", error);
    } finally {
      section1Loading = false;
    }
  }

  async function loadSection2(): Promise<void> {
    try {
      let nextFixture = await fixtureStore.getNextFixture();
      let nextFixtureId = nextFixture ? nextFixture.awayClubId : 0;

      if(nextFixtureId > 0){

        nextFixtureHomeTeam = $clubStore.find(x => x.id == nextFixture?.homeClubId);
        nextFixtureAwayTeam = $clubStore.find(x => x.id == nextFixture?.awayClubId);
        
        nextFixtureDate = formatUnixDateToReadable(
          nextFixture ? nextFixture.kickOff : 0n
        );
        nextFixtureDateSmall = formatUnixDateToSmallReadable(
          nextFixture ? nextFixture.kickOff : 0n
        );
        nextFixtureTime = formatUnixTimeToTime(
          nextFixture ? nextFixture.kickOff : 0n
        );

        let countdownTime = getCountdownTime(
          nextFixture ? nextFixture.kickOff : 0n
        );
        countdownDays = countdownTime.days.toString();
        countdownHours = countdownTime.hours.toString();
        countdownMinutes = countdownTime.minutes.toString();

      }

      /* //TODO
      weeklyLeader = await weeklyLeaderboardStore.getLeadingWeeklyTeam(
        $systemStore?.calculationSeasonId ?? 1,
        $systemStore?.calculationGameweek ?? 1
      );

      await weeklyLeaderboardStore.sync(
        $systemStore?.calculationSeasonId ?? 1,
        $systemStore?.calculationGameweek ?? 1
      );
      */
      
    } catch (error) {
      console.error("Error loading section 2:", error);
    } finally {
      section2Loading = false;
    }
  }

  async function loadSection3(): Promise<void> {
    section3Loading = false;
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>
  <div class="flex page-header-wrapper">
    {#if !section1Loading}
      <div class="content-panel lg:w-1/2">
        <div class="flex-grow">
          <p class="content-panel-header">Gameweek</p>
          <p class="content-panel-stat">
            {$systemStore?.pickTeamGameweek}
          </p>
          <p class="content-panel-header">
            {seasonName}
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
    {:else}
      <div class="flex items-center justify-center content-panel lg:w-1/2">
        <RelativeSpinner />
      </div>
    {/if}

    {#if !section2Loading}
      <div class="flex lg:hidden">
        <div class="content-panel">
          <div class="flex flex-col mt-2 xs:mr-2">
            <p class="content-panel-header">Next Game</p>

            <div class="flex items-center justify-start mb-2 ml-1">
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
              <div class="flex justify-center ml-1 mr-1 w-v">
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
      
      <div class="hidden w-1/2 lg:flex">
        <div class="content-panel">
          <div class="flex-grow">
            <p class="content-panel-header">Next Game</p>
            <div class="flex flex-row">
              <div class="flex justify-center">
                <a
                  class="flex flex-col items-center mt-5 justify-left"
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
                class="flex justify-center mt-6 ml-1 mr-1 w-v lg:mt-2 xl:mt-6"
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
    {:else}
      <div class="flex lg:hidden">
        <div class="flex items-center justify-center content-panel">
          <RelativeSpinner />
        </div>
      </div>
      <div class="hidden w-1/2 lg:flex">
        <div class="flex items-center justify-center content-panel">
          <RelativeSpinner />
        </div>
      </div>
    {/if}
  </div>

  <div class="rounded-md bg-panel">
    <ul
      class="flex px-1 pt-2 mb-4 border-b border-gray-700 bg-light-gray md:px-4 contained-text"
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

    {#if !section3Loading}
      {#if activeTab === "fixtures"}
        <FixturesComponent />
      {:else if activeTab === "points"}
        <GamweekPointsComponent />
      {:else if activeTab === "leaderboards"}
        <LeaderboardsComponent />
      {:else if activeTab === "league-table"}
        <LeagueTableComponent />
      {/if}
    {:else}
      <div class="flex items-center justify-center p-4">
        <RelativeSpinner />
      </div>
    {/if}
  </div>
</Layout>
