<script lang="ts">
    import { onMount } from "svelte";
    import Layout from "../Layout.svelte";
    import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import { SystemService } from "$lib/services/SystemService";
    import { FixtureService } from "$lib/services/FixtureService";
    import { TeamService } from "$lib/services/TeamService";
    import { page } from '$app/stores';
    import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
    import { PlayerService } from "$lib/services/PlayerService";
    import { calculateAgeFromNanoseconds, convertDateToReadable, formatUnixDateToReadable, formatUnixTimeToTime, getCountdownTime, getFlagComponent, getPositionText } from "../../utils/Helpers";
    import type { Fixture, Season, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
    import type { FixtureWithTeams } from "$lib/types/FixtureWithTeams";
    import PlayerGameweekHistory from "$lib/components/player-gameweek-history.svelte";
    
    
    const fixtureService = new FixtureService();
    const teamService = new TeamService();
    const systemService = new SystemService();
    const playersService = new PlayerService();
  
    let selectedGameweek: number = 1;
    let selectedPlayer : PlayerDTO| null = null;
    let fixtures: FixtureWithTeams[] = [];
    let teams: Team[] = [];
    let team: Team | null = null;
    let players: PlayerDTO[] = [];
    let nextFixture: Fixture | null = null;
    let nextFixtureHomeTeam: Team | null = null;
    let nextFixtureAwayTeam: Team | null = null;
    let highestScoringPlayer: PlayerDTO | null = null;
    let countdownDays = "00";
    let countdownHours = "00";
    let countdownMinutes = "00";
    let nextFixtureDate = "-";
    let nextFixtureTime = "-";
    
    let progress = 0;
    let isLoading = true;
    let activeTab: string = "history";
  
    $: id = Number($page.url.searchParams.get('id'));
    onMount(async () => {
      try {
        const fetchedFixtures = await fixtureService.getFixtures();
        const fetchedTeams = await teamService.getTeams();
        const fetchedPlayers = await playersService.getPlayers();
  
        players = fetchedPlayers;
        selectedPlayer = players.find(x => x.id == id) ?? null;
        teams = fetchedTeams;
        team = fetchedTeams.find(x => x.id == selectedPlayer?.teamId) ?? null;
  
        let teamFixtures = fetchedFixtures.filter(x => x.homeTeamId == team?.id || x.awayTeamId == team?.id);
        fixtures = teamFixtures.map((fixture) => ({
          fixture,
          homeTeam: getTeamFromId(fixture.homeTeamId),
          awayTeam: getTeamFromId(fixture.awayTeamId),
        }));

        let systemState = await systemService.getSystemState();

        selectedGameweek = systemState?.activeGameweek ?? selectedGameweek;
        
        nextFixture = teamFixtures.find(x => x.gameweek == selectedGameweek) ?? null;
        nextFixtureHomeTeam = getTeamFromId(nextFixture?.homeTeamId ?? 0) ?? null;
        nextFixtureAwayTeam = getTeamFromId(nextFixture?.awayTeamId ?? 0) ?? null;
        
        nextFixtureDate = formatUnixDateToReadable(Number(nextFixture?.kickOff));
        nextFixtureTime = formatUnixTimeToTime(Number(nextFixture?.kickOff));
        let countdownTime = getCountdownTime(Number(nextFixture?.kickOff));
        
        countdownDays = countdownTime.days.toString();
        countdownHours = countdownTime.hours.toString();
        countdownMinutes = countdownTime.minutes.toString();

        isLoading = false;
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    });
  
    
    let tableData: any[] = [];
    $: if (fixtures.length > 0 && teams.length > 0) {
      tableData = fixtureService.updateTableData(fixtures, teams, selectedGameweek);
    }
  
    function getTeamFromId(teamId: number): Team | undefined {
      return teams.find((team) => team.id === teamId);
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
          <div class="flex-grow flex flex-col items-center">
            <p class="text-gray-300 text-xs">{getPositionText(selectedPlayer?.position ?? -1)}</p>
            <div class="py-2 flex">
              <ShirtIcon
                className="h-10"
                primaryColour={team?.primaryColourHex}
                secondaryColour={team?.secondaryColourHex}
                thirdColour={team?.thirdColourHex}
              />
            </div>
            <p class="text-gray-300 text-xs">Shirt: {selectedPlayer?.shirtNumber}</p>
          </div>
            <div
              class="flex-shrink-0 w-px bg-gray-400 self-stretch"
              style="min-width: 2px; min-height: 50px;"
            />
            <div class="flex-grow">
              <p class="text-gray-300 text-xs">{team?.name}</p>
              <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                {selectedPlayer?.lastName}
              </p>
              <p class="text-gray-300 text-xs flex items-center">                
                <svelte:component class="w-4 h-4 mr-1" this={getFlagComponent(selectedPlayer?.nationality ?? '')} size="100" />{selectedPlayer?.firstName}</p>
            </div>
            <div
              class="flex-shrink-0 w-px bg-gray-400 self-stretch"
              style="min-width: 2px; min-height: 50px;"
            />
            <div class="flex-grow">
              <p class="text-gray-300 text-xs">Value</p>
              <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                £{(Number(selectedPlayer?.value ?? 0) / 4).toFixed(2)}m
              </p>
              <p class="text-gray-300 text-xs">Weekly Change: 0%</p>
            </div>
            <div
                class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
                style="min-height: 2px; min-width: 2px;"
              />
            <div class="flex-grow mb-4 md:mb-0">
                <p class="text-gray-300 text-xs">Age</p>
                <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                    {calculateAgeFromNanoseconds(Number(selectedPlayer?.dateOfBirth ?? 0)) }
                </p>
                <p class="text-gray-300 text-xs">{convertDateToReadable(Number(selectedPlayer?.dateOfBirth ?? 0))}</p>
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

            
          </div>
        </div>
      </div> 
  
      <div class="m-4">
        <div class="bg-panel rounded-md m-4">
          <ul class="flex bg-light-gray px-4 pt-2">
            <li
              class={`mr-4 text-xs md:text-lg ${
                activeTab === "history" ? "active-tab" : ""
              }`}
            >
              <button
                class={`p-2 ${
                  activeTab === "history" ? "text-white" : "text-gray-400"
                }`}
                on:click={() => setActiveTab("history")}
              >
                Gameweek History
              </button>
            </li>
          </ul>
  
          {#if activeTab === "history"}
            <PlayerGameweekHistory />
          {/if}
        </div>
      </div>
    {/if}
  </Layout>
  