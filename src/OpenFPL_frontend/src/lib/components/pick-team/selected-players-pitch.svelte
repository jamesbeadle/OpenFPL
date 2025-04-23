<script lang="ts">
  import { onMount, tick } from "svelte";
  import { browser } from "$app/environment";

  import { playerStore } from "$lib/stores/player-store";
  import { clubStore } from "$lib/stores/club-store";
  import AddPlayerIcon from "$lib/icons/AddPlayerIcon.svelte";
  import { getGridSetup } from "$lib/utils/pick-team.helpers";
  import { getActualIndex } from "$lib/utils/helpers";
  import SponsorshipBoard from "./sponsorship-board.svelte";
  import PitchPlayer from "./pitch-player.svelte";
  import LocalSpinner from "../shared/local-spinner.svelte";
  import type { TeamSetup } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  interface Props {
    selectedFormation: string;
    fantasyTeam: TeamSetup | undefined;
    loadAddPlayer: (row: number, col: number) => void;
    canSellPlayer: boolean;
    sessionAddedPlayers: number[];
    removePlayer: (playerId: number) => void;
    setCaptain: (playerId: number) => void;
  }
  let { selectedFormation, fantasyTeam, loadAddPlayer, canSellPlayer, sessionAddedPlayers, removePlayer, setCaptain }: Props = $props();
  
  
  let pitchHeight = $state(0);
  let pitchElement: HTMLImageElement | null = null;
  let rowHeight = $state(0);
  let gridSetup: number[][] = $state([]);

  $effect(() => {
    rowHeight = (pitchHeight * 0.9) / 4;
    gridSetup = getGridSetup(selectedFormation);
  });

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

  function canShowOverlay() {
    return rowHeight > 0;
  }
</script>

<div class="relative w-full mt-2">
  <img
    src="/pitch.png"
    alt="pitch"
    class="w-full h-auto"
    this={pitchElement}
    onload={onPitchLoad}
  />
  {#if canShowOverlay()}
    <div class="absolute top-0 bottom-0 left-0 right-0">
      <div class="flex justify-around w-full h-auto">
        <SponsorshipBoard />
        <SponsorshipBoard />
      </div>

      {#each gridSetup as row, rowIndex}
        <div
          class="flex items-center justify-around w-full"
          style="height: {rowHeight}px;"
        >
          {#each row as _, colIndex (colIndex)}
            {@const actualIndex = getActualIndex(rowIndex, colIndex, gridSetup)}
            {@const playerIds = fantasyTeam?.playerIds ?? []}
            {@const playerId = playerIds[actualIndex]}
            {@const player = $playerStore.find((p) => p.id === playerId)}

            <div class="flex flex-col items-center justify-center flex-1 player-card">
              {#if playerId > 0 && player}
                {@const team = $clubStore.find((x) => x.id === player.clubId)}
                <PitchPlayer
                  {fantasyTeam}
                  {player}
                  club={team!}
                  {canSellPlayer}
                  {sessionAddedPlayers}
                  {removePlayer}
                  {setCaptain}
                />
              {:else}
                <button
                  onclick={() => loadAddPlayer(rowIndex, colIndex)}
                  class="flex items-center"
                >
                  <AddPlayerIcon
                    primaryColour='white'
                    secondaryColour='white'
                    thirdColour='white'
                    className="h-12 sm:h-16 md:h-20 lg:h-24 xl:h-16 2xl:h-20"
                  />
                </button>
              {/if}
            </div>
          {/each}
        </div>
      {/each}
    </div>
  {:else}
    <LocalSpinner />
  {/if}
</div>