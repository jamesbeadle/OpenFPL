<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "./Layout.svelte";
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponents from "$lib/components/gameweek-points.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { ManagerService } from "$lib/services/ManagerService";
  import type { Team } from "../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  let activeTab: string = "fixtures";
  let activeGameweek = -1;
  let activeSeason = '-';
  let managerCount = -1;
  let countdownDays = '00';
  let countdownHours = '00';
  let countdownMinutes = '00';
  let nextFixtureDate = '-';
  let focusGameweek = -1;
  let gwLeaderUsername = '-';
  let gwLeaderPoints = 0;
  let nextFixtureHomeTeam: Team = {
    id: 0,
    name: '',
    primaryColourHex: '#FFFFFF',
    secondaryColourHex: '#FFFFFF',
    thirdColourHex: '#FFFFFF',
    friendlyName: '',
    abbreviatedName: '-',
    shirtType: 0
  };
  let nextFixtureAwayTeam: Team = {
    id: 0,
    name: '',
    primaryColourHex: '#FFFFFF',
    secondaryColourHex: '#FFFFFF',
    thirdColourHex: '#FFFFFF',
    friendlyName: '',
    abbreviatedName: '-',
    shirtType: 0
  };

  let isLoading = true;
  const managerService = new ManagerService();

  onMount(async () => {
    isLoading = true;
    try {
      managerCount = await managerService.getTotalManagers();
      isLoading = false;
    } catch (error) {
      console.error("Failed to fetch manager count:", error);
      isLoading = false;
    }
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
  
</script>

<Layout>
  <div class="p-1">
    <div class="flex flex-col md:flex-row">
      <div
        class="flex justify-start items-center text-white space-x-4 flex-grow m-1 bg-panel p-4 rounded-md border border-gray-500"
      >
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Gameweek</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">{activeGameweek}</p>
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
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">0</p>
          <p class="text-gray-300 text-xs">$FPL</p>
        </div>
      </div>
      <div
        class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-1 bg-panel p-4 rounded-md border border-gray-500"
      >
        <div class="flex-grow mb-4 md:mb-0">
          <p class="text-gray-300 text-xs">Next Game:</p>
          <div class="flex justify-center mb-2 mt-2">
            <div class="flex justify-center items-center">
              <div class="w-10 ml-4 mr-4">
                <BadgeIcon
                  primaryColour="{nextFixtureHomeTeam.primaryColourHex}"
                  secondaryColour="{nextFixtureHomeTeam.secondaryColourHex}"
                  thirdColour="{nextFixtureHomeTeam.thirdColourHex}"
                />
              </div>
              <div class="w-v ml-1 mr-1 flex justify-center">
                <p class="text-xs mt-2 mb-2 font-bold">v</p>
              </div>
              <div class="w-10 ml-4">
                <BadgeIcon
                  primaryColour="{nextFixtureAwayTeam.primaryColourHex}"
                  secondaryColour="{nextFixtureAwayTeam.secondaryColourHex}"
                  thirdColour="{nextFixtureAwayTeam.thirdColourHex}"
                />
              </div>
            </div>
          </div>
          <div class="flex justify-center">
            <div class="w-10 ml-4 mr-4">
              <p class="text-gray-300 text-xs text-center">{nextFixtureHomeTeam.abbreviatedName}</p>
            </div>
            <div class="w-v ml-1 mr-1" />
            <div class="w-10 ml-4">
              <p class="text-gray-300 text-xs text-center">{nextFixtureHomeTeam.abbreviatedName}</p>
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
              {countdownDays}<span class="text-gray-300 text-xs ml-1">d</span> : {countdownHours}<span
                class="text-gray-300 text-xs ml-1">h</span
              >
              : {countdownMinutes}<span class="text-gray-300 text-xs ml-1">m</span>
            </p>
          </div>
          <p class="text-gray-300 text-xs">{nextFixtureDate}</p>
        </div>
        <div
          class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
          style="min-height: 2px; min-width: 2px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs mt-4 md:mt-0">GW {focusGameweek} High Score</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
            {gwLeaderUsername}
          </p>
          <p class="text-gray-300 text-xs">{gwLeaderPoints} points</p>
        </div>
      </div>
    </div>
  </div>

  <div class="bg-panel p-4 m-1 bg-panel p-4 rounded-md border border-gray-500">
    <ul class="flex">
      <li class="mr-4">
        <button
          class={`p-2 ${
            activeTab === "fixtures" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("fixtures")}
        >
          Fixtures
        </button>
      </li>
      <li class="mr-4">
        <button
          class={`p-2 ${
            activeTab === "points" ? "text-white" : "text-gray-400"
          }`}
          on:click={() => setActiveTab("points")}
        >
          Gameweek Points
        </button>
      </li>
    </ul>

    {#if activeTab === "fixtures"}
      <FixturesComponent />
    {:else if activeTab === "points"}
      <GamweekPointsComponents />
    {/if}
  </div>
</Layout>

<style>
  .bg-panel {
    background-color: rgba(46, 50, 58, 0.9);
  }

  .circle-badge-container {
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .circle-badge-icon {
    align-self: center;
  }

  .w-v {
    width: 20px;
  }
</style>
