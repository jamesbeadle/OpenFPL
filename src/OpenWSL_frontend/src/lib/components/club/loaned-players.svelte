<script lang="ts">
  import { onMount } from "svelte";
  import { toastsError } from "$lib/stores/toasts-store";
  import {
    convertPlayerPosition,
    getPositionText,
  } from "../../utils/helpers";
  import type { PlayerDTO } from "../../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import { playerStore } from "$lib/stores/player-store";
  import { Position } from "$lib/enums/Position";
  import { storeManager } from "$lib/managers/store-manager";

  export let clubId: number | null = null;

  let loanedPlayers: PlayerDTO[] = [];
  
  let selectedPosition = -1;

  $: loanedPlayers =
  selectedPosition === -1
    ? loanedPlayers
    : loanedPlayers.filter(
        (p) => convertPlayerPosition(p.position) === selectedPosition
      );

  onMount(async () => {
    try {
      await storeManager.syncStores();

      if(clubId){
          loanedPlayers = await playerStore.getLoanedPlayers(clubId);
      }
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching loaned players." },
        err: error,
      });
      console.error("Error fetching loaned players:", error);
    } finally {
    }
  });

  let positionValues: number[] = Object.values(Position).filter(
      (value) => typeof value === "number"
  ) as number[];
</script>

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
              <option value={position}>{getPositionText(position)}</option>
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
