<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { writable, get } from "svelte/store";
  import type { PlayerDTO } from "../../../../../declarations/player_canister/player_canister.did";
  import type {
    FantasyTeam,
    Team,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import AddIcon from "$lib/icons/AddIcon.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { toastStore } from "$lib/stores/toast-store";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";

  export let showAddPlayer: boolean;
  export let closeAddPlayerModal: () => void;
  export let handlePlayerSelection: (player: PlayerDTO) => void;
  export let fantasyTeam = writable<FantasyTeam | null>(null);

  export let filterPosition = -1;
  export let filterColumn = -1;
  export let bankBalance = writable<number>(0);

  export let players: any[];
  export let teams: Team[];

  let unsubscribeTeams: () => void;
  let unsubscribePlayers: () => void;

  let filterTeam = -1;
  let filterSurname = "";
  let minValue = 0;
  let maxValue = 0;
  let currentPage = 1;
  const pageSize = 10;

  $: filteredPlayers = players.filter((player) => {
    return (
      (filterTeam === -1 || player.teamId === filterTeam) &&
      (filterPosition === -1 || player.position === filterPosition) &&
      filterColumn > -2 &&
      (minValue === 0 || player.value >= minValue) &&
      (maxValue === 0 || player.value <= maxValue) &&
      (filterSurname === "" ||
        player.lastName.toLowerCase().includes(filterSurname.toLowerCase()))
    );
  });

  $: paginatedPlayers = addTeamDataToPlayers(
    filteredPlayers.slice((currentPage - 1) * pageSize, currentPage * pageSize)
  );

  $: teamPlayerCounts = countPlayersByTeam(get(fantasyTeam)?.playerIds ?? []);
  $: disableReasons = paginatedPlayers.map((player) =>
    reasonToDisablePlayer(player)
  );

  $: {
    if (
      filterTeam ||
      filterPosition ||
      filterColumn ||
      minValue ||
      maxValue ||
      filterSurname
    ) {
      teamPlayerCounts = countPlayersByTeam(get(fantasyTeam)?.playerIds ?? []);
      currentPage = 1;
    }
  }

  onMount(async () => {
    try {
      await playerStore.sync();
      await teamStore.sync();

      unsubscribeTeams = teamStore.subscribe((value) => {
        teams = value;
      });

      unsubscribePlayers = playerStore.subscribe((value) => {
        players = value;
      });

      let team = get(fantasyTeam);
      teamPlayerCounts = countPlayersByTeam(team?.playerIds ?? []);
    } catch (error) {
      toastStore.show("Error loading add player modal.", "error");
      console.error("Error fetching homepage data:", error);
    }
  });

  onDestroy(() => {
    unsubscribeTeams?.();
    unsubscribePlayers?.();
  });

  function countPlayersByTeam(playerIds: Uint16Array | number[]) {
    const counts: Record<number, number> = {};
    playerIds.forEach((playerId) => {
      const player = players.find((p) => p.id === playerId);
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

    let team = get(fantasyTeam);

    const canAfford = get(bankBalance) >= Number(player.value);
    if (!canAfford) return "Over Budget";

    if (team && team.playerIds.includes(player.id)) return "Selected";

    const positionCounts: { [key: number]: number } = {
      0: 0,
      1: 0,
      2: 0,
      3: 0,
    };

    team &&
      team.playerIds.forEach((id) => {
        const teamPlayer = players.find((p) => p.id === id);
        if (teamPlayer) {
          positionCounts[teamPlayer.position]++;
        }
      });

    positionCounts[player.position]++;

    const formations = [
      "3-4-3",
      "3-5-2",
      "4-3-3",
      "4-4-2",
      "4-5-1",
      "5-4-1",
      "5-3-2",
    ];
    const isFormationValid = formations.some((formation) => {
      const [def, mid, fwd] = formation.split("-").map(Number);
      const minDef = Math.max(0, def - (positionCounts[1] || 0));
      const minMid = Math.max(0, mid - (positionCounts[2] || 0));
      const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
      const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

      const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
      const totalPlayers = Object.values(positionCounts).reduce(
        (a, b) => a + b,
        0
      );

      return totalPlayers + additionalPlayersNeeded <= 11;
    });

    if (!isFormationValid) return "Invalid Formation";

    return null;
  }

  function addTeamDataToPlayers(players: PlayerDTO[]): any[] {
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
    filteredPlayers = [];
  }
</script>

{#if showAddPlayer}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={closeAddPlayerModal}
    on:keydown={closeAddPlayerModal}
  >
    <div
      class="relative top-10 md:top-20 mx-auto p-5 border w-full max-w-4xl shadow-lg rounded-md bg-panel text-white"
      on:click|stopPropagation
      on:keydown|stopPropagation
    >
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-xl font-semibold">Select Player</h3>
        <button class="text-3xl leading-none" on:click={closeAddPlayerModal}
          >&times;</button
        >
      </div>
      <div class="mb-4">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
          <div>
            <label for="filterTeam" class="text-sm">Filter by Team:</label>
            <select
              id="filterTeam"
              class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
              bind:value={filterTeam}
            >
              <option value={-1}>All</option>
              {#each teams as team}
                <option value={team.id}>{team.friendlyName}</option>
              {/each}
            </select>
          </div>
          <div>
            <label for="filterPosition" class="text-sm"
              >Filter by Position:</label
            >
            <select
              id="filterPosition"
              class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
              bind:value={filterPosition}
            >
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
            <input
              id="minValue"
              type="number"
              class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
              bind:value={minValue}
            />
          </div>
          <div>
            <label for="maxValue" class="text-sm">Max Value:</label>
            <input
              id="maxValue"
              type="number"
              class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
              bind:value={maxValue}
            />
          </div>
        </div>

        <div class="mb-4">
          <label for="filterSurname" class="text-sm">Search by Name:</label>
          <input
            id="filterSurname"
            type="text"
            class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
            placeholder="Enter"
            bind:value={filterSurname}
          />
        </div>

        <div class="mb-4">
          <label for="bankBalance" class="font-bold"
            >Available Balance: £{($bankBalance / 4).toFixed(2)}m</label
          >
        </div>
      </div>

      <div class="overflow-x-auto flex-1 text-xs md:text-base">
        <div
          class="flex justify-between border border-gray-700 py-4 bg-light-gray"
        >
          <div class="w-1/12 text-center mx-4">Pos</div>
          <div class="w-4/12">Player</div>
          <div class="w-2/12">Team</div>
          <div class="w-2/12">Value</div>
          <div class="w-1/12">PTS</div>
          <div class="w-2/12 text-center">&nbsp</div>
        </div>

        {#each paginatedPlayers as player, index}
          <div
            class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer"
          >
            <div class="w-1/12 text-center mx-4">
              {#if player.position === 0}GK{/if}
              {#if player.position === 1}DF{/if}
              {#if player.position === 2}MF{/if}
              {#if player.position === 3}FW{/if}
            </div>
            <div class="w-4/12">
              {player.firstName}
              {player.lastName}
            </div>
            <div class="w-2/12">
              <p class="flex items-center">
                <BadgeIcon
                  className="w-6 h-6 mr-2"
                  primaryColour={player.team?.primaryColourHex}
                  secondaryColour={player.team?.secondaryColourHex}
                  thirdColour={player.team?.thirdColourHex}
                />
                {player.team?.abbreviatedName}
              </p>
            </div>
            <div class="w-2/12">£{(Number(player.value) / 4).toFixed(2)}m</div>
            <div class="w-1/12">{player.totalPoints}</div>
            <div class="w-2/12 flex justify-center items-center">
              {#if disableReasons[index]}
                <span class="text-xs text-center">{disableReasons[index]}</span>
              {:else}
                <button
                  on:click={() => selectPlayer(player)}
                  class="text-xl rounded fpl-button flex items-center"
                >
                  <AddIcon className="w-6 h-6 p-2" />
                </button>
              {/if}
            </div>
          </div>
        {/each}
      </div>

      <div class="justify-center mt-4 pb-4 overflow-x-auto">
        <div class="flex space-x-1 min-w-max">
          {#each Array(Math.ceil(filteredPlayers.length / pageSize)) as _, index}
            <button
              class:active={index + 1 === currentPage}
              class="px-4 py-2 bg-gray-700 rounded-md text-white hover:bg-gray-600"
              on:click={() => goToPage(index + 1)}
            >
              {index + 1}
            </button>
          {/each}
        </div>
      </div>

      <div class="flex justify-end mt-4">
        <button
          on:click={closeAddPlayerModal}
          class="px-4 py-2 fpl-purple-btn rounded-md text-white">Close</button
        >
      </div>
    </div>
  </div>
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
