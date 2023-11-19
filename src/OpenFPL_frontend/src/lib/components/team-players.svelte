<script lang="ts">
    import { onMount } from "svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { SystemService } from "$lib/services/SystemService";
    import { TeamService } from "$lib/services/TeamService";
    import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
    const teamService = new TeamService();
    const systemService = new SystemService();

    export let players: PlayerDTO[] = [];
  
    let teams: Team[] = [];
    
    onMount(async () => {
      try {
        const fetchedTeams = await teamService.getTeamsData(
          localStorage.getItem("teams_hash") ?? ""
        );
  
        teams = fetchedTeams;
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    });
  
    function getTeamFromId(teamId: number): Team | undefined {
      return teams.find((team) => team.id === teamId);
    }
  </script>
  
  <div class="container-fluid mt-4">
    <div class="flex flex-col space-y-4">
      <div>
        {#each players as player }
          <div class="flex items-center justify-between py-2 border-b border-gray-700 text-white cursor-pointer">
            <a class="flex-grow flex items-center justify-start space-x-2 px-4" href={`/player?id=${player.id}`}>
                <div class="flex items-center w-1/2 ml-4">
                    {player.firstName == "" ? '-' : player.firstName}
                </div>
                <div class="flex items-center w-1/2 ml-4">
                    {player.lastName}
                </div>
                <div class="flex items-center w-1/2 ml-4">
                    
                </div>
            </a>
          </div>
        {/each}
      </div>
    </div>
  </div>
  