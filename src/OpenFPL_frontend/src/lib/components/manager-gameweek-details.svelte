<script lang="ts">
    import { onMount } from "svelte";
    import { SystemService } from "$lib/services/SystemService";
    import type { PlayerDTO, PlayerPointsDTO } from "../../../../declarations/player_canister/player_canister.did";
    import { getFlagComponent, getPositionAbbreviation } from "$lib/utils/Helpers";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { PlayerService } from "$lib/services/PlayerService";
    import { TeamService } from "$lib/services/TeamService";

    let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
    let selectedGameweek: number = 1;
    let gameweekPlayers: PlayerPointsDTO[] = [];
    let players: PlayerDTO[];
    let teams: Team[];
  
    onMount(async () => {
        try {
            const systemService = new SystemService();
            const playerService = new PlayerService();
            const teamService = new TeamService();
            
            await systemService.updateSystemStateData();
            await playerService.updatePlayersData();
            await playerService.updatePlayerEventsData();
            await systemService.updateSystemStateData();
            await teamService.updateTeamsData();

            let systemState = await systemService.getSystemState();
            selectedGameweek = systemState?.activeGameweek ?? selectedGameweek;

            players = await playerService.getPlayers();
            teams = await teamService.getTeams();

        } catch (error) {
            console.error("Error fetching data:", error);
        }
    });

    const changeGameweek = (delta: number) => {
        selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
    };

    function getPlayerDTO(playerId: number): PlayerDTO | null{
        return players.find(x => x.id == playerId) ?? null;
    };

    function getPlayerTeam(teamId: number): Team | null{
        return teams.find(x => x.id == teamId) ?? null;
    }

</script>
<div class="mx-5 my-4">
    <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
        <div class="flex items-center space-x-2">
            <button class="text-2xl rounded fpl-button px-2" on:click={() => changeGameweek(-1)} disabled={selectedGameweek === 1}>
                &lt;
            </button>
        
            <select class="p-4 fpl-dropdown text-sm md:text-lg text-center" bind:value={selectedGameweek}>
                {#each gameweeks as gameweek}
                    <option value={gameweek}>Gameweek {gameweek}</option>
                {/each}
            </select>
        
            <button class="text-2xl rounded fpl-button px-2 ml-1" on:click={() => changeGameweek(1)} disabled={selectedGameweek === 38}>
                &gt;
            </button>
        </div>
    </div>

    <div class="flex flex-col space-y-4 mt-4 text-lg">
        <div class="overflow-x-auto flex-1">
          <div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray">
            <div class="w-1/6 text-center mx-4">Position</div>
            <div class="w-2/6">Player</div>
            <div class="w-2/6 text-center">Team</div>
            <div class="w-1/6 text-center">Points</div>
          </div>
    
          {#each gameweekPlayers as player}
            {@const playerDTO = getPlayerDTO(player.id)}
            {@const playerTeam = getPlayerTeam(player.teamId)}
            <div class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer">
                <div class="w-1/6 text-center mx-4">{getPositionAbbreviation(player.position)}</div>
                <div class="w-2/6">
                    <svelte:component this={getFlagComponent(playerDTO?.nationality ?? "")} class="w-4 h-4 mr-1" size="100" /> 
                    {playerDTO ? 
                        playerDTO.firstName.length > 2 ? playerDTO.firstName.substring(0, 1) + "." + playerDTO.lastName : "" : ""}
                </div>
                <div class="w-2/6 text-center flex items-center">
                    <BadgeIcon
                        primaryColour={playerTeam?.primaryColourHex}
                        secondaryColour={playerTeam?.secondaryColourHex}
                        thirdColour={playerTeam?.thirdColourHex}
                        className="w-6 h-6 mr-2"
                    />
                    {playerTeam?.friendlyName}    
                </div>
                <div class="w-1/6 text-center">
                    {player.points}
                </div>
            </div>
          {/each}
        </div>
      </div>
</div>
