<script lang="ts">
  import { onMount } from "svelte";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import { PlayerService } from "$lib/services/PlayerService";
  import type { FantasyTeam, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { TeamService } from "$lib/services/TeamService";
  import AddIcon from "$lib/icons/AddIcon.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";

  export let showAddPlayer: boolean;
  export let closeAddPlayerModal: () => void;
  export let handlePlayerSelection: (player: PlayerDTO) => void;
  export let fantasyTeam: FantasyTeam;
  export let filterPosition = -1;

  let players: any[] = [];
  let teams: Team[] = [];

  let filterTeam = -1;
  let minValue = 0;
  let maxValue = 0;
  let filterSurname = "";
  let currentPage = 1;
  let isLoading = true;
  let progress = 0;
  const pageSize = 10;
  let teamPlayerCounts: Record<number, number> = {};
  let disableReasons: (string | null)[];

  function countPlayersByTeam(playerIds: Uint16Array | number[]) {
    const counts: Record<number, number> = {};
    playerIds.forEach(playerId => {
        const player = players.find(p => p.id === playerId);
        if (player) {
            if (!counts[player.teamId]) {
                counts[player.teamId] = 0;
            }
            counts[player.teamId]++;
        }
    });
    return counts;
  }

  function reasonToDisablePlayer(player: PlayerDTO): string | null {
    const teamCount = teamPlayerCounts[player.teamId] || 0;
    if (teamCount >= 2) return "Max 2 Per Team";

    const canAfford = fantasyTeam.bankBalance >= player.value;
    if (!canAfford) return "Over Budget";
    
    if (fantasyTeam.playerIds.includes(player.id)) return "Already in Team";

    const positionCounts: { [key: number]: number } = { 0: 0, 1: 0, 2: 0, 3: 0 };

    fantasyTeam.playerIds.forEach(id => {
      const teamPlayer = players.find(p => p.id === id);
      if (teamPlayer) {
        positionCounts[teamPlayer.position]++;
      }
    });

    positionCounts[player.position]++;

    const formations = ["3-4-3", "3-5-2", "4-3-3", "4-4-2", "4-5-1", "5-4-1", "5-3-2"];
    const isFormationValid = formations.some(formation => {
      const [def, mid, fwd] = formation.split('-').map(Number);
      const minDef = Math.max(0, def - (positionCounts[1] || 0));
      const minMid = Math.max(0, mid - (positionCounts[2] || 0));
      const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
      const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

      const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
      const totalPlayers = Object.values(positionCounts).reduce((a, b) => a + b, 0);

      return totalPlayers + additionalPlayersNeeded <= 11;
    });

    if (!isFormationValid) return "Invalid Formation";

    return null;
  }

  function addTeamDataToPlayers(players: PlayerDTO[], teams: Team[]): PlayerDTO[] {
    return players.map((player) => {
      const team = teams.find((t) => t.id === player.teamId);
      return { ...player, team };
    });
  }

  function goToPage(page: number) {
    currentPage = page;
  }

  function selectPlayer(player: PlayerDTO) {
    handlePlayerSelection(player);
    closeAddPlayerModal();
  }

  $: filteredPlayers = players.filter((player) => {
    return (
      (filterTeam === -1 || player.teamId === filterTeam) &&
      (filterPosition === -1 || player.position === filterPosition) &&
      (minValue === 0 || player.value >= minValue) &&
      (maxValue === 0 || player.value <= maxValue) &&
      (filterSurname === "" ||
        player.lastName.toLowerCase().includes(filterSurname.toLowerCase()))
    );
  });

  $: paginatedPlayers = filteredPlayers.slice(
    (currentPage - 1) * pageSize,
    currentPage * pageSize
  );

  $: disableReasons = paginatedPlayers.map(player => reasonToDisablePlayer(player));

  $: {
    if (filterTeam || filterPosition || minValue || maxValue || filterSurname) {
      currentPage = 1;
    }
  }

  onMount(async () => {
    let playerService = new PlayerService();
    let teamsService = new TeamService();
    playerService.updatePlayersData();
    players = await playerService.getPlayers();
    teams = await teamsService.getTeams();
    players = addTeamDataToPlayers(players, teams);
    isLoading = false;
    teamPlayerCounts = countPlayersByTeam(fantasyTeam.playerIds);
  });
  
</script>

{#if showAddPlayer}
  {#if isLoading}
    <LoadingIcon {progress} />
  {:else}
    <div class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
      on:click={closeAddPlayerModal} on:keydown={closeAddPlayerModal}>
      <div class="relative top-20 mx-auto p-5 border w-full max-w-4xl shadow-lg rounded-md bg-panel text-white"
        on:click|stopPropagation on:keydown|stopPropagation>
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-xl font-semibold">Select Player</h3>
          <button class="text-3xl leading-none" on:click={closeAddPlayerModal}>&times;</button>
        </div>
        <div class="mb-4">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label for="filterTeam" class="text-sm">Filter by Team:</label>
              <select id="filterTeam" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md" bind:value={filterTeam}>
                <option value={-1}>All</option>
                {#each teams as team}
                  <option value={team.id}>{team.friendlyName}</option>
                {/each}
              </select>
            </div>
            <div>
              <label for="filterPosition" class="text-sm">Filter by Position:</label>
              <select id="filterPosition" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md" bind:value={filterPosition}>
                <option value={-1}>All</option>
                <option value={0}>Goalkeepers</option>
                <option value={1}>Defenders</option>
                <option value={2}>Midfielders</option>
                <option value={3}>Forwards</option>
              </select>
            </div>
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label for="minValue" class="text-sm">Min Value:</label>
              <input id="minValue" type="number" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md" bind:value={minValue} />
            </div>
            <div>
              <label for="maxValue" class="text-sm">Max Value:</label>
              <input id="maxValue" type="number" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md" bind:value={maxValue} />
            </div>
          </div>

          <div class="mb-4">
            <label for="filterSurname" class="text-sm">Search by Name:</label>
            <input id="filterSurname" type="text" class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md" placeholder="Enter" bind:value={filterSurname} />
          </div>

          <div class="mb-4">
            <label for="filterSurname" class="font-bold">Available Balance: £{(Number(fantasyTeam.bankBalance) / 4).toFixed(2)}m</label>
          </div>
        </div>

        <div class="overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr>
                <th class="text-left p-2">Pos</th>
                <th class="text-left p-2">Name</th>
                <th class="text-left p-2">Club</th>
                <th class="text-left p-2">Value</th>
                <th class="text-left p-2">Pts</th>
                <th class="text-left p-2">&nbsp;</th>
              </tr>
            </thead>
            <tbody>
              {#each paginatedPlayers as player, index}
                <tr>
                  {#if player.position === 0}<td class="p-2">GK</td>{/if}
                  {#if player.position === 1}<td class="p-2">DF</td>{/if}
                  {#if player.position === 2}<td class="p-2">MF</td>{/if}
                  {#if player.position === 3}<td class="p-2">FW</td>{/if}
                  <td class="p-2">{player.firstName} {player.lastName}</td>
                  <td class="p-2 flex items-center">
                    <BadgeIcon className="w-6 h-6 mr-2"
                      primaryColour={player.team?.primaryColourHex}
                      secondaryColour={player.team?.secondaryColourHex}
                      thirdColour={player.team?.thirdColourHex}
                    />
                    {player.team?.abbreviatedName}</td>
                  <td class="p-2">£{(Number(player.value) / 4).toFixed(2)}m</td>
                  <td class="p-2">{player.totalPoints}</td>
                  <td class="p-2">
                    <div class="w-1/6 flex items-center">
                      {#if disableReasons[index]}
                        <span>{disableReasons[index]}</span>
                      {:else}
                        <button on:click={() => selectPlayer(player)}
                          class="text-xl rounded fpl-button flex items-center">
                          <AddIcon className="w-6 h-6 p-2" />
                        </button>
                      {/if}
                    </div>
                  </td>
                </tr>
              {/each}
            </tbody>
          </table>
        </div>

        <div class="justify-center mt-4 pb-4 overflow-x-auto">
          <div class="flex space-x-1 min-w-max">
            {#each Array(Math.ceil(filteredPlayers.length / pageSize)) as _, index}
              <button class:active={index + 1 === currentPage} class="px-4 py-2 bg-gray-700 rounded-md text-white hover:bg-gray-600" 
              on:click={() => goToPage(index + 1)}>
                {index + 1}
              </button>
            {/each}
          </div>
        </div>

        <div class="flex justify-end mt-4">
          <button on:click={closeAddPlayerModal} class="px-4 py-2 fpl-purple-btn rounded-md text-white">Close</button>
        </div>
      </div>
    </div>
  {/if}
{/if}

<style>
  .modal-backdrop {
    z-index: 1000;
  }

  .active {
    background-color: #2ce3a6;
    color: white;
  }
</style>
