<script lang="ts">
    import { onMount } from "svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { playerStore } from "$lib/stores/player-store";
    import { toasts } from "$lib/stores/toasts-store";

    import { Position } from "$lib/enums/Position";
    import type { PlayerDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import {
      convertPositionToIndex,
      getPositionIndexToText,
    } from "../../utils/helpers";
    import WidgetSpinner from "../shared/widget-spinner.svelte";
  
    export let clubId: number | null = null;
  
    let loanedPlayers: PlayerDTO[] = [];
    let selectedPosition = -1;
  
    $: loanedPlayers = selectedPosition === -1 
      ? loanedPlayers 
      : loanedPlayers.filter((p) => convertPositionToIndex(p.position) === selectedPosition);

    let isLoading = true;

    onMount(async () => {
      try {
        console.log("Loading loaned players");
        await storeManager.syncStores();
        if(clubId){
          loanedPlayers = await playerStore.getLoanedPlayers(clubId);
        }
      } catch (error) {
        toasts.addToast({
          message: "Error fetching loaned players.",
          type: "error"
        });
        console.error("Error fetching loaned players:", error);
      } finally {
        isLoading = false;
      }
    });

    let positionValues: number[] = Object.values(Position).filter(
        (value) => typeof value === "number"
    ) as number[];

  </script>

  {#if isLoading}
    <WidgetSpinner />
  {:else}
    <div class="flex flex-col space-y-4">
      <div>
          <div class="flex p-4">
            <div class="flex items-center">
              <p>Position:</p>
              <select
                class="px-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
                bind:value={selectedPosition}
              >
                <option value={-1}>All</option>
                {#each positionValues as position}
                  <option value={position}>{getPositionIndexToText(position)}</option>
                {/each}
              </select>
            </div>
          </div>
        <div
          class="flex justify-between p-2 border-b border-gray-700 py-4 bg-light-gray px-4"
        >
          <div class="hidden md:flex flex-grow w-1/6 md:ml-4">Gameweek</div>
          <div class="md:hidden flex-grow w-1/6 md:ml-4">GW</div>
          <div class="flex-grow w-1/3">Game</div>
          <div class="flex-grow w-1/3">Date</div>
          <div class="hidden md:flex flex-grow w-1/4 text-center">Time</div>
          <div class="flex-grow w-1/3">Teams</div>
          <div class="flex-grow w-1/6 md:w-1/4 md:mr-4">Result</div>
        </div>
    
        {#each loanedPlayers as player}
          <div>
              <p>{`${
                  player.firstName.length > 0
                    ? player.firstName.charAt(0) + "."
                    : ""
                } ${player.lastName}`}</p>
          </div>
        {/each}
      </div>
    </div>
  {/if}