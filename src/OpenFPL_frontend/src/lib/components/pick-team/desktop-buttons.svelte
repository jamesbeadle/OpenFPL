<script lang="ts">
    import type { Writable } from "svelte/store";
    import { leagueStore } from "$lib/stores/league-store";
    import type { PickTeamDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let pitchViewActive: Writable<boolean>;
    export let selectedFormation: Writable<string>;
    export let availableFormations: Writable<string[]>;
    export let transferWindowPlayed: Writable<boolean>;
    export let isSaveButtonActive: Writable<boolean>;
    export let fantasyTeam: Writable<PickTeamDTO>;
    export let showPitchView : () => void;
    export let showListView : () => void;
    export let playTransferWindow : () => void;
    export let autoFillFantasyTeam : () => void;
    export let saveFantasyTeam : () => void;
    
</script>
<div class="flex flex-row justify-between items-center text-white bg-panel p-2 rounded-md w-full mb-4">
      
    <div class="flex flex-row justify-between md:justify-start flex-grow ml-4">
      <button class={`btn ${ $pitchViewActive ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-l-md`} on:click={showPitchView}>
        Pitch View
      </button>
      <button class={`btn ${ !$pitchViewActive ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-r-md`} on:click={showListView}>
        List View
      </button>
    </div>

    <div class="text-center md:text-left w-full mt-0 md:ml-8 order-2 mt-4 md:mt-0">
      <span class="text-lg">
        Formation:
        <select class="px-4 py-2 border-sm fpl-dropdown text-center" bind:value={$selectedFormation}>
          {#each $availableFormations as formation}
            <option value={formation}>{formation}</option>
          {/each}
        </select>
      </span>
    </div>

    <div class="flex flex-col md:flex-row w-full md:justify-end gap-4 mr-0 md:mr-4 order-1 md:order-3 mt-2 md:mt-0">
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
              ? "bg-BrandPurple"
              : "bg-gray-500"
          } text-white min-w-[125px]`}
      >
        Auto Fill
      </button>
      <button
        disabled={!$isSaveButtonActive}
        on:click={saveFantasyTeam}
        class={`btn w-full md:w-auto px-4 py-2 rounded ${
          $isSaveButtonActive ? "bg-BrandPurple" : "bg-gray-500"
        } text-white min-w-[125px]`}
      >
        Save Team
      </button>
    </div>
  </div>