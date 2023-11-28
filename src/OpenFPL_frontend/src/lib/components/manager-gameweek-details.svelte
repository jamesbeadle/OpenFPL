<script lang="ts">
    import { onMount } from "svelte";
    import { SystemService } from "$lib/services/SystemService";
    import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
    import { getFlagComponent, getPositionAbbreviation } from "$lib/utils/Helpers";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { FantasyTeam, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { PlayerService } from "$lib/services/PlayerService";
    import { TeamService } from "$lib/services/TeamService";
    import type { GameweekData } from "$lib/interfaces/GameweekData";
    import { get, type Writable } from "svelte/store";
    import { Id } from "svelte-flag-icons";
    import { toastStore } from "$lib/stores/toast";

    let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
    export let selectedGameweek: number;
    export let fantasyTeam: Writable<FantasyTeam | null>;
    let gameweekPlayers: GameweekData[] = [];
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

            gameweekPlayers = await playerService.getGameweekPlayers(get(fantasyTeam)!, selectedGameweek);

            players = await playerService.getPlayers();
            teams = await teamService.getTeams();

        } catch (error) {
            toastStore.show("Error fetching manager gameweek detail.", "error");
            console.error("Error fetching manager gameweek detail:", error);
        }
    });

    const changeGameweek = (delta: number) => {
        selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
    };

    function getPlayerDTO(playerId: number): PlayerDTO | null{
        return players.find(x => x.id === playerId) ?? null;
    };

    function getPlayerTeam(teamId: number): Team | null{
        return teams.find(x => x.id === teamId) ?? null;
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
            <div class="w-1/12 text-center mx-4">Position</div>
            <div class="w-2/12">Player</div>
            <div class="w-2/12 text-center">Team</div>
            <div class="w-1/2">
                <div class="w-1/12 text-center">A</div>
                <div class="w-1/12 text-center">HSP</div>
                <div class="w-1/12 text-center">GS</div>
                <div class="w-1/12 text-center">GA</div>
                <div class="w-1/12 text-center">PS</div>
                <div class="w-1/12 text-center">CS</div>
                <div class="w-1/12 text-center">KS</div>
                <div class="w-1/12 text-center">YC</div>
                <div class="w-1/12 text-center">OG</div>
                <div class="w-1/12 text-center">GC</div>
                <div class="w-1/12 text-center">RC</div>
                <div class="w-1/12 text-center">B</div>
            </div>
            <div class="w-1/12 text-center">PTS</div>
          </div>
    
          {#each gameweekPlayers as data}
            {@const playerDTO = getPlayerDTO(data.player.id)}
            {@const playerTeam = getPlayerTeam(data.player.teamId)}
            <div class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer">
                <div class="w-1/12 text-center mx-4">{getPositionAbbreviation(data.player.position)}</div>
                <div class="w-2/12">
                    <svelte:component this={getFlagComponent(playerDTO?.nationality ?? "")} class="w-4 h-4 mr-1" size="100" /> 
                    {playerDTO ? playerDTO.firstName.length > 2 ? playerDTO.firstName.substring(0, 1) + "." + playerDTO.lastName : "" : ""}
                </div>
                <div class="w-2/12 text-center flex items-center">
                    <BadgeIcon
                        primaryColour={playerTeam?.primaryColourHex}
                        secondaryColour={playerTeam?.secondaryColourHex}
                        thirdColour={playerTeam?.thirdColourHex}
                        className="w-6 h-6 mr-2"
                    />
                    {playerTeam?.friendlyName}    
                </div>
                <div class="w-1/2">
                    <div class={`w-1/12 text-center ${data.appearance > 0 ? '' : 'text-gray-500'}`}>{data.appearance}</div>
                    <div class={`w-1/12 text-center ${data.highestScoringPlayerId === playerDTO?.id ? '' : 'text-gray-500'}`}>
                        {data.highestScoringPlayerId === playerDTO?.id ? 1 : 0}
                    </div>
                    <div class={`w-1/12 text-center ${data.goals > 0 ? '' : 'text-gray-500'}`}>{data.goals}</div>
                    <div class={`w-1/12 text-center ${data.assists > 0 ? '' : 'text-gray-500'}`}>{data.assists}</div>
                    <div class={`w-1/12 text-center ${data.penaltySaves > 0 ? '' : 'text-gray-500'}`}>{data.penaltySaves}</div>
                    <div class={`w-1/12 text-center ${data.cleanSheets > 0 ? '' : 'text-gray-500'}`}>{data.cleanSheets}</div>
                    <div class={`w-1/12 text-center ${data.saves > 0 ? '' : 'text-gray-500'}`}>{data.saves}</div>
                    <div class={`w-1/12 text-center ${data.yellowCards > 0 ? '' : 'text-gray-500'}`}>{data.yellowCards}</div>
                    <div class={`w-1/12 text-center ${data.ownGoals > 0 ? '' : 'text-gray-500'}`}>{data.ownGoals}</div>
                    <div class={`w-1/12 text-center ${data.goalsConceded > 0 ? '' : 'text-gray-500'}`}>{data.goalsConceded}</div>
                    <div class={`w-1/12 text-center ${data.redCards > 0 ? '' : 'text-gray-500'}`}>{data.redCards}</div>
                    <div class={`w-1/12 text-center ${data.bonusPoints > 0 ? '' : 'text-gray-500'}`}>{data.bonusPoints}</div>
                </div>
                <div class="w-1/12 text-center">{data.points}</div>
            </div>
          {/each}
        </div>
    </div>
</div>
