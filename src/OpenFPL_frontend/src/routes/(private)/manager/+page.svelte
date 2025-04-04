<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { page } from "$app/state";
  import { storeManager } from "$lib/managers/store-manager";
  import { managerStore } from "$lib/stores/manager-store";
  import { playerStore } from "$lib/stores/player-store";
  import type {FantasyTeamSnapshot, Manager } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import { getGridSetup, getTeamFormationReadOnly } from "$lib/utils/pick-team.helpers";
  import ManagerGameweeks from "$lib/components/manager/manager-gameweeks.svelte";
  import ReadOnlyPitchView from "$lib/components/manager/read-only-pitch-view.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";
  import ManagerHeader from "$lib/components/manager/manager-header.svelte";
  import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
    
  $: id = page.url.searchParams.get("id");
  $: gw = page.url.searchParams.get("gw");
  $: formation = "4-4-2";
  $: gridSetup = getGridSetup(formation);

  let isLoading = true;
  let activeTab: string = "details";
  let fantasyTeam: Writable<FantasyTeamSnapshot | null> = writable(null);
  let selectedGameweek = writable(0);
  let loadingGameweekDetail: Writable<boolean> = writable(false);
  let gameweekPlayers = writable<GameweekData[]>([]);
  let manager: Writable<Manager | null> = writable(null);

  const tabs = [
    { id: "details", label: "Details", authOnly: false },
    { id: "gameweeks", label: "Gameweeks", authOnly: false }
  ];

  onMount(async () => {
    await storeManager.syncStores();
    $selectedGameweek = Number(gw);
    $manager = await managerStore.getPublicProfile(id ?? "");
    formation = getTeamFormationReadOnly($fantasyTeam, $playerStore);
    gridSetup = getGridSetup(formation);
    viewGameweekDetail($selectedGameweek!);
    isLoading = false;
  });

  function setActiveTab(tab: string): void {
    if (tab === "details") {
      $loadingGameweekDetail = true;
    }
    activeTab = tab;
  }

  function viewGameweekDetail(gw: number) {
    $selectedGameweek = gw;
    fantasyTeam.set($manager!.gameweeks.find((x) => x.gameweek === $selectedGameweek)!);
    setActiveTab("details");
  }
</script>

  {#if isLoading}
    <LocalSpinner />
  {:else}
    <ManagerHeader manager={$manager!} />

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