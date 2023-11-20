<script lang="ts">
    import { onMount } from "svelte";
    import { page } from '$app/stores';
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { SystemService } from "$lib/services/SystemService";
    import { FixtureService } from "$lib/services/FixtureService";
    import { TeamService } from "$lib/services/TeamService";
    import type { FixtureWithTeams } from "$lib/types/FixtureWithTeams";
    import { PlayerService } from "$lib/services/PlayerService";
    import type { PlayerDetailDTO } from "../../../../declarations/player_canister/player_canister.did";
    import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
    
    const fixtureService = new FixtureService();
    const teamService = new TeamService();
    const systemService = new SystemService();
    const playerService = new PlayerService();
  
    let selectedGameweek: number = 1;
    let fixtures: FixtureWithTeams[] = [];
    let teams: Team[] = [];
    let playerDetails: PlayerDetailDTO;
    
    let progress = 0;
    let isLoading = true;

    $: id = Number($page.url.searchParams.get('id'));
  
    onMount(async () => {
      try {
        const fetchedFixtures = await fixtureService.getFixturesData(
          localStorage.getItem("fixtures_hash") ?? ""
        );
        const fetchedTeams = await teamService.getTeamsData(
          localStorage.getItem("teams_hash") ?? ""
        );
        
        teams = fetchedTeams;
        fixtures = fetchedFixtures.map((fixture) => ({
          fixture,
          homeTeam: getTeamFromId(fixture.homeTeamId),
          awayTeam: getTeamFromId(fixture.awayTeamId),
        }));
        let systemState = await systemService.getSystemState(
          localStorage.getItem("system_state_hash") ?? ""
        );
        const fetchedPlayerDetails = await playerService.getPlayerDetails(id, systemState.activeSeason.id);
        playerDetails = fetchedPlayerDetails;
        console.log(playerDetails)
        selectedGameweek = systemState.activeGameweek;
        isLoading = false;
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    });
    
    function getTeamFromId(teamId: number): Team | undefined {
      return teams.find((team) => team.id === teamId);
    }
    
    function getOpponentFromFixtureId(fixtureId: number): Team | undefined {
      let fixture = fixtures.find((fixture) => fixture.fixture.id == fixtureId);
      let opponentId = fixture?.homeTeam && (fixture?.homeTeam.id === playerDetails.teamId)
          ? fixture.awayTeam?.id 
          : fixture?.awayTeam && (fixture?.awayTeam.id === playerDetails.teamId) 
            ? fixture.homeTeam?.id : 0;
      
      return teams.find((team) => team.id === opponentId);
    }
  
</script>

{#if isLoading}
  <LoadingIcon {progress} />
{:else}
  <div class="flex flex-col space-y-4 text-lg mt-4">
      <div class="overflow-x-auto flex-1">
        <div class='flex justify-between p-2 border border-gray-700 py-4 bg-light-gray'>
          <div class="w-1/4 px-4">Gameweek</div>
          <div class="w-1/4 px-4">Opponent</div>
          <div class="w-1/4 px-4">Points</div>
          <div class="w-1/4 px-4">-</div>
        </div>

        {#each playerDetails.gameweeks as gameweek}
          <div class="flex items-center justify-between p-2 py-4 border-b border-gray-700 cursor-pointer">
              <div class="w-1/4 px-4">{gameweek.number}</div>
              <div class="w-1/4 px-4">{getOpponentFromFixtureId(gameweek.fixtureId)?.friendlyName}</div>
              <div class="w-1/4 px-4">{gameweek.points}</div>
              <div class="w-1/4 px-4"><button>View Details</button></div>
          </div>
        {/each}
      </div>
  </div>
{/if}
