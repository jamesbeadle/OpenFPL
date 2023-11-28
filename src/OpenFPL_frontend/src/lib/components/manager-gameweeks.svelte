<script lang="ts">
    import { onMount } from "svelte";
    import { page } from "$app/stores";
    import type { FantasyTeam, ManagerDTO, Season, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { SystemService } from "$lib/services/SystemService";
    import { ManagerService } from "$lib/services/ManagerService";
    import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
    import { toastStore } from "$lib/stores/toast";
    import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
    
    let isLoading = true;
    export let principalId = '';
    export let viewGameweekDetail: (principalId: string, selectedGameweek: number) => void;
    let manager: ManagerDTO;
    let selectedGameweek: number = 1;
    let selectedSeason: Season | null = null;
    
    $: id = $page.url.searchParams.get("id") ?? principalId;
  
    onMount(async () => {
      try {
        const systemService = new SystemService();
        await systemService.updateSystemStateData();
        
        let systemState = await systemService.getSystemState();
        selectedGameweek = systemState?.activeGameweek ?? selectedGameweek;
        selectedSeason = systemState?.activeSeason ?? selectedSeason;
        let managerService = new ManagerService();
        manager = await managerService.getManager(id ?? "", selectedSeason?.id ?? 1, selectedGameweek);
      } catch (error) {
        toastStore.show("Error fetching manager gameweeks.", "error");
        console.error("Error fetching manager gameweeks:", error);
      } finally { isLoading = false; }
    });

  
  </script>
  
  {#if isLoading}
    <LoadingIcon />
  {:else}
    <div class="flex flex-col space-y-4 text-lg mt-4">
      <div class="overflow-x-auto flex-1">
        <div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray">
          <div class="w-1/4 px-4">Gameweek</div>
          <div class="w-1/4 px-4">Points</div>
          <div class="w-1/4 px-4">&nbsp;</div>
        </div>
  
        {#each manager.gameweeks as gameweek}
          <div class="flex items-center justify-between p-2 py-4 border-b border-gray-700 cursor-pointer">
            <div class="w-1/4 px-4">{gameweek.gameweek}</div>
            <div class="w-1/4 px-4">{gameweek.points}</div>
            <div class="w-1/4 px-4 flex items-center">
              <button on:click={() => viewGameweekDetail(gameweek.principalId, gameweek.gameweek)}>
                <span class="flex items-center">
                  <ViewDetailsIcon className="w-6 mr-2" />View Details
                </span>
              </button>
            </div>
          </div>
        {/each}
      </div>
    </div>
  {/if}
  