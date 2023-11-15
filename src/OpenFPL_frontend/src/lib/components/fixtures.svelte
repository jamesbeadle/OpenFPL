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

    const fixtureService = new FixtureService();
    const teamService = new TeamService();
  
    onMount(async () => {
        try {
            // Assuming getFixturesData() and getTeamsData() are async functions
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
            // Handle error appropriately
        }
    });

    const changeGameweek = (delta: number): void => {
      gameweek += delta;
    };
  
    const selectSeason = (selectedSeason: string): void => {
      season = selectedSeason;
    };
  
    // Function to find a team by ID
    function getTeamFromId(teamId: number): Team | undefined {
        return teams.find((team) => team.id === teamId);
    }

</script>

<div class="container mx-auto mt-4">
      
    <div class="flex flex-col space-y-4">
    <div class="flex items-center justify-between">
        <button
        class="p-2 bg-blue-500 text-white rounded"
        on:click={() => changeGameweek(-1)}>
        &lt; GameWeek {gameweek - 1}
        </button>
        <select
        class="p-2 rounded border border-gray-200"
        bind:value={season}>
        {#each seasons as s}
            <option value="{s}">{s}</option>
        {/each}
        </select>
        <button
        class="p-2 bg-blue-500 text-white rounded"
        on:click={() => changeGameweek(1)}>
        GameWeek {gameweek + 1} &gt;
        </button>
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
