<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from '$lib/stores/toasts-store';
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import {
    getFlagComponent,
    getPositionAbbreviation,
  } from "$lib/utils/Helpers";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import type {
    FantasyTeam,
    SystemState,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import { writable, type Writable } from "svelte/store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";

  export let teams = writable<Team[] | []>([]);
  export let players = writable<PlayerDTO[] | []>([]);
  export let systemState = writable<SystemState | null>(null);

  let unsubscribeSystemState: () => void;
  let unsubscribeTeams: () => void;
  let unsubscribePlayers: () => void;

  let gameweekPlayers: GameweekData[] = [];
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  export let selectedGameweek: number;
  export let fantasyTeam: Writable<FantasyTeam | null>;

  onMount(async () => {
    try {
      await systemStore.sync();
      await teamStore.sync();
      await playerStore.sync();
      await playerEventsStore.sync();

      unsubscribeSystemState = systemStore.subscribe((value) => {
        systemState.set(value);
      });

      unsubscribeTeams = teamStore.subscribe((value) => {
        teams.set(value);
      });

      unsubscribePlayers = playerStore.subscribe((value) => {
        players.set(value);
      });
    } catch (error) {
      toastsError({
				msg: { text: 'Error fetching manager gameweek detail.' },
				err: error
			});
      console.error("Error fetching manager gameweek detail:", error);
    }
  });

  $: {
    if ($systemState) {
      selectedGameweek = $systemState?.activeGameweek ?? selectedGameweek;
    }
  }

  $: if ($fantasyTeam) {
    updateGameweekPlayers();
  }

  async function updateGameweekPlayers() {
    try {
      gameweekPlayers = await playerEventsStore.getGameweekPlayers(
        $fantasyTeam!,
        selectedGameweek
      );
    } catch (error) {
      toastsError({
				msg: { text: 'Error updating gameweek players.' },
				err: error
			});
      console.error("Error updating gameweek players:", error);
    }
  }

  onDestroy(() => {
    unsubscribeTeams?.();
    unsubscribePlayers?.();
    unsubscribeSystemState?.();
  });

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  function getPlayerDTO(playerId: number): PlayerDTO | null {
    return $players.find((x) => x.id === playerId) ?? null;
  }

  function getPlayerTeam(teamId: number): Team | null {
    return $teams.find((x) => x.id === teamId) ?? null;
  }
</script>

<div class="mx-5 my-4">
  <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
    <div class="flex items-center space-x-2">
      <button
        class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
        on:click={() => changeGameweek(-1)}
        disabled={selectedGameweek === 1}
      >
        &lt;
      </button>

      <select
        class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]"
        bind:value={selectedGameweek}
      >
        {#each gameweeks as gameweek}
          <option value={gameweek}>Gameweek {gameweek}</option>
        {/each}
      </select>

      <button
        class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
        on:click={() => changeGameweek(1)}
        disabled={selectedGameweek === 38}
      >
        &gt;
      </button>
    </div>
  </div>

  <div class="flex flex-col space-y-4 mt-4 text-lg">
    <div class="overflow-x-auto flex-1">
      <div
        class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
      >
        <div class="w-1/12 text-center mx-4">Position</div>
        <div class="w-2/12">Player</div>
        <div class="w-2/12 text-center">Team</div>
        <div class="w-1/2 flex">
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
        <div
          class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer"
        >
          <div class="w-1/12 text-center mx-4">
            {getPositionAbbreviation(data.player.position)}
          </div>
          <div class="w-2/12">
            <svelte:component
              this={getFlagComponent(playerDTO?.nationality ?? "")}
              class="w-4 h-4 mr-1"
              size="100"
            />
            {playerDTO
              ? playerDTO.firstName.length > 2
                ? playerDTO.firstName.substring(0, 1) + "." + playerDTO.lastName
                : ""
              : ""}
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
          <div class="w-1/2 flex">
            <div
              class={`w-1/12 text-center ${
                data.appearance > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.appearance}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.highestScoringPlayerId === playerDTO?.id
                  ? ""
                  : "text-gray-500"
              }`}
            >
              {data.highestScoringPlayerId === playerDTO?.id ? 1 : 0}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.goals > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.goals}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.assists > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.assists}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.penaltySaves > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.penaltySaves}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.cleanSheets > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.cleanSheets}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.saves > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.saves}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.yellowCards > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.yellowCards}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.ownGoals > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.ownGoals}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.goalsConceded > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.goalsConceded}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.redCards > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.redCards}
            </div>
            <div
              class={`w-1/12 text-center ${
                data.bonusPoints > 0 ? "" : "text-gray-500"
              }`}
            >
              {data.bonusPoints}
            </div>
          </div>
          <div class="w-1/12 text-center">{data.points}</div>
        </div>
      {/each}
    </div>
  </div>
</div>
