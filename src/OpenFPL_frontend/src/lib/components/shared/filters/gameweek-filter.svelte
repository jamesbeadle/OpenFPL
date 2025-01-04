<script lang="ts">
    import type { Writable } from "svelte/store";
    import type { LeagueStatus } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let selectedGameweek: Writable<number | null>;
    export let gameweeks: number[];
    export let leagueStatus: LeagueStatus;
    export let changeGameweek : (gameweek: number) => void;

</script>


<div class="ml-4 mt-4">
    <button
      class={`${
        $selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
      } default-button mr-1`}
      on:click={() => changeGameweek(-1)}
      disabled={$selectedGameweek === 1}>&lt;</button
    >
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
        $selectedGameweek === (leagueStatus.activeGameweek == 0 ? leagueStatus.unplayedGameweek : leagueStatus.activeGameweek)
          ? "bg-gray-500"
          : "fpl-button"
      } default-button ml-1`}
      on:click={() => changeGameweek(1)}
      disabled={$selectedGameweek === (leagueStatus.activeGameweek == 0 ? leagueStatus.unplayedGameweek : leagueStatus.activeGameweek)}
      >&gt;</button
    >
  </div>