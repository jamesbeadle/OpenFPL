<script lang="ts">
    import { onMount } from "svelte";
    import Layout from "../Layout.svelte";
    import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
    import { page } from "$app/stores";
    import ManagerGameweekDetails from "$lib/components/manager-gameweek-details.svelte";
    import ManagerGameweeks from "$lib/components/manager-gameweeks.svelte";
    import { ManagerService } from "$lib/services/ManagerService";
    import type { ManagerDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { SystemService } from "$lib/services/SystemService";
    
    let progress = 0;
    let isLoading = true;
    let activeTab: string = "details";
    let manager: ManagerDTO;
    let selectedGameweek = 1;
    let selectedSeason = '';
  
    $: id = $page.url.searchParams.get("id");
    onMount(async () => {
      try {
        let systemService = new SystemService();
        let systemState = await systemService.getSystemState();
        selectedGameweek = systemState?.activeGameweek ?? 1;
        selectedSeason = systemState?.activeSeason.name ?? "";
        let managerService = new ManagerService();
        manager = await managerService.getManager(id ?? "");
        console.log(manager)
        isLoading = false;
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    });
  
    function setActiveTab(tab: string): void {
      activeTab = tab;
    }
  </script>
  
  <Layout>
    {#if isLoading}
      <LoadingIcon {progress} />
    {:else}
      <div class="m-4">
        <div class="flex flex-col md:flex-row">
            <div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
                <div class="flex-grow">
                  <p class="text-gray-300 text-xs">&nbsp</p>
                  <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                    Profile Picture
                  </p>
                  <p class="text-gray-300 text-xs">&nbsp</p>
                </div>
                <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;" />
                <div class="flex-grow">
                  <p class="text-gray-300 text-xs">Manager</p>
                  <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                    {manager.displayName}
                  </p>
                  <p class="text-gray-300 text-xs">Joined</p>
                </div>
                <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"/>
                <div class="flex-grow">
                  <p class="text-gray-300 text-xs">Favourite Team</p>
                  <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                    MUN
                  </p>
                  <p class="text-gray-300 text-xs">Manchester United</p>
                </div>
            </div>
            <div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
                <div class="flex-grow">
                  <p class="text-gray-300 text-xs">Leaderboards</p>
                  <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                    {manager.weeklyPositionText} <span class="text-xs">(200)</span>
                  </p>
                  <p class="text-gray-300 text-xs">Weekly</p>
                </div>
                <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;" />
                <div class="flex-grow">
                    <p class="text-gray-300 text-xs">Man United</p>
                    <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                      {manager.monthlyPositionText} <span class="text-xs">(400)</span>
                    </p>
                    <p class="text-gray-300 text-xs">Club</p>
                </div>
                <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"/>
                <div class="flex-grow">
                    <p class="text-gray-300 text-xs">{selectedSeason}</p>
                    <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                        {manager.seasonPositionText} <span class="text-xs">(2,000)</span>
                    </p>
                    <p class="text-gray-300 text-xs">Season</p>
                </div>
            </div>
        </div>

        <div class="flex flex-col md:flex-row">
          <div class="flex flex-col md:flex-row justify-between items-center text-white m-4 bg-panel p-4 rounded-md md:w-full">
            <div class="flex flex-row justify-between md:justify-start flex-grow mb-2 md:mb-0 ml-4 order-3 md:order-1">
              <button class={`btn ${ activeTab == 'details' ? `fpl-button` : `inactive-btn` } px-4 py-2 rounded-l-md font-bold text-md min-w-[125px] my-4`}
                on:click={() => setActiveTab('details')}>Details
              </button>
              <button class={`btn ${ activeTab == 'gameweeks' ? `fpl-button` : `inactive-btn` } px-4 py-2 rounded-r-md font-bold text-md min-w-[125px] my-4`}
                on:click={() => setActiveTab('gameweeks')}>Gameweeks
              </button>
            </div>
  
          </div>
        </div>
        {#if activeTab === "details"}
          <ManagerGameweekDetails />
        {/if}
        {#if activeTab === "gameweeks"}
          <ManagerGameweeks />
        {/if}
      </div>
    {/if}
  </Layout>
  