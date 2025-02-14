<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  
  import { storeManager } from "$lib/managers/store-manager";
  import { seasonStore } from "$lib/stores/season-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { authStore } from "$lib/stores/auth.store";

  import Layout from "./Layout.svelte";
  import LandingPage from "$lib/components/homepage/landing-page.svelte";
  import HomepageHeader from "$lib/components/homepage/homepage-header.svelte";
  import FixturesComponent from "$lib/components/homepage/fixtures.svelte";
  import GamweekPointsComponent from "$lib/components/manager/gameweek-points.svelte";
  import LeaderboardsComponent from "$lib/components/homepage/leaderboards.svelte";
  import LeagueTableComponent from "$lib/components/homepage/league-table.svelte";
  import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";
  import { appStore } from "$lib/stores/app-store";

  let activeTab: string = "fixtures";
  let isLoggedIn = false;
  let isLoading = true;
  let seasonName = "";
  let unsubscribe: () => void;

  const tabs = [
    { id: "fixtures", label: "Fixtures", authOnly: false },
    { id: "points", label: "Points", authOnly: true },
    { id: "leaderboards", label: "Leaderboards", authOnly: false },
    { id: "league-table", label: "Table", authOnly: false },
  ];

  onMount(async () => {
    await storeManager.syncStores();



    unsubscribe = authStore.subscribe((store) => {
      isLoggedIn = store.identity !== null && store.identity !== undefined;
      if (isLoggedIn) {
        (async () => {
          try {
            await appStore.checkServerVersion();
            await loadCurrentStatusDetails();
          } catch (error) {
            console.error("Error syncing stores and getting server version:", error);
          }
          isLoading = false;
        })();
      } else {
        isLoading = false;
      }
    });
  });

  onDestroy(() => {
    if (unsubscribe) unsubscribe();
  });

  async function loadCurrentStatusDetails(){
    seasonName = await seasonStore.getSeasonName($leagueStore?.activeSeasonId ?? 1) ?? "-";
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  $: showHeader = isLoggedIn;
</script>

<Layout {showHeader}>
  {#if isLoading}
    <WidgetSpinner />
  {:else if isLoggedIn}
    <HomepageHeader {seasonName} />

    <div class="bg-panel">
      <TabContainer {tabs} {activeTab} {setActiveTab} isLoggedIn={isLoggedIn}  />
      
      {#if activeTab === "fixtures"}
        <FixturesComponent />
      {:else if activeTab === "points"}
        <GamweekPointsComponent />
      {:else if activeTab === "leaderboards"}
        <LeaderboardsComponent />
      {:else if activeTab === "league-table"}
        <LeagueTableComponent />
      {/if}
      
    </div>
  {:else}
    <LandingPage />
  {/if}
</Layout>
