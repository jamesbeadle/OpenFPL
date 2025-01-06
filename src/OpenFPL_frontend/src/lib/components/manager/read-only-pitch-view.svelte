<script lang="ts">
  import { onMount, tick } from "svelte";
  import { browser } from "$app/environment";
  import { type Writable } from "svelte/store";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { clubStore } from "$lib/stores/club-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { getActualIndex } from "$lib/utils/helpers";
  import { calculateBonusPoints, getGridSetup, getTeamFormationReadOnly, sortPlayersByPointsThenValue } from "$lib/utils/pick-team.helpers";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import type { FantasyTeamSnapshot, GameweekNumber } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import ManagerPitchPlayer from "./manager-pitch-player.svelte";
  import { playerStore } from "$lib/stores/player-store";
  import WidgetSpinner from "../shared/widget-spinner.svelte";

  export let fantasyTeam: Writable<FantasyTeamSnapshot | null>;
  export let gridSetup: number[][];
  export let gameweekPlayers: Writable<GameweekData[]>;
  export let selectedGameweek: Writable<GameweekNumber>;
  
  let pitchHeight = 0;
  let pitchElement: HTMLImageElement | null = null;
  let isLoading = true;

  $: rowHeight = (pitchHeight * 0.9) / 4;
  $: gridSetup = getGridSetup( getTeamFormationReadOnly($fantasyTeam!, $playerStore));

  $: if ($fantasyTeam || $selectedGameweek > 0) {
    updateGameweekPlayers();
  }

  onMount(async () => {
    if (!browser) return;
    await tick();
    measurePitch();
    window.addEventListener("resize", measurePitch);
  });

function onPitchLoad() {
  measurePitch();
}

function measurePitch() {
  if (!pitchElement) return;
  pitchHeight = pitchElement.clientHeight;
}

async function updateGameweekPlayers() {
  try {
    if (!$fantasyTeam) { gameweekPlayers.set([]); return; }
    let fetchedPlayers = await playerEventsStore.getGameweekPlayers(
      $fantasyTeam!,
      $leagueStore!.activeSeasonId,
      $selectedGameweek!
    );
    calculateBonusPoints(fetchedPlayers, $fantasyTeam);
    sortPlayersByPointsThenValue(fetchedPlayers);
    gameweekPlayers.set(fetchedPlayers);
  } catch (error) {
    toasts.addToast({ type: "error", message: "Error updating gameweek players." });
    console.error("Error updating gameweek players:", error);
  } finally {
    isLoading = false;
  }
}
</script>
<div class="relative w-full mt-2">
  <img 
    src="/pitch.png" 
    alt="pitch" 
    class="w-full h-auto" 
    bind:this={pitchElement}
    on:load={onPitchLoad} 
  />
  {#if isLoading}
    <WidgetSpinner />
  {:else}
    {#if gridSetup && rowHeight}
      <div class="absolute top-0 left-0 right-0 bottom-0">
        {#each gridSetup as row, rowIndex}
          <div class="flex justify-around items-center w-full" style="height: {rowHeight}px;">
            {#each row as _, colIndex (colIndex)}
              {@const actualIndex = getActualIndex(rowIndex, colIndex, gridSetup)}
              {@const playerIds = $fantasyTeam?.playerIds ?? []}
              {@const playerId = playerIds[actualIndex]}
              {@const playerData = $gameweekPlayers.find((data) => data.player.id === playerId) ?? null}
              {@const clubData = $clubStore.find((club) => club.id === playerData?.player.clubId) ?? null}

              <div class="flex flex-col justify-center items-center flex-1 player-card">
                {#if playerData && clubData}
                  <ManagerPitchPlayer {playerData} {clubData} />
                {/if}
              </div>
            {/each}
          </div>
        {/each}
      </div>
    {/if}
  {/if}
</div>