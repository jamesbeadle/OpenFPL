<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import { getGameweeks } from "$lib/utils/helpers";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";

    interface Props {
      selectedGameweek: number | null;
      changeGameweek: (gameweek: number) => void;
      lastGameweek: number;
    }
    let { selectedGameweek, changeGameweek, lastGameweek }: Props = $props();

    let isLoading = $state(true);
    let gameweeks: number[] = $state([]);


    onMount(async () => {
      try{
        gameweeks = getGameweeks($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1);
      } catch {

      } finally {
        isLoading = false;
      }
    });
</script>
{#if isLoading}
  <LocalSpinner />
{:else}
    <div class="p-4">
        <div class="flex flex-col items-center gap-4 sm:flex-row sm:justify-between">
          <div class="flex items-center">
            <button
              class={`${
                selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
              } default-button mr-1`}
              onclick={() => changeGameweek(-1)}
              disabled={selectedGameweek === 1}
            >
              &lt;
            </button>
            <select
              class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[125px]"
              value={selectedGameweek}
            >
              {#each gameweeks.filter(gw => gw <= lastGameweek) as gameweek}
                <option value={gameweek}>Gameweek {gameweek}</option>
              {/each}
            </select>
            <button
              class={`${
                selectedGameweek === lastGameweek
                  ? "bg-gray-500"
                  : "fpl-button"
              } default-button ml-3`}
              onclick={() => changeGameweek(1)}
              disabled={selectedGameweek === lastGameweek}
            >
              &gt;
            </button>
          </div>
      </div>
  </div>
{/if}