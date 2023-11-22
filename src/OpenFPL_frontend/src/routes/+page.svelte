<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "./Layout.svelte";
  import { SystemService } from "$lib/services/SystemService";
  import { FixtureService } from "$lib/services/FixtureService";
  import { TeamService } from "$lib/services/TeamService";
  import { LeaderboardService } from "$lib/services/LeaderboardService";
  import { ManagerService } from "$lib/services/ManagerService";
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponents from "$lib/components/gameweek-points.svelte";
  import LeaderboardsComponent from "$lib/components/leaderboards.svelte";
  import LeagueTableComponent from "$lib/components/league-table.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { formatUnixDateToReadable, formatUnixTimeToTime, getCountdownTime } from "../utils/Helpers";
  import type { Team } from "../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  const systemService = new SystemService();
  const fixtureService = new FixtureService();
  const teamService = new TeamService();
  const leaderboardService = new LeaderboardService();
  const managerService = new ManagerService();

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
  let gwLeaderUsername = "-";
  let gwLeaderPoints = 0;
  let nextFixtureHomeTeam: Team | undefined = undefined;
  let nextFixtureAwayTeam: Team | undefined = undefined;

  let progress = 0;
  let isLoading = true;
  let isLoggedIn = false;

  onMount(async () => {
    isLoading = true;

    try {
      await systemService.updateSystemStateData();
      await fixtureService.updateFixturesData();
      await teamService.updateTeamsData();
      await leaderboardService.updateWeeklyLeaderboardData();
      await leaderboardService.updateMonthlyLeaderboardData();
      await leaderboardService.updateSeasonLeaderboardData();
      
      managerCount = await managerService.getTotalManagers();

      let systemState = await systemService.getSystemState();
      activeGameweek = systemState?.activeGameweek ?? activeGameweek;
      activeSeason = systemState?.activeSeason.name ?? activeSeason;
      focusGameweek = systemState?.focusGameweek ?? activeGameweek;

      incrementProgress(40);
      await new Promise(resolve => setTimeout(resolve, 1000));
      let nextFixture = await fixtureService.getNextFixture();
      nextFixtureHomeTeam = await teamService.getTeamById(
        nextFixture.homeTeamId
      );
      nextFixtureAwayTeam = await teamService.getTeamById(
        nextFixture.awayTeamId
      );
      nextFixtureDate = formatUnixDateToReadable(Number(nextFixture.kickOff));
      nextFixtureTime = formatUnixTimeToTime(Number(nextFixture.kickOff));

      let countdownTime = getCountdownTime(Number(nextFixture.kickOff));
      countdownDays = countdownTime.days.toString();
      countdownHours = countdownTime.hours.toString();
      countdownMinutes = countdownTime.minutes.toString();

      incrementProgress(80);
      await new Promise(resolve => setTimeout(resolve, 1000));
      let leadingWeeklyTeam = await leaderboardService.getLeadingWeeklyTeam();
      gwLeaderUsername = leadingWeeklyTeam.username;
      gwLeaderPoints = leadingWeeklyTeam.points;

      incrementProgress(100);
      await new Promise(resolve => setTimeout(resolve, 1000));  
      isLoading = false;
    } catch (error) {
      console.error("Error fetching homepage data:", error);
      isLoading = false;
    }
  });

  function incrementProgress(newProgress: number) {
    const step = 1;
    const delay = 25;

    function stepProgress() {
      if (progress < newProgress) {
        progress += step;
        setTimeout(stepProgress, delay);
      }
    }

    stepProgress();
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>
  {#if isLoading}
    <LoadingIcon {progress} />
  {:else}
    <div class="m-4">
      <div class="flex flex-col md:flex-row">
        <div
          class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Gameweek</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
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
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
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
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              0
            </p>
            <p class="text-gray-300 text-xs">$FPL</p>
          </div>
        </div>
        <div
          class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xs">Next Game:</p>
            <div class="flex justify-center mb-2 mt-2">
              <div class="flex justify-center items-center">
                <div class="w-10 ml-4 mr-4">
                  <a
                    href={`/club/${
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
                    href={`/club/${
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
                    href={`/club/${
                      nextFixtureHomeTeam ? nextFixtureHomeTeam.id : -1
                    }`}
                    >{nextFixtureHomeTeam
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
                    href={`/club/${
                      nextFixtureAwayTeam ? nextFixtureAwayTeam.id : -1
                    }`}
                    >{nextFixtureAwayTeam
                      ? nextFixtureAwayTeam.abbreviatedName
                      : ""}</a
                  >
                </p>
              </div>
            </div>
          </div>
          <div
            class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />

          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xs mt-4 md:mt-0">Kick Off:</p>
            <div class="flex">
              <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                {countdownDays}<span class="text-gray-300 text-xs ml-1">d</span>
                : {countdownHours}<span class="text-gray-300 text-xs ml-1"
                  >h</span
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
            class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs mt-4 md:mt-0">
              GW {focusGameweek} High Score
            </p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {gwLeaderUsername}
            </p>
            <p class="text-gray-300 text-xs">{gwLeaderPoints} points</p>
          </div>
        </div>
      </div>
    </div>

    <div class="m-4">
      <div class="bg-panel rounded-md m-4">
        <ul class="flex bg-light-gray px-4 pt-2">
          <li
            class={`mr-4 text-xs md:text-lg ${
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
              class={`mr-4 text-xs md:text-lg ${
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
            class={`mr-4 text-xs md:text-lg ${
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
            class={`mr-4 text-xs md:text-lg ${
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
