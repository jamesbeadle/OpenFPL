<script lang="ts">
    import { onMount } from 'svelte';
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Fixture, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { SystemService } from "$lib/services/SystemService";
    import { FixtureService } from "$lib/services/FixtureService";
    import { TeamService } from '$lib/services/TeamService';
    import { formatUnixTimeToTime } from '../../utils/Helpers';
    
    type FixtureWithTeams = {
        fixture: Fixture;
        homeTeam: Team | undefined;
        awayTeam: Team | undefined;
    };
    const fixtureService = new FixtureService();
    const teamService = new TeamService();
    const systemService = new SystemService();

    let selectedGameweek: number = 1;
    let fixtures: FixtureWithTeams[] = [];
    let teams: Team[] = [];
    let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
    $: filteredFixtures = fixtures.filter(({ fixture }) => fixture.gameweek === selectedGameweek);

  
    onMount(async () => {
        try {
            const fetchedFixtures = await fixtureService.getFixturesData(localStorage.getItem('fixtures_hash') ?? '');
            const fetchedTeams = await teamService.getTeamsData(localStorage.getItem('teams_hash') ?? '');

            teams = fetchedTeams;
            fixtures = fetchedFixtures.map((fixture) => ({
                fixture,
                homeTeam: getTeamFromId(fixture.homeTeamId),
                awayTeam: getTeamFromId(fixture.awayTeamId)
            }));
            let systemState = await systemService.getSystemState(localStorage.getItem('system_state_hash') ?? '');
            selectedGameweek = systemState.activeGameweek;
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    });
    
    const changeGameweek = (delta: number) => {
        selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
    };
  
    function getTeamFromId(teamId: number): Team | undefined {
        return teams.find((team) => team.id === teamId);
    }

</script>

<div class="container-fluid mx-auto mt-4">
    <div class="flex flex-col space-y-4">
        <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
            <div class="flex items-center space-x-2">
              <button
                class="text-2xl rounded fpl-button px-2 py-1"
                on:click={() => changeGameweek(-1)}
                disabled={selectedGameweek === 1}>
                &lt;
              </button>
              
              <select
                class="p-2 fpl-dropdown text-sm md:text-xl"
                bind:value={selectedGameweek}>
                {#each gameweeks as gameweek}
                  <option value="{gameweek}">Gameweek {gameweek}</option>
                {/each}
              </select>
              
              <button
                class="text-2xl rounded fpl-button px-2 py-1"
                on:click={() => changeGameweek(1)}
                disabled={selectedGameweek === 38}>
                &gt;
              </button>
            </div>
        </div>
        <div class="space-y-2">
            <div class="flex items-center justify-between border-b border-gray-700 py-2">
                <div class="flex items-center md:w-1/4 w-1/2">
                    <p class="text-xs md:text-lg">Games</p>
                </div>
                <div class="flex items-center hidden md:inline md:w-1/4">
                    <p class="text-xs md:text-lg">Kick Off</p>
                </div>
                <div class="flex items-center space-x-10 w-1/2">
                    <div class="flex flex-col">
                        <p class="text-xs md:text-lg">Score</p>
                    </div>
                </div>
            </div>
            {#each filteredFixtures as { fixture, homeTeam, awayTeam }}
                <div class="flex items-center justify-between border-b border-gray-700 py-2">
                    <div class="flex items-center w-1/2">
                        <div class="flex w-1/2 space-x-4 items-center ">
                        
                            <div class="w-10 items-center justify-center">
                                <BadgeIcon 
                                    primaryColour="{homeTeam ? homeTeam.primaryColourHex : ''}"
                                    secondaryColour="{homeTeam ? homeTeam.secondaryColourHex : ''}"
                                    thirdColour="{homeTeam ? homeTeam.thirdColourHex : ''}"
                                />
                            </div>
                            <span class="font-bold text-lg">v</span>
                            <div class="w-10 items-center justify-center">
                                <BadgeIcon 
                                    primaryColour="{awayTeam ? awayTeam.primaryColourHex : ''}"
                                    secondaryColour="{awayTeam ? awayTeam.secondaryColourHex : ''}"
                                    thirdColour="{awayTeam ? awayTeam.thirdColourHex : ''}"
                                />
                            </div>
                        </div>
                        <div class="flex w-1/2">
                            <span class="text-sm md:text-lg ml-4 md:ml-0">{formatUnixTimeToTime(Number(fixture.kickOff))}</span>
                        
                        </div>

                    </div>
                    <div class="flex items-center space-x-10 w-1/2">
                    <div class="flex flex-col min-w-[125px] md:min-w-[300px] text-xs md:text-lg">
                        <span>{homeTeam ? homeTeam.friendlyName : ''}</span>
                        <span>{awayTeam ? awayTeam.friendlyName : ''}</span>
                    </div>
                    <div class="flex flex-col items-center text-xs md:text-lg">
                        <span>{fixture.homeGoals}</span>
                        <span>{fixture.awayGoals}</span>
                    </div>
                    </div>
                </div>
            {/each}
        </div>
    </div>
      
      
</div>
