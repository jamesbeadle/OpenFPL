<script lang="ts">
    import type { Writable } from "svelte/store";
    import { leagueStore } from "$lib/stores/league-store";
    import type { TeamSelectionDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let pitchViewActive: Writable<boolean>;
    export let selectedFormation: Writable<string>;
    export let availableFormations: Writable<string[]>;
    export let transferWindowPlayed: Writable<boolean>;
    export let isSaveButtonActive: Writable<boolean>;
    export let fantasyTeam: Writable<TeamSelectionDTO | undefined>;
    export let showPitchView : () => void;
    export let showListView : () => void;
    export let playTransferWindow : () => void;
    export let autoFillFantasyTeam : () => void;
    export let saveFantasyTeam : () => void;
    export let handleResetTeam: () => void;
    export let startingFantasyTeam: TeamSelectionDTO;
    
    $: showResetButton = $fantasyTeam?.playerIds && startingFantasyTeam?.playerIds && (
      (startingFantasyTeam.playerIds.filter(id => id > 0).length === 11 && 
       $fantasyTeam.playerIds.filter(id => id > 0).length < startingFantasyTeam.playerIds.filter(id => id > 0).length) ||
      !$fantasyTeam.playerIds.every((id, index) => id === startingFantasyTeam.playerIds[index])
    );
</script>
<div class="flex flex-row items-center justify-between w-full p-2 mb-4 text-white rounded-md bg-panel">
      
    <div class="flex flex-row justify-between flex-grow ml-4 md:justify-start">
      <button class={`btn ${ $pitchViewActive ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-l-md`} on:click={showPitchView}>
        Pitch View
      </button>
      <button class={`btn ${ !$pitchViewActive ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-r-md`} on:click={showListView}>
        List View
      </button>
    </div>

    <div class="order-2 w-full mt-0 mt-4 text-center md:text-left md:ml-8 md:mt-0">
      <span class="text-lg">
        Formation:
        <select class="px-4 py-2 text-center border-sm fpl-dropdown" bind:value={$selectedFormation}>
          {#each $availableFormations as formation}
            <option value={formation}>{formation}</option>
          {/each}
        </select>
      </span>
    </div>

    <div class="flex flex-col order-1 w-full gap-4 mt-2 mr-0 md:flex-row md:justify-end md:mr-4 md:order-3 md:mt-0">
      {#if $leagueStore!.transferWindowActive && $leagueStore!.seasonActive && $leagueStore!.activeMonth == 1}
        <button
          disabled={$transferWindowPlayed}
          on:click={playTransferWindow}
          class={`btn w-full md:w-auto px-4 py-2 rounded  
            ${
              !$transferWindowPlayed ? "bg-BrandPurple" : "bg-gray-500"
            } text-white min-w-[125px]`}
        >
          Use Transfer Window Bonus
        </button>
      {/if}
      <button
        disabled={$fantasyTeam?.playerIds
          ? $fantasyTeam?.playerIds.filter((x) => x === 0).length === 0
          : true}
        on:click={autoFillFantasyTeam}
        class={`btn w-full md:w-auto px-4 py-2 rounded  
          ${
            $fantasyTeam?.playerIds &&
            $fantasyTeam?.playerIds.filter((x) => x === 0).length > 0
              ? "bg-BrandPurple hover:bg-BrandPurple/90"
              : "bg-gray-500"
          } text-white min-w-[125px]`}
      >
        Auto Fill
      </button>
      {#if showResetButton}
        <button
          on:click={handleResetTeam}
          class="btn w-full md:w-auto px-4 py-2 rounded bg-BrandRed hover:bg-BrandRed/90 text-white min-w-[125px]"
        >
          Reset Team
        </button>
      {/if}
      <button
        disabled={!$isSaveButtonActive}
        on:click={saveFantasyTeam}
        class={`btn w-full md:w-auto px-4 py-2 rounded ${
          $isSaveButtonActive ? "bg-BrandPurple hover:bg-BrandPurple/90" : "bg-gray-500"
        } text-white min-w-[125px]`}
      >
        Save Team
      </button>
    </div>
  </div>