<script lang="ts">
    import { onMount } from "svelte";
    import { page } from "$app/state";
    import { playerStore } from "$lib/stores/player-store";
    import { managerStore } from "$lib/stores/manager-store";
    import type { ManagerDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
    import { getBonusIcon, getFlagComponent, getPlayerName } from "$lib/utils/helpers";
    import { countryStore } from "$lib/stores/country-store";
    import { authStore } from "$lib/stores/auth.store";
    import { storeManager } from "$lib/managers/store-manager";
    import { goto } from "$app/navigation";
    import WidgetSpinner from "../shared/widget-spinner.svelte";
    import SortIcon from "$lib/icons/SortIcon.svelte";
  
    export let principalId = "";
    let manager: ManagerDTO;
    let isLoading = true;
    let sortField: 'gameweek' | 'points' = 'gameweek';
    let sortDirection: 'asc' | 'desc' = 'desc';
  
    $: id = page.url.searchParams.get("id") ?? principalId;
    $: sortedGameweeks = manager?.gameweeks ? [...manager.gameweeks].sort((a, b) => {
      const multiplier = sortDirection === 'asc' ? 1 : -1;
      return (a[sortField] - b[sortField]) * multiplier;
    }) : [];
  
    onMount(async () => {
      await storeManager.syncStores();
      if(!id){
        principalId = $authStore?.identity?.getPrincipal().toText() ?? "";
      }
      manager = await managerStore.getPublicProfile(principalId);
      isLoading = false;
    });
  
    function viewGameweekDetail(gameweek: number){
      goto(`/manager?id=${id}&gw=${gameweek}`)
    }

    function toggleSort(field: 'gameweek' | 'points') {
        if (sortField === field) {
            sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
        } else {
            sortField = field;
            sortDirection = 'desc';
        }
    }
</script>
  
{#if isLoading}
  <WidgetSpinner />
{:else}
  <div class="flex flex-col">
    <div class="flex-1 overflow-x-auto">
      <div class="flex justify-between p-2 py-4 border border-gray-700 md:px-4 bg-light-gray">
        <button 
          class="flex items-center w-2/12 cursor-pointer" 
          on:click={() => toggleSort('gameweek')}
        >
          GW
          <SortIcon 
            className="w-2 lg:w-3 ml-1 xxs:ml-2" 
            fill1={sortField === 'gameweek' && sortDirection === 'desc' ? '#2CE3A6' : '#454B56'} 
            fill2={sortField === 'gameweek' && sortDirection === 'asc' ? '#2CE3A6' : '#454B56'} 
          />
        </button>
        <div class="w-4/12 md:hidden">Cap.</div>
        <div class="hidden w-4/12 md:flex">Captain</div>
        <div class="w-3/12">Bonus</div>
        <button 
          class="flex items-center w-2/12 cursor-pointer" 
          on:click={() => toggleSort('points')}
        >
          Points
          <SortIcon 
            className="w-2 lg:w-3 ml-1 xxs:ml-2" 
            fill1={sortField === 'points' && sortDirection === 'desc' ? '#2CE3A6' : '#454B56'} 
            fill2={sortField === 'points' && sortDirection === 'asc' ? '#2CE3A6' : '#454B56'} 
          />
        </button>
        <div class="w-3/12">&nbsp;</div>
      </div>
      {#if manager && sortedGameweeks}
        {#each sortedGameweeks as gameweek}
          {@const captain = $playerStore.find((x) => x.id === gameweek.captainId)}
          {@const playerCountry = $countryStore ? $countryStore.find((x) => x.id === captain?.nationality) : null}
          <button class="w-full" on:click={() => viewGameweekDetail(gameweek.gameweek)}>
            <div class="flex items-center justify-between p-2 py-4 text-left border-b border-gray-700 cursor-pointer md:px-4 hover:bg-gray-800">
              <div class="w-2/12">{gameweek.gameweek}</div>
              <div class="flex items-center w-4/12">
                {#if playerCountry}
                  <svelte:component
                    this={getFlagComponent(captain?.nationality ?? 0)}
                    class="hidden mr-4 w-9 h-9 md:flex"
                    size="100"
                  />
                {/if}
                <p class="truncate min-w-[40px] max-w-[40px] xxs:min-w-[80px] xxs:max-w-[80px] sm:min-w-[160px] sm:max-w-[160px] md:min-w-none md:max-w-none">
                  {getPlayerName(captain!)}
                </p>
              </div>
              <div class="w-3/12">{@html getBonusIcon(gameweek)}</div>
              <div class="w-3/12"></div>
              <div class="w-2/12 ml-1">{gameweek.points}</div>
              <div class="flex items-center w-3/12">
                <span class="flex items-center">
                  <ViewDetailsIcon className="w-4 mr-1 md:w-6 md:mr-2" />
                  <p class="hidden tiny-text md:flex">View Details</p>
                  <p class="tiny-text md:hidden">View</p>
                </span>
              </div>
            </div>
          </button>
        {/each}
      {/if}
    </div>
  </div>
{/if}