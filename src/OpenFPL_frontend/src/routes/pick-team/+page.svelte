<script lang="ts">
  import { onMount } from "svelte";
  import { SystemService } from "$lib/services/SystemService";
  import { TeamService } from "$lib/services/TeamService";
  import { ManagerService } from "$lib/services/ManagerService";
  import { FixtureService } from "$lib/services/FixtureService";
  import Layout from "../Layout.svelte";
  import type {
    FantasyTeam,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import {
    formatUnixDateToReadable,
    formatUnixTimeToTime,
    getCountdownTime,
  } from "../../utils/Helpers";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import OpenChatIcon from "$lib/icons/OpenChatIcon.svelte";
  import SimpleFixtures from "$lib/components/simple-fixtures.svelte";
  import AddPlayerIcon from "$lib/icons/AddPlayerIcon.svelte";
  import AddIcon from "$lib/icons/AddIcon.svelte";
  import BonusPanel from "$lib/components/bonus-panel.svelte";
  import AddPlayerModal from "$lib/components/add-player-modal.svelte";

  const systemService = new SystemService();
  const teamService = new TeamService();
  const fixtureService = new FixtureService();
  const managerService = new ManagerService();

  let activeGameweek = -1;
  let activeSeason = "-";
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  let nextFixtureHomeTeam: Team | undefined = undefined;
  let nextFixtureAwayTeam: Team | undefined = undefined;
  const formations = [
    "3-4-3",
    "3-5-2",
    "4-3-3",
    "4-4-2",
    "4-5-1",
    "5-4-1",
    "5-3-2",
  ];
  let selectedFormation = "4-4-2";
  let progress = 0;
  let isLoading = true;
  let pitchView = true;
  let showAddPlayer = false;
  let fantasyTeam: FantasyTeam;
  let selectedPosition = -1;
  $: gridSetup = getGridSetup(selectedFormation);

  onMount(async () => {
    await systemService.updateSystemStateData();
    await fixtureService.updateFixturesData();
    await teamService.updateTeamsData();

    isLoading = true;
    try {
      progress = 20;

      let systemState = await systemService.getSystemState();
      activeGameweek = systemState?.activeGameweek ?? activeGameweek;
      activeSeason = systemState?.activeSeason.name ?? activeSeason;

      progress = 40;

      let nextFixture = await fixtureService.getNextFixture();

      nextFixtureHomeTeam = await teamService.getTeamById(
        nextFixture.homeTeamId
      );

      nextFixtureAwayTeam = await teamService.getTeamById(
        nextFixture.awayTeamId
      );

      fantasyTeam = await managerService.getFantasyTeam();

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
    const formationSplits = formation.split("-").map(Number);
    const setups = [
      [1],
      ...formationSplits.map((s) =>
        Array(s)
          .fill(0)
          .map((_, i) => i + 1)
      ),
    ];
    return setups;
  }

  function showPitchView() {
    pitchView = true;
  }

  function showListView() {
    pitchView = false;
  }

  function loadAddPlayer(row: number) {
    selectedPosition = row;
    showAddPlayer = true;
  }

  function closeAddPlayerModal() {
    showAddPlayer = false;
  }
</script>

<Layout>
  {#if isLoading}
    <LoadingIcon {progress} />
  {:else}
    <AddPlayerModal filterPosition={selectedPosition} {showAddPlayer} {closeAddPlayerModal} {fantasyTeam} />
    <div class="m-4">
      <div class="flex flex-col md:flex-row">
        <div
          class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xs">Gameweek</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {activeGameweek}
            </p>
            <p class="text-gray-300 text-xs">{activeSeason}</p>
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

          <div class="flex-grow mb-4 md:mb-0 mt-4 md:mt-0">
            <p class="text-gray-300 text-xs">Players</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              11/11
            </p>
            <p class="text-gray-300 text-xs">Selected</p>
          </div>
        </div>

        <div
          class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Team Value</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              £299.5m
            </p>
            <p class="text-gray-300 text-xs">GBP</p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Bank Balance</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              £0.5m
            </p>
            <p class="text-gray-300 text-xs">GBP</p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Transfers</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              3
            </p>
            <p class="text-gray-300 text-xs">Available</p>
          </div>
        </div>
      </div>

      <div class="flex flex-col md:flex-row">
        <div
          class="flex flex-col md:flex-row justify-between items-center text-white m-4 bg-panel p-4 rounded-md md:w-full"
        >
          <div
            class="flex flex-row justify-between md:justify-start flex-grow mb-2 md:mb-0 ml-4 order-3 md:order-1"
          >
            <button
              class={`btn ${
                pitchView ? `fpl-button` : `inactive-btn`
              } px-4 py-2 rounded-l-md font-bold text-md min-w-[125px] my-4`}
              on:click={showPitchView}
            >
              Pitch View
            </button>
            <button
              class={`btn ${
                !pitchView ? `fpl-button` : `inactive-btn`
              } px-4 py-2 rounded-r-md font-bold text-md min-w-[125px] my-4`}
              on:click={showListView}
            >
              List View
            </button>
          </div>

          <div
            class="text-center md:text-left w-full mt-4 md:mt-0 md:ml-8 order-2"
          >
            <span class="text-lg"
              >Formation:
              <select
                class="p-2 fpl-dropdown text-lg text-center"
                bind:value={selectedFormation}
              >
                {#each formations as formation}
                  <option value={formation}>{formation}</option>
                {/each}
              </select>
            </span>
          </div>

          <div
            class="flex flex-col md:flex-row w-full md:justify-end gap-4 mr-0 md:mr-4 order-1 md:order-3"
          >
            <button
              class="btn w-full md:w-auto px-4 py-2 rounded bg-gray-500 text-white min-w-[125px]"
            >
              Auto Fill
            </button>
            <button
              class="btn w-full md:w-auto px-4 py-2 rounded bg-gray-500 text-white min-w-[125px]"
            >
              Save Team
            </button>
          </div>
        </div>
      </div>

      <div class="flex flex-col md:flex-row">
        {#if pitchView}
          <div class="relative w-full md:w-1/2 mt-4">
            <img src="pitch.png" alt="pitch" class="w-full" />
            <div class="absolute top-0 left-0 right-0 bottom-0">
              <div class={`flex justify-around w-full h-auto`}>
                <div class="relative inline-block">
                  <img
                    class="h-6 md:h-12 m-0 md:m-1"
                    src="board.png"
                    alt="OpenChat"
                  />
                  <div class="absolute top-0 left-0 w-full h-full">
                    <a
                      class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
                      target="_blank"
                      href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
                    >
                      <OpenChatIcon className="h-4 md:h-6 mr-1 md:mr-2" />
                      <span class="text-white text-xs md:text-xl mr-4 oc-logo"
                        >OpenChat</span
                      >
                    </a>
                  </div>
                </div>
                <div class="relative inline-block">
                  <img
                    class="h-6 md:h-12 m-0 md:m-1"
                    src="board.png"
                    alt="OpenChat"
                  />
                  <div class="absolute top-0 left-0 w-full h-full">
                    <a
                      class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
                      target="_blank"
                      href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
                    >
                      <OpenChatIcon className="h-4 md:h-6 mr-1 md:mr-2" />
                      <span class="text-white text-xs md:text-xl mr-4 oc-logo"
                        >OpenChat</span
                      >
                    </a>
                  </div>
                </div>
              </div>
              {#each gridSetup as row, rowIndex}
                <div class={`flex justify-around items-center w-full`}>
                  {#each row as _, colIndex (colIndex)}
                    <div
                      class={`flex flex-col justify-center items-center flex-1`}
                    >
                      <button on:click={() => loadAddPlayer(rowIndex)}>
                        <AddPlayerIcon
                          className="h-12 md:h-16 mt-5 md:mt-12 mb-5 md:mb-16"
                        />
                      </button>
                    </div>
                  {/each}
                </div>
              {/each}
            </div>
          </div>
        {:else}
          <div class="bg-panel rounded-md m-4 flex-1">
            <div class="container-fluid">
              {#each gridSetup as row, rowIndex}
                {#if rowIndex == 0}
                  <div
                    class="flex items-center justify-between py-2 bg-light-gray px-4"
                  >
                    <div class="w-1/3">Goalkeeper</div>
                    <div class="w-1/6">(c)</div>
                    <div class="w-1/3">Team</div>
                    <div class="w-1/6">Value</div>
                    <div class="w-1/6">&nbsp;</div>
                  </div>
                {/if}
                {#if rowIndex == 1}
                  <div
                    class="flex items-center justify-between py-2 bg-light-gray px-4"
                  >
                    <div class="w-1/3">Defenders</div>
                    <div class="w-1/6">(c)</div>
                    <div class="w-1/3">Team</div>
                    <div class="w-1/6">Value</div>
                    <div class="w-1/6">&nbsp;</div>
                  </div>
                {/if}
                {#if rowIndex == 2}
                  <div
                    class="flex items-center justify-between py-2 bg-light-gray px-4"
                  >
                    <div class="w-1/3">Midfielders</div>
                    <div class="w-1/6">(c)</div>
                    <div class="w-1/3">Team</div>
                    <div class="w-1/6">Value</div>
                    <div class="w-1/6">&nbsp;</div>
                  </div>
                {/if}
                {#if rowIndex == 3}
                  <div
                    class="flex items-center justify-between py-2 bg-light-gray px-4"
                  >
                    <div class="w-1/3">Forwards</div>
                    <div class="w-1/6">(c)</div>
                    <div class="w-1/3">Team</div>
                    <div class="w-1/6">Value</div>
                    <div class="w-1/6">&nbsp;</div>
                  </div>
                {/if}
                {#each row as _, colIndex (colIndex)}
                  <div class="flex items-center justify-between py-2 px-4">
                    <div class="w-1/3">Select</div>
                    <div class="w-1/6">-</div>
                    <div class="w-1/3">-</div>
                    <div class="w-1/6">-</div>
                    <div class="w-1/6 flex items-center">
                      <button
                        on:click={() => loadAddPlayer(rowIndex)}
                        class="text-xl rounded fpl-button console.log(row);tton flex items-center"
                        ><AddIcon className="w-6 h-6 p-2" /></button
                      >
                    </div>
                  </div>
                {/each}
              {/each}
            </div>
          </div>
        {/if}
        <div class="flex w-100 md:w-1/2">
          <SimpleFixtures />
        </div>
      </div>

      <BonusPanel />
    </div>
  {/if}
</Layout>

<style>
  .inactive-btn {
    background-color: black;
    color: white;
  }
</style>
