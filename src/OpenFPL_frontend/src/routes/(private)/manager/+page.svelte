<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/state";
  import { storeManager } from "$lib/managers/store-manager";
  import { managerStore } from "$lib/stores/manager-store";
  import { playerStore } from "$lib/stores/player-store";
  import type {FantasyTeamSnapshot, Manager } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import { getGridSetup, getTeamFormationReadOnly } from "$lib/utils/pick-team.helpers";
  import ManagerGameweeks from "$lib/components/manager/manager-gameweeks.svelte";
  import ReadOnlyPitchView from "$lib/components/manager/read-only-pitch-view.svelte";
  import TabContainer from "$lib/components/shared/global/tab-container.svelte";
  import ManagerHeader from "$lib/components/manager/manager-header.svelte";
  import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";
    
  let id = $state(page.url.searchParams.get("id"));
  let gw = $state(page.url.searchParams.get("gw"));
  let formation = $state("4-4-2");
  let gridSetup : number[][] = $state([]);
  

  let isLoading = $state(true);
  let activeTab: string = $state("details");
  let fantasyTeam: FantasyTeamSnapshot | null = $state(null);
  let selectedGameweek = $state(0);
  let loadingGameweekDetail: boolean = $state(false);
  let gameweekPlayers = $state<GameweekData[]>([]);
  let manager: Manager | null = $state(null);

  const tabs = [
    { id: "details", label: "Details", authOnly: false },
    { id: "gameweeks", label: "Gameweeks", authOnly: false }
  ];

  onMount(async () => {
    await storeManager.syncStores();
    selectedGameweek = Number(gw);
    manager = await managerStore.getPublicProfile(id ?? "");
    formation = getTeamFormationReadOnly(fantasyTeam, $playerStore);
    gridSetup = getGridSetup(formation);
    viewGameweekDetail(selectedGameweek!);
    isLoading = false;
  });
  
  $effect(() => {
    gridSetup = getGridSetup(formation);
  });

  function setActiveTab(tab: string): void {
    if (tab === "details") {
      loadingGameweekDetail = true;
    }
    activeTab = tab;
  }

  function viewGameweekDetail(gw: number) {
    selectedGameweek = gw;
    fantasyTeam = manager!.gameweeks.find((x) => x.gameweek === selectedGameweek)!;
    setActiveTab("details");
  }
</script>

  {#if isLoading}
    <LocalSpinner />
  {:else}
    <ManagerHeader manager={manager!} />

    <div class="bg-panel">
      <TabContainer {tabs} {activeTab} {setActiveTab} />

      {#if activeTab === "details"}
        <ReadOnlyPitchView {fantasyTeam} {gridSetup} {selectedGameweek} {gameweekPlayers} />
      {/if}

      {#if activeTab === "gameweeks"}
        <ManagerGameweeks {viewGameweekDetail} {manager} />
      {/if}
    </div>
  {/if}