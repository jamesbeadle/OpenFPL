<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import type { Writable } from "svelte/store";
    
    export let selectedGameweek: Writable<number | null>;
    export let gameweeks: number[];
    export let changeGameweek: (gameweek: number) => void;
    export let lastGameweek: number;
    export let weeklyPoints: number | undefined = undefined;
</script>
<div class="p-4">
    <div class="flex flex-col items-center gap-4 sm:flex-row sm:justify-between">
        <div class="flex items-center">
            <button
              class={`${
                $selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
              } default-button mr-1`}
              on:click={() => changeGameweek(-1)}
              disabled={$selectedGameweek === 1}
            >
              &lt;
            </button>
            <select
              class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[125px]"
              bind:value={$selectedGameweek}
            >
              {#each gameweeks.filter(gw => gw <= lastGameweek) as gameweek}
                <option value={gameweek}>Gameweek {gameweek}</option>
              {/each}
            </select>
            <button
              class={`${
                $selectedGameweek === lastGameweek
                  ? "bg-gray-500"
                  : "fpl-button"
              } default-button ml-3`}
              on:click={() => changeGameweek(1)}
              disabled={$selectedGameweek === lastGameweek}
            >
              &gt;
            </button>
        </div>
        {#if weeklyPoints !== undefined}
          <div class="flex items-center gap-2 px-4 py-2 text-lg font-medium rounded-md bg-BrandGray/60">
            <span class="text-gray-300">Total Gameweek Points:</span>
            <span class="text-white">{weeklyPoints}</span>
          </div>
        {/if}
    </div>
</div>