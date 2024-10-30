<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import type { PlayerDTO, PickTeamDTO } from "../../../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import AddIcon from "$lib/icons/AddIcon.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { Modal } from "@dfinity/gix-components";
  import { convertPlayerPosition } from "$lib/utils/helpers";
  import { allFormations } from "$lib/utils/pick-team.helpers";
    import { storeManager } from "$lib/managers/store-manager";

  export let visible: boolean;
  export let closeAddPlayerModal: () => void;
  export let handlePlayerSelection: (player: PlayerDTO) => void;
  export let fantasyTeam: Writable<PickTeamDTO | null>;

  export let filterPosition = -1;
  export let filterColumn = -1;
  export let bankBalance = writable<number>(0);

  let filterTeam = -1;
  let filterSurname = "";
  let minValue = 0;
  let maxValue = 0;
  let currentPage = 1;
  const pageSize = 10;
  
  function filterPlayers() {
    filteredPlayers = $playerStore.filter((player) => {
      const normalizedFilterSurname = normalizeString(filterSurname.toLowerCase());
      const normalizedPlayerLastName = normalizeString(player.lastName.toLowerCase());
      const adjustedMinValue = minValue * 4;
      const adjustedMaxValue = maxValue * 4;

      
      return (
        (filterTeam === -1 || player.clubId === filterTeam) &&
        (filterPosition === -1 || convertPlayerPosition(player.position) === filterPosition) &&
        filterColumn > -2 &&
        (adjustedMinValue === 0 || player.valueQuarterMillions >= adjustedMinValue) &&
        (adjustedMaxValue === 0 || player.valueQuarterMillions <= adjustedMaxValue) &&
        (filterSurname === "" || normalizedPlayerLastName.includes(normalizedFilterSurname))
      );
    });

    filteredPlayers.sort((a, b) => {
      if (filterTeam === -1) {
        return b.valueQuarterMillions - a.valueQuarterMillions;
      } else {
        if (a.clubId === b.clubId) {
          return b.valueQuarterMillions - a.valueQuarterMillions;
        }
        return a.clubId - b.clubId;
      }
    });
  }

  let filteredPlayers: PlayerDTO[] = [];

  onMount(async () => {
    await filterPlayers();
  });
   

  $: paginatedPlayers = addTeamDataToPlayers(
    filteredPlayers.slice((currentPage - 1) * pageSize, currentPage * pageSize)
  );

  $: teamPlayerCounts = countPlayersByTeam($fantasyTeam?.playerIds ?? []);
  $: disableReasons = paginatedPlayers.map((player) =>
    reasonToDisablePlayer(player)
  );


  $: {
    if (
      filterTeam !== -1 ||
      filterPosition !== -1 ||
      filterColumn !== -1 ||
      minValue !== 0 ||
      maxValue !== 0 ||
      filterSurname !== ""
    ) {
      filterPlayers();
      teamPlayerCounts = countPlayersByTeam($fantasyTeam?.playerIds ?? []);
      currentPage = 1;
    }
  }

  let isLoading = true;

  onMount(async () => {
    try {
      await storeManager.syncStores();
      
      let team = $fantasyTeam;
      teamPlayerCounts = countPlayersByTeam(team?.playerIds ?? []);
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching add player data." },
        err: error,
      });
      console.error("Error fetching add player data:", error);
    } finally {
      isLoading = false;
    }
  });

  function countPlayersByTeam(playerIds: Uint16Array | number[]) {
    const counts: Record<number, number> = {};
    playerIds.forEach((playerId) => {
      const player = $playerStore.find((p) => p.id === playerId);
      if (player) {
        if (!counts[player.clubId]) {
          counts[player.clubId] = 0;
        }
        counts[player.clubId]++;
      }
    });
    return counts;
  }

  function reasonToDisablePlayer(player: PlayerDTO): string | null {
    const teamCount = teamPlayerCounts[player.clubId] || 0;
    if (teamCount >= 2) return "Max 2 Per Team";

    let team = $fantasyTeam;

    const canAfford = $bankBalance >= player.valueQuarterMillions;
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
        const teamPlayer = $playerStore.find((p) => p.id === id);
        if (teamPlayer) {
          positionCounts[convertPlayerPosition(teamPlayer.position)]++;
        }
      });

    positionCounts[convertPlayerPosition(player.position)]++;

    const isFormationValid = Object.keys(allFormations).some((formation) => {
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
      const team = $clubStore.find((t) => t.id === player.clubId);
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

  function normalizeString(str: string) {
    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
  }
</script>

<Modal {visible} on:nnsClose={closeAddPlayerModal}>
  <div class="p-2">
    <div class="flex justify-between items-center">
      <h3 class="default-header">Select Player</h3>
      <button class="times-button" on:click={closeAddPlayerModal}
        >&times;</button
      >
    </div>
    <div>
      <div class="grid grid-cols-2 gap-1">
        <div>
          <label for="filterTeam">Filter by Team:</label>
          <select
            id="filterTeam"
            class="mt-1 block w-full py-2 text-white fpl-dropdown bigger-text"
            bind:value={filterTeam}
          >
            <option value={-1}>All</option>
            {#each $clubStore as team}
              <option value={team.id}>{team.friendlyName}</option>
            {/each}
          </select>
        </div>
        <div>
          <label for="filterPosition">Filter by Position:</label>
          <select
            id="filterPosition"
            class="mt-1 block w-full py-2 text-white fpl-dropdown"
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

      <div class="grid grid-cols-2 gap-4 my-2">
        <div>
          <label for="minValue">Min Value:</label>
          <input
            id="minValue"
            type="number"
            class="mt-1 block w-full p-2 bg-gray-700 text-white fpl-dropdown"
            bind:value={minValue}
          />
        </div>
        <div>
          <label for="maxValue">Max Value:</label>
          <input
            id="maxValue"
            type="number"
            class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md fpl-dropdown"
            bind:value={maxValue}
          />
        </div>
      </div>

      <div class="my-4">
        <label for="filterSurname">Search by Name:</label>
        <input
          id="filterSurname"
          type="text"
          class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
          placeholder="Enter"
          bind:value={filterSurname}
        />
      </div>

      <div class="my-4">
        <label for="bankBalance"
          >Available Balance: <b>£{($bankBalance / 4).toFixed(2)}m</b></label
        >
      </div>
    </div>

    <div class="overflow-x-auto flex-1">
      <div
        class="flex justify-between border border-gray-700 py-2 bg-light-gray border-b border-gray-700"
      >
        <div class="w-1/12 text-center">Pos</div>
        <div class="w-2/12">Player</div>
        <div class="w-2/12">Team</div>
        <div class="w-2/12">Value</div>
        <div class="w-1/12">PTS</div>
        <div class="w-3/12">&nbsp</div>
      </div>

      {#each paginatedPlayers as player, index}
        <div
          class="flex items-center justify-between py-2 border-b border-gray-700 cursor-pointer"
        >
          <div class="w-1/12 text-center">
            {#if Object.keys(player.position).includes("Goalkeeper")}GK{/if}
            {#if Object.keys(player.position).includes("Defender")}DF{/if}
            {#if Object.keys(player.position).includes("Midfielder")}MF{/if}
            {#if Object.keys(player.position).includes("Forward")}FW{/if}
          </div>

          <div class="w-2/12">
            {`${
              player.firstName.length > 0
                ? player.firstName.charAt(0) + "."
                : ""
            } ${player.lastName}`}
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
          <div class="w-2/12">
            £{(player.valueQuarterMillions / 4).toFixed(2)}m
          </div>
          <div class="w-1/12">{player.totalPoints}</div>
          <div class="w-3/12 flex justify-center items-center">
            {#if disableReasons[index]}
              <span class="text-xxs text-center">{disableReasons[index]}</span>
            {:else}
              <button
                on:click={() => selectPlayer(player)}
                class="rounded fpl-button flex items-center"
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
            class={`px-4 py-2 rounded-md ${
              index + 1 === currentPage ? "fpl-button" : ""
            }`}
            on:click={() => goToPage(index + 1)}
          >
            {index + 1}
          </button>
        {/each}
      </div>
    </div>
  </div>
</Modal>

<style>
  .active {
    background-color: #2ce3a6;
    color: white;
  }
</style>
