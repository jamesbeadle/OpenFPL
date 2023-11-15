<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Fixture, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    type FixtureWithTeams = {
        fixture: Fixture;
        homeTeam: Team | undefined;
        awayTeam: Team | undefined;
    };
  
    let gameweek: number = 12;
    let season: string = '2023/24';
    const seasons: string[] = ['2023/24', '2022/23', '2021/22'];
    const fixtures: Fixture[] = [];
    const teams: Team[] = [];
  
    const changeGameweek = (delta: number): void => {
      gameweek += delta;
    };
  
    const selectSeason = (selectedSeason: string): void => {
      season = selectedSeason;
    };

    const fixturesWithTeams: FixtureWithTeams[] = fixtures.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeTeamId),
        awayTeam: getTeamFromId(fixture.awayTeamId)
    }));
  
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
          {#each fixturesWithTeams as { fixture, homeTeam, awayTeam }}
          <div>
            <div class="flex items-center justify-between border-b border-gray-700 py-2">
              <div class="flex items-center space-x-4">
                <div class="w-10 h-10 bg-red-600 rounded-full flex items-center justify-center">
                    <BadgeIcon 
                        primaryColour="{homeTeam ? homeTeam.primaryColourHex : ''}"
                        secondaryColour="{homeTeam ? homeTeam.secondaryColourHex : ''}"
                        thirdColour="{homeTeam ? homeTeam.thirdColourHex : ''}"
                    />
                  <span class="text-xs text-white font-bold">CP</span>
                </div>
                <span class="font-bold text-lg">v</span>
                <div class="w-10 h-10 bg-blue-600 rounded-full flex items-center justify-center">
                    <BadgeIcon 
                    primaryColour="{awayTeam ? awayTeam.primaryColourHex : ''}"
                    secondaryColour="{awayTeam ? awayTeam.secondaryColourHex : ''}"
                    thirdColour="{awayTeam ? awayTeam.thirdColourHex : ''}"
                />
                </div>
                <span class="font-medium text-sm ml-4">9:30AM</span>
              </div>
              <div class="flex items-center space-x-10">
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
      
      <style>
        .badge {
          display: inline-block;
          padding: 0.25rem 0.75rem;
          font-size: 0.875rem;
          font-weight: 700;
          line-height: 1.25;
          text-align: center;
          white-space: nowrap;
          vertical-align: baseline;
          border-radius: 0.375rem;
          color: white;
        }
        .badge-primary {
          background-color: #f59e0b; /* Yellow for home team */
        }
        .badge-secondary {
          background-color: #3b82f6; /* Blue for away team */
        }
      </style>
      
</div>
