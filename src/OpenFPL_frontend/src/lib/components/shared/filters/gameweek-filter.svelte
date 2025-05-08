<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import { getGameweeks } from "$lib/utils/Helpers";
    import { onMount } from "svelte";
    import LocalSpinner from "../global/local-spinner.svelte";

    interface Props {
      selectedGameweek: number | null;
    }
    let { selectedGameweek }: Props = $props();

    let isLoading = $state(true);
    let gameweeks: number[] = $state([]);
    let lastGameweek: number = $state(0);


    onMount(async () => {
      try{
        gameweeks = getGameweeks($leagueStore?.totalGameweeks ?? 0);
        lastGameweek = $leagueStore?.totalGameweeks ?? 0;
      } catch {

      } finally {
        isLoading = false;
      }
    });
</script>
{#if isLoading}
  <LocalSpinner />
{:else}


<div class="flex w-full flex-col">
  <p class="input-header">Select Gameweek:</p>
  <div class="flex items-center">
    <button
      class={`${ selectedGameweek === 1 ? "inactive-fpl-button" : "fpl-button" } default-button mr-1`}
      onclick={() => {selectedGameweek && selectedGameweek > 0 ? selectedGameweek - 1 : selectedGameweek}}
      disabled={selectedGameweek === 1}
    >
      &lt;
    </button>
    <select
      class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[125px]"
      value={selectedGameweek}
    >
      {#each gameweeks as gameweek}
        <option value={gameweek}>Gameweek {gameweek}</option>
      {/each}
    </select>
    <button
      class={`${ selectedGameweek === lastGameweek ? "inactive-fpl-button" : "fpl-button" } default-button ml-3`}
      onclick={() => {selectedGameweek && selectedGameweek < lastGameweek ? selectedGameweek + 1 : selectedGameweek}}
      disabled={selectedGameweek === lastGameweek}
    >
      &gt;
    </button>
  </div>
</div>



{/if}