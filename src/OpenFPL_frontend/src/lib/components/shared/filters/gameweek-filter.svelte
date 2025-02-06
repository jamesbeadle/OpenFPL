<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import type { Writable } from "svelte/store";
    
    export let selectedGameweek: Writable<number | null>;
    export let gameweeks: number[];
    export let changeGameweek : (gameweek: number) => void;
</script>


<div class="p-4">
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
      {#each gameweeks as gameweek}
        <option value={gameweek}>Gameweek {gameweek}</option>
      {/each}
    </select>
    <button
      class={`${
        $selectedGameweek === ($leagueStore!.activeGameweek == 0 || $leagueStore!.activeGameweek == 38 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek)
          ? "bg-gray-500"
          : "fpl-button"
      } default-button ml-1`}
      on:click={() => changeGameweek(1)}
      disabled={$leagueStore!.activeGameweek == 0 || $leagueStore!.activeGameweek == 38}
    >
      &gt;
    </button>
  </div>