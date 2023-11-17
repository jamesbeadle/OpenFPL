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
  
  let activeGameweek = -1;
  let activeSeason = '-';
  
  let countdownDays = '00';
  let countdownHours = '00';
  let countdownMinutes = '00';
  let nextFixtureDate = '-';
  let nextFixtureTime = '-';
  let nextFixtureHomeTeam: Team | undefined = undefined;
  let nextFixtureAwayTeam: Team | undefined = undefined;
  const formations = ['3-4-3', '3-5-2', '4-3-3', '4-4-2', '4-5-1', '5-4-1', '5-3-2'];
  let selectedFormation = '4-4-2';
  $: gridSetup = getGridSetup(selectedFormation);

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

  function getGridSetup(formation: string): number[][] {
    const formationSplits = formation.split('-').map(Number);
    const setups = [[1], ...formationSplits.map(s => Array(s).fill(0).map((_, i) => i + 1))];
    return setups;
  }
  
</script>

<style>
  .bg-panel {
    background-color: rgba(36, 37, 41, 0.90);
  }

  .inactive-btn{  
    background-color: black;
    color: white;
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


      <div class="flex flex-col md:flex-row">
        <div class="flex flex-col md:flex-row justify-between items-center text-white m-4 bg-panel p-4 rounded-md w-full">
          <div class="flex flex-row justify-between md:justify-start flex-grow mb-2 md:mb-0 ml-4">
            <button class="btn fpl-button px-4 py-2 rounded-l-md font-bold text-md min-w-[125px] my-4">
              Pitch View
            </button>
            <button class="btn inactive-btn px-4 py-2 rounded-r-md font-bold text-md min-w-[125px] my-4">
              List View
            </button>
          </div>
        
          <div class="text-center md:text-left w-full mb-2 md:mb-0 md:ml-8">
            
            <span class="text-sm md:text-lg">Formation: 
              <select
                class="p-2 fpl-dropdown text-sm md:text-lg text-center"
                bind:value={selectedFormation}>
                {#each formations as formation}
                  <option value="{formation}">{formation}</option>
                {/each}
              </select>
            </span>
          </div>
        
          <div class="flex flex-row justify-between md:justify-end w-full gap-4 mr-4">
            <button class="btn px-4 py-2 rounded bg-gray-500 text-white min-w-[125px]">
              Auto Fill
            </button>
            <button class="btn px-4 py-2 rounded bg-gray-500 text-white min-w-[125px]">
              Save Team
            </button>
          </div>
        </div>
      </div>
      


      <div class="flex flex-col md:flex-row">
        <div class="relative w-full md:w-1/2">
          <img src='pitch.png' alt="pitch" class="w-full" />
          <div class="absolute top-0 left-0 right-0 bottom-0">
            {#each gridSetup as row, rowIndex}
              <div class={`flex justify-around w-full h-1/4`}>
                {#each row as _, colIndex (colIndex)}
                  <div class={`bg-red-500/75 text-white p-1 text-center flex-1 m-4`}>
                    Column {colIndex + 1}
                  </div>
                {/each}
              </div>
            {/each}
          </div>
        </div>
        <div class="flex w-100 md:w-1/2">
       
        </div>
      </div>

    </div>
  {/if}
</Layout>
