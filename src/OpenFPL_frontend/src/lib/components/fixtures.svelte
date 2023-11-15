<script lang="ts">
    import { onMount } from 'svelte';
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Fixture, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { SystemService } from "$lib/services/SystemService";
    import { FixtureService } from "$lib/services/FixtureService";
    import { TeamService } from '$lib/services/TeamService';
    
    type FixtureWithTeams = {
        fixture: Fixture;
        homeTeam: Team | undefined;
        awayTeam: Team | undefined;
    };

  
    let gameweek: number = 12;
    let season: string = '2023/24';
    const seasons: string[] = ['2023/24', '2022/23', '2021/22'];
    let fixtures: FixtureWithTeams[] = [];
    let teams: Team[] = [];
    let selectedGameweek = 'Gameweek 12'; // Default or fetched value
    let selectedSeason = '2023/24'; // Default or fetched value
    let gameweeks = Array.from({ length: 38 }, (_, i) => `Gameweek ${i + 1}`);
 
    const fixtureService = new FixtureService();
    const teamService = new TeamService();
  
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
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    });

    
    const changeGameweek = (delta: number) => {
        gameweek = Math.max(1, Math.min(38, gameweek + delta));
    };

        
    const changeSeason = (delta: number) => {
        gameweek = Math.max(1, Math.min(38, gameweek + delta));
    };
  
    const selectSeason = (event: Event) => {
        if (event.target instanceof HTMLSelectElement) {
            season = event.target.value;
        }
    };

  
    function getTeamFromId(teamId: number): Team | undefined {
        return teams.find((team) => team.id === teamId);
    }

</script>

<div class="container mx-auto mt-4">
      
    <div class="flex flex-col space-y-4">
        <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
            <div class="flex items-center space-x-2">
              <button
                class="text-2xl rounded fpl-button px-2 py-1"
                on:click={() => changeGameweek(-1)}
                disabled={selectedGameweek === 'Gameweek 1'}>
                &lt;
              </button>
              
              <select
                class="p-2 fpl-dropdown text-xl min-w-[200px] md:min-w-[unset]"
                bind:value={selectedGameweek}>
                {#each gameweeks as gameweek}
                  <option value="{gameweek}">{gameweek}</option>
                {/each}
              </select>
              
              <button
                class="text-2xl rounded fpl-button px-2 py-1"
                on:click={() => changeGameweek(1)}
                disabled={selectedGameweek === 'Gameweek 38'}>
                &gt;
              </button>
            </div>
            
            <!-- Adding a separate div for the season selector -->
            <div class="flex items-center space-x-2">
              <button
                class="text-2xl rounded fpl-button px-2 py-1"
                on:click={() => changeSeason(-1)}
                disabled={selectedSeason === seasons[0]}>
                &lt;
              </button>
              
              <select
                class="p-2 fpl-dropdown text-xl min-w-[200px] md:min-w-[unset]"
                bind:value={selectedSeason}>
                {#each seasons as season}
                  <option value="{season}">{season}</option>
                {/each}
              </select>
              
              <button
                class="text-2xl rounded fpl-button px-2 py-1"
                on:click={() => changeSeason(1)}
                disabled={selectedSeason === seasons[seasons.length - 1]}>
                &gt;
              </button>
            </div>
          </div>
          
        
    
        <div class="space-y-2">
            {#each fixtures as { fixture, homeTeam, awayTeam }}
            <div>
            <div class="flex items-center justify-between border-b border-gray-700 py-2">
                <div class="flex items-center w-1/2">
                <div class="flex w-1/2 space-x-4 items-center ">
                
                    <div class="w-10 h-10 items-center justify-center">
                        <BadgeIcon 
                            primaryColour="{homeTeam ? homeTeam.primaryColourHex : ''}"
                            secondaryColour="{homeTeam ? homeTeam.secondaryColourHex : ''}"
                            thirdColour="{homeTeam ? homeTeam.thirdColourHex : ''}"
                        />
                    </div>
                    <span class="font-bold text-lg">v</span>
                    <div class="w-10 h-10 items-center justify-center">
                        <BadgeIcon 
                            primaryColour="{awayTeam ? awayTeam.primaryColourHex : ''}"
                            secondaryColour="{awayTeam ? awayTeam.secondaryColourHex : ''}"
                            thirdColour="{awayTeam ? awayTeam.thirdColourHex : ''}"
                        />
                    </div>
                </div>
                <div class="flex w-1/2">
                    <span class="font-medium text-sm ml-4">9:30AM</span>
                
                </div>

                </div>
                <div class="flex items-center space-x-10 w-1/2">
                <div class="flex flex-col">
                    <span>Crystal Palace</span>
                    <span>Tottenham Hotspur</span>
                </div>
                <div class="flex flex-col items-center">
                    <span>1</span>
                    <span>2</span>
                </div>
                </div>
            </div>
            </div>
            
            {/each}
        </div>
    </div>
      
      
</div>
