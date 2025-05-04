<script lang="ts">
  import { playerStore } from "$lib/stores/player-store";
  import { countryStore } from "$lib/stores/country-store";
  import { getBonusIcon, getFlagComponent, getPlayerName } from "$lib/utils/Helpers";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import type { Manager } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  interface Props {
    manager: Manager | null;
    viewGameweekDetail: (selectedGameweek: number) => void;
  }
  let { manager, viewGameweekDetail }: Props = $props();
  
</script>

<div class="flex flex-col">
  <div class="overflow-x-auto flex-1">
    <div
      class="flex justify-between p-2 md:px-4 border border-gray-700 py-4 bg-light-gray"
    >
      <div class="w-2/12">GW</div>
      <div class="w-4/12 md:hidden">Cap.</div>
      <div class="w-4/12 hidden md:flex">Captain</div>
      <div class="w-3/12">Bonus</div>
      <div class="w-2/12">Points</div>
      <div class="w-3/12">&nbsp;</div>
    </div>
    {#if manager && manager.gameweeks}
      {#each manager.gameweeks as gameweek}
        {@const captain = $playerStore.find((x) => x.id === gameweek.captainId)}
        {@const playerCountry = $countryStore
          ? $countryStore.find((x) => x.id === captain?.nationality)
          : null}
        <button
          class="w-full"
          onclick={() => viewGameweekDetail(gameweek.gameweek)}
        >
          <div
            class="flex items-center text-left justify-between p-2 md:px-4 py-4 border-b border-gray-700 cursor-pointer"
          >
            <div class="w-2/12">{gameweek.gameweek}</div>
            <div class="w-4/12 flex items-center">
              {#if captain?.nationality! > 0}
                  {@const flag = getFlagComponent(captain?.nationality!)}
                  <flag class="w-12 h-12 xs:w-16 xs:h-16"></flag>
              {/if}
              <p class="truncate min-w-[40px] max-w-[40px] xxs:min-w-[80px] xxs:max-w-[80px] sm:min-w-[160px] sm:max-w-[160px] md:min-w-none md:max-w-none">
                { getPlayerName(captain!) }
              </p>
            </div>
            <div class="w-3/12">{@html getBonusIcon(gameweek)}</div>
            <div class="w-2/12">{gameweek.points}</div>
            <div class="w-3/12 flex items-center">
              <span class="flex items-center">
                <ViewDetailsIcon className="w-4 mr-1 md:w-6 md:mr-2" />
                <p class="tiny-text hidden md:flex">View Details</p>
                <p class="tiny-text md:hidden">View</p>
              </span>
            </div>
          </div>
        </button>
      {/each}
    {/if}
  </div>
</div>