<script lang="ts">
    
    interface Props {
      selectedGameweek: number | null;
      gameweeks: number[];
      changeGameweek: (gameweek: number) => void;
      lastGameweek: number;
    }
    let { selectedGameweek, gameweeks, changeGameweek, lastGameweek }: Props = $props();

</script>
<div class="p-4">
    <div class="flex flex-col items-center gap-4 sm:flex-row sm:justify-between">
        <div class="flex items-center">
            <button
              class={`${
                $selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
              } default-button mr-1`}
              onclick={() => changeGameweek(-1)}
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
              onclick={() => changeGameweek(1)}
              disabled={$selectedGameweek === lastGameweek}
            >
              &gt;
            </button>
        </div>
    </div>
</div>