<script lang="ts">
    import { onMount } from "svelte";
    import { page } from "$app/stores";
    import { playerStore } from "$lib/stores/player-store";
    import { managerStore } from "$lib/stores/manager-store";
    import { toastsError } from "$lib/stores/toasts-store";
    import type {
      FantasyTeamSnapshot,
      ManagerDTO,
    } from "../../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
    import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
    import { getFlagComponent } from "$lib/utils/helpers";
    import { countryStore } from "$lib/stores/country-store";
    import LocalSpinner from "../local-spinner.svelte";
    import { authStore } from "$lib/stores/auth.store";
    import { storeManager } from "$lib/managers/store-manager";
      import { goto } from "$app/navigation";
  
    export let principalId = "";
    let manager: ManagerDTO;
    let isLoading = true;
  
    $: id = $page.url.searchParams.get("id") ?? principalId;
  
    onMount(async () => {
      try {
        await storeManager.syncStores();
        
        if(!id){
          principalId = $authStore?.identity?.getPrincipal().toText() ?? "";
        }
  
        manager = await managerStore.getPublicProfile(principalId);
      } catch (error) {
        toastsError({
          msg: { text: "Error fetching manager gameweeks." },
          err: error,
        });
        console.error("Error fetching manager gameweeks:", error);
      } finally {
        isLoading = false;
      }
    });
  
    function getBonusIcon(snapshot: FantasyTeamSnapshot) {
      if (snapshot.goalGetterGameweek === snapshot.gameweek) {
        return `<img src="/goal-getter.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else if (snapshot.passMasterGameweek === snapshot.gameweek) {
        return `<img src="/pass-master.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else if (snapshot.noEntryGameweek === snapshot.gameweek) {
        return `<img src="/no-entry.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else if (snapshot.teamBoostGameweek === snapshot.gameweek) {
        return `<img src="/team-boost.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else if (snapshot.safeHandsGameweek === snapshot.gameweek) {
        return `<img src="/safe-hands.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else if (snapshot.captainFantasticGameweek === snapshot.gameweek) {
        return `<img src="/captain-fantastic.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else if (snapshot.prospectsGameweek === snapshot.gameweek) {
        return `<img src="/prospects.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else if (snapshot.oneNationGameweek === snapshot.gameweek) {
        return `<img src="/one-nation.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else if (snapshot.braceBonusGameweek === snapshot.gameweek) {
        return `<img src="/brace-bonus.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else if (snapshot.hatTrickHeroGameweek === snapshot.gameweek) {
        return `<img src="/hat-trick-hero.png" alt="Bonus" class="w-6 md:w-9" />`;
      } else {
        return "-";
      }
    }
  
    function viewGameweekDetail(gameweek: number){
      goto(`/manager?id=${id}&gw=${gameweek}`)
    }
  </script>
  
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="flex flex-col space-y-4 mt-4">
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
              on:click={() => viewGameweekDetail(gameweek.gameweek)}
            >
              <div
                class="flex items-center text-left justify-between p-2 md:px-4 py-4 border-b border-gray-700 cursor-pointer"
              >
                <div class="w-2/12">{gameweek.gameweek}</div>
                <div class="w-4/12 flex items-center">
                  {#if playerCountry}
                    <svelte:component
                      this={getFlagComponent(captain?.nationality ?? 0)}
                      class="w-9 h-9 mr-4 hidden md:flex"
                      size="100"
                    />
                  {/if}
                  <p
                    class="truncate min-w-[40px] max-w-[40px] xxs:min-w-[80px] xxs:max-w-[80px] sm:min-w-[160px] sm:max-w-[160px] md:min-w-none md:max-w-none"
                  >
                    {`${
                      captain?.firstName.length ?? 0 > 0
                        ? captain?.firstName.charAt(0) + "."
                        : ""
                    } ${captain?.lastName}`}
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
  {/if}
  