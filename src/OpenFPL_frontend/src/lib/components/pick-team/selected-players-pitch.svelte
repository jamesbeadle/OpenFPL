<script lang="ts">
    import { onMount } from "svelte";
    import type { Writable } from "svelte/store";
    import { playerStore } from "$lib/stores/player-store";
    import { clubStore } from "$lib/stores/club-store";
    import AddPlayerIcon from "$lib/icons/AddPlayerIcon.svelte";
    import { getGridSetup } from "$lib/utils/pick-team.helpers";
    import type { PickTeamDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { getActualIndex } from "$lib/utils/helpers";
    import WidgetSpinner from "../shared/widget-spinner.svelte";
    import SponsorshipBoard from "./sponsorship-board.svelte";
    import PitchPlayer from "./pitch-player.svelte";

    export let selectedFormation: Writable<string>;
    export let fantasyTeam: Writable<PickTeamDTO>;
    export let loadAddPlayer: (row: number, col: number) => void;
    export let canSellPlayer: Writable<boolean>;
    export let sessionAddedPlayers: Writable<number[]>;
    export let removePlayer: (playerId: number) => void;
    export let setCaptain: (playerId: number) => void;

    let loadingPitchSetup = true;
    let pitchHeight = 0;
    let pitchElement: HTMLElement;

    $: rowHeight = (pitchHeight * 0.9) / 4;
    $: gridSetupComplete = rowHeight > 0;
    $: gridSetup = getGridSetup($selectedFormation);
    
    onMount(async () => {
        if (typeof window !== "undefined") {
            window.addEventListener("resize", updatePitchHeight);
            updatePitchHeight();
        }
        loadingPitchSetup = false;
    });

    function updatePitchHeight() {
        if (!pitchElement) {
            return;
        }
        pitchHeight = pitchElement.clientHeight;
    }

</script>
{#if gridSetupComplete}
    <div class="relative w-full xl:w-1/2 mt-2">
      <img src="/pitch.png" alt="pitch" class="w-full h-auto" on:load={updatePitchHeight} bind:this={pitchElement} />
      {#if loadingPitchSetup}
        <div class="absolute top-0 left-0 right-0 bottom-0">
          <div class={`flex justify-around w-full h-auto`}>
            <SponsorshipBoard />
            <SponsorshipBoard />
          </div>
          {#each gridSetup as row, rowIndex}
            <div class="flex justify-around items-center w-full" style="height: {rowHeight}px;">
              {#each row as _, colIndex (colIndex)}
                {@const actualIndex = getActualIndex(rowIndex, colIndex, gridSetup)}
                {@const playerIds = $fantasyTeam?.playerIds ?? []}
                {@const playerId = playerIds[actualIndex]}
                {@const player = $playerStore.find((p) => p.id === playerId)}
                <div class="flex flex-col justify-center items-center flex-1 player-card">
                  {#if playerId > 0 && player}
                    {@const team = $clubStore.find((x) => x.id === player.clubId)}
                    <PitchPlayer {fantasyTeam} {player} club={team!} {canSellPlayer} {sessionAddedPlayers} {removePlayer} {setCaptain} />
                  {:else}
                    <button on:click={() => loadAddPlayer(rowIndex, colIndex)} class="flex items-center" >
                      <AddPlayerIcon className="h-12 sm:h-16 md:h-20 lg:h-24 xl:h-16 2xl:h-20" />
                    </button>
                  {/if}
                </div>
              {/each}
            </div>
          {/each}
        </div>
      {/if}
    </div>
{:else}
    <WidgetSpinner />
{/if}