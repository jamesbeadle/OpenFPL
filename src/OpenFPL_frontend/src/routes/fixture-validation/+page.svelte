<script lang="ts">
    import { onMount } from 'svelte';
    import type { Fixture, Team } from '../../../../declarations/OpenFPL_backend/OpenFPL_backend.did';
    import type { PlayerDTO } from '../../../../declarations/player_canister/player_canister.did';
    import { PlayerService } from '$lib/services/PlayerService';
    import { SystemService } from '$lib/services/SystemService';
    import { TeamService } from '$lib/services/TeamService';
    import { GovernanceService } from '$lib/services/GovernanceService';
    import { toastStore } from '$lib/stores/toast';
  
    let teams: Team[];
    let fixtures: Fixture[];
    let players: PlayerDTO[];
    let currentGameweek: number;
    let currentSeason: string;
    let isLoading = true;
    
    onMount(async () => {
      try {
        let governanceService = new GovernanceService();
        fixtures = await governanceService.getValidatableFixtures();
        currentGameweek = fixtures[0].gameweek;

        let playerService = new PlayerService();
        players = await playerService.getPlayers();

        let teamService = new TeamService();
        teams = await teamService.getTeams();

        let systemService = new SystemService();
        let systemState = await systemService.getSystemState();
        currentSeason = systemState?.activeSeason.name ?? "";
        
      } catch (error) {
        toastStore.show("Error fetching fixture validation list.", "error");
        console.error(error);
      } finally {
        isLoading = false;
      }
    });

    function getTeamById(teamId: number) : Team{
        return teams.find(x => x.id == teamId)!; 
    }
  </script>
  
  {#if isLoading}
    <div class="flex items-center justify-center h-screen">
      <div class="spinner-border animate-spin inline-block w-8 h-8 border-4 rounded-full" role="status">
        <span class="visually-hidden">Loading...</span>
      </div>
      <p class="text-center mt-1">Loading Fixtures</p>
    </div>
  {:else}
    <div class="container mx-auto my-5 flex-grow">
      <div class="card mb-3 p-4">
        <p>This view will be removed after the SNS decentralisation sale</p>
      </div>
      <div class="card custom-card mt-3 p-4">
        <div class="card-header">{`Season ${currentSeason}`} - {`Gameweek ${currentGameweek}`}</div>
        <div class="card-body">
          <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
              <tr>
                <th scope="col">#</th>
                <th scope="col">Match</th>
                <th scope="col">Status</th>
                <th scope="col">Action</th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              {#each fixtures as fixture, index (fixture.id)}
                <tr>
                  <td>{index + 1}</td>
                  <td>{`${getTeamById(fixture.homeTeamId).name} vs ${getTeamById(fixture.awayTeamId).name}`}</td>
                  <td>{fixture.status === 2 ? "Completed" : "Active"}</td>
                  <td>
                    <a href={`/add-fixture-data?id=${fixture.id}`}>
                        <button class="btn btn-primary">
                        Add Player Event Data
                        </button>
                    </a>
                  </td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  {/if}
