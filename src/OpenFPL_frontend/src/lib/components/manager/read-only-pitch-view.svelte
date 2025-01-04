<script lang="ts">
  import { onMount } from "svelte";
  import { type Writable } from "svelte/store";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { clubStore } from "$lib/stores/club-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { getActualIndex } from "$lib/utils/helpers";
  import { calculateBonusPoints, sortPlayersByPointsThenValue } from "$lib/utils/pick-team.helpers";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import type { FantasyTeamSnapshot, GameweekNumber } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import ManagerPitchPlayer from "./manager-pitch-player.svelte";

  export let fantasyTeam: Writable<FantasyTeamSnapshot | null>;
  export let gridSetup: number[][];
  export let gameweekPlayers: Writable<GameweekData[]>;
  export let selectedGameweek: Writable<GameweekNumber>;
  
  let pitchHeight = 0;
  let pitchElement: HTMLElement;
  let isLoading = false;

  $: rowHeight = (pitchHeight * 0.9) / 4;
  $: gridSetupComplete = rowHeight > 0;
  $: if ($fantasyTeam && $selectedGameweek && $selectedGameweek > 0) {
    updateGameweekPlayers();
  }

  onMount(async () => {
    if (typeof window !== "undefined") {
      window.addEventListener("resize", updatePitchHeight);
      updatePitchHeight();
    }
    gridSetupComplete = true;
  });

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

  function updatePitchHeight() {
    if (!pitchElement) {
      return;
    }
    pitchHeight = pitchElement.clientHeight;
  }
</script>
  
{#if isLoading}
  <WidgetSpinner />
{:else}
  <div class="relative w-full mt-2">
    {#if gridSetupComplete}
      <img src="/pitch.png" alt="pitch" class="w-full h-auto" on:load={updatePitchHeight} bind:this={pitchElement} />
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
{/if}