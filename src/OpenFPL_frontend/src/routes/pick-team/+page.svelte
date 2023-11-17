<script lang="ts">

  import { onMount } from "svelte";
  import { SystemService } from "$lib/services/SystemService";
  import { TeamService } from "$lib/services/TeamService";
  import { ManagerService } from "$lib/services/ManagerService";
  import { FixtureService } from "$lib/services/FixtureService";
  import Layout from "../Layout.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { formatUnixDateToReadable, formatUnixTimeToTime, getCountdownTime } from '../../utils/Helpers';
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  const systemService = new SystemService();
  const teamService = new TeamService();
  const fixtureService = new FixtureService();
  const managerService = new ManagerService();
  
  let activeTab: string = "fixtures";
  let activeGameweek = -1;
  let activeSeason = '-';
  
  let countdownDays = '00';
  let countdownHours = '00';
  let countdownMinutes = '00';
  let nextFixtureDate = '-';
  let nextFixtureTime = '-';
  let nextFixtureHomeTeam: Team | undefined = undefined;
  let nextFixtureAwayTeam: Team | undefined = undefined;
  
  let progress = 0;
  let isLoading = true;

  onMount(async () => {
    isLoading = true;
    try {
      progress = 0;
  
      progress = 20;
      let systemState = await systemService.getSystemState(localStorage.getItem('system_state_hash') ?? '');
      activeGameweek = systemState.activeGameweek;
      activeSeason = systemState.activeSeason.name;
      
      progress = 40;
      let nextFixture = await fixtureService.getNextFixture();
      nextFixtureHomeTeam = await teamService.getTeamById(nextFixture.homeTeamId);
      nextFixtureAwayTeam = await teamService.getTeamById(nextFixture.awayTeamId);
      nextFixtureDate = formatUnixDateToReadable(Number(nextFixture.kickOff));
      nextFixtureTime = formatUnixTimeToTime(Number(nextFixture.kickOff));

      progress = 60;
      let countdownTime = getCountdownTime(Number(nextFixture.kickOff));
      countdownDays = countdownTime.days.toString();
      countdownHours = countdownTime.hours.toString();
      countdownMinutes = countdownTime.minutes.toString();

      progress = 100;
      isLoading = false;
    } catch (error) {
      console.error("Error fetching homepage data:", error);
      isLoading = false;
    }
  }); 
  
  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
  
</script>

<style>
  .bg-panel {
    background-color: rgba(36, 37, 41, 0.90);
  }

</style>

<Layout>
  {#if isLoading}
    <LoadingIcon {progress} />
  {:else}
    <div class="m-4">
      <div class="flex flex-col md:flex-row">
        <div class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xs">Gameweek</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">{activeGameweek}</p>
            <p class="text-gray-300 text-xs">{activeSeason}</p>
          </div>
          
          <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;" />

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
            <p class="text-gray-300 text-xs">{nextFixtureDate} | {nextFixtureTime}</p>
          </div>

          <div class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch" style="min-height: 2px; min-width: 2px;" />
          
          <div class="flex-grow mb-4 md:mb-0 mt-4 md:mt-0">
            <p class="text-gray-300 text-xs">Players</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">11/11</p>
            <p class="text-gray-300 text-xs">Selected</p>
          </div>

        </div>

        <div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Team Value</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">£299.5m</p>
            <p class="text-gray-300 text-xs">GBP</p>
          </div>
          <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;" />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Bank Balance</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">£0.5m</p>
            <p class="text-gray-300 text-xs">GBP</p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Transfers</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">3</p>
            <p class="text-gray-300 text-xs">Available</p>
          </div>
        </div>
      </div>


      <div class="flex">
        <div class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
          <div class="flex flex-grow">
            <div class="flex flex-col md:flex-row justify-between md:items-center text-white bg-panel p-4 rounded-md w-full">
              <div class="flex gap-2 items-center">
                <button class="btn bg-green-500 text-white px-4 py-2 rounded">
                  Pitch View
                </button>
                <button class="btn bg-gray-400 text-white px-4 py-2 rounded">
                  List View
                </button>
                <span class="text-sm md:text-lg md:ml-4">Formation: 3-5-2</span>
              </div>
              <div class="flex gap-2">
                <button class="btn bg-blue-500 text-white px-4 py-2 rounded">
                  Auto Fill
                </button>
                <button class="btn bg-purple-500 text-white px-4 py-2 rounded">
                  Save Team
                </button>
              </div>
            </div>
          </div>
          
        </div>
      </div>


      <div class="flex">
        <div class="flex w-1/2">
   a     
        </div>
        <div class="flex w-1/2">
    b    
        </div>
      </div>

    </div>
  {/if}
</Layout>
