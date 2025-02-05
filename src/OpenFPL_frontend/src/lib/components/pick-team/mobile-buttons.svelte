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
    
</script>
<div class="bg-panel xs:flex flex-row">
    <div class="w-full xs:w-1/2">
      <div class="flex flex-row ml-4" style="margin-top: 2px;">
        <button
          class={`btn ${
            $pitchViewActive ? `fpl-button` : `inactive-btn`
          } rounded-l-md tab-switcher-label`}
          on:click={showPitchView}
        >
          Pitch View
        </button>
        <button
          class={`btn ${
            !$pitchViewActive ? `fpl-button` : `inactive-btn`
          } rounded-r-md tab-switcher-label`}
          on:click={showListView}
        >
          List View
        </button>
      </div>
    </div>
    <div class="w-full xs:w-1/2">
      <div class="flex flex-row items-center mx-4 mt-3">
        <p class="mr-2">Formation:</p>
        <select
          class="px-4 xs:mb-1 border-sm fpl-dropdown text-center text-center w-full"
          bind:value={$selectedFormation}
        >
          {#each $availableFormations as formation}
            <option value={formation}>{formation}</option>
          {/each}
        </select>
      </div>
      <div class="flex flex-row mx-4 space-x-1">
        <button
          disabled={$fantasyTeam?.playerIds
            ? $fantasyTeam?.playerIds.filter((x) => x === 0).length === 0
            : true}
          on:click={autoFillFantasyTeam}
          class={`side-button-base  
            ${
              $fantasyTeam?.playerIds &&
              $fantasyTeam?.playerIds.filter((x) => x === 0).length > 0
                ? "bg-BrandPurple"
                : "bg-gray-500"
            } text-white`}
        >
          Auto Fill
        </button>
        <button
          disabled={!$isSaveButtonActive}
          on:click={saveFantasyTeam}
          class={`side-button-base ${
            $isSaveButtonActive ? "bg-BrandPurple" : "bg-gray-500"
          } text-white`}
        >
          Save
        </button>
      </div>
      {#if $leagueStore!.transferWindowActive && $leagueStore!.seasonActive && $leagueStore!.activeMonth == 1}
        <div class="flex flex-row mx-4 space-x-1 mb-4">
          <button
            disabled={$transferWindowPlayed}
            on:click={playTransferWindow}
            class={`btn w-full px-4 py-2 rounded  
              ${
                !$transferWindowPlayed ? "bg-BrandPurple" : "bg-gray-500"
              } text-white min-w-[125px]`}
          >
            Use Transfer Window Bonus
          </button>
        </div>
      {/if}
    </div>
  </div>