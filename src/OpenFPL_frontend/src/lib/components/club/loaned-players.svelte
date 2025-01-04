<script lang="ts">
  import { onMount } from "svelte";
  import { writable } from "svelte/store";
  import { storeManager } from "$lib/managers/store-manager";
  import { playerStore } from "$lib/stores/player-store";
  import type { PlayerDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { convertPositionToIndex, getPlayerName } from "../../utils/helpers";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import PositionFilter from "../shared/position-filter.svelte";

  export let clubId: number | null = null;

  let isLoading = true;
  let loanedPlayers: PlayerDTO[] = [];
  let selectedPosition = writable(-1);

  $: loanedPlayers = $selectedPosition === -1 
    ? loanedPlayers 
    : loanedPlayers.filter((p) => convertPositionToIndex(p.position) === $selectedPosition);

  onMount(async () => {
    
    await storeManager.syncStores();
    if(clubId){
      let loanedPlayersResult = await playerStore.getLoanedPlayers(clubId);
      loanedPlayers = loanedPlayersResult ? loanedPlayersResult : loanedPlayers;
    }
    isLoading = false;
  });
</script>

{#if isLoading}
  <WidgetSpinner />
{:else}
  <div class="flex flex-col">
    <div>
      <PositionFilter {selectedPosition} />
      <div class="flex justify-between p-2 border-b border-gray-700 py-4 bg-light-gray px-4">
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
            <p>{getPlayerName(player)}</p>
        </div>
      {/each}
    </div>
  </div>
{/if}