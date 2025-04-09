<script lang="ts">
  import { onMount } from "svelte";
  
  import { seasonStore } from "$lib/stores/season-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  import { userIdCreatedStore } from '$lib/stores/user-control-store';
  import { appStore } from "$lib/stores/app-store";
  import { userStore } from "$lib/stores/user-store";
  import { storeManager } from "$lib/managers/store-manager";
  
  import HomepageHeader from "$lib/components/homepage/homepage-header.svelte";
  import FixturesComponent from "$lib/components/homepage/fixtures.svelte";
  import GamweekPointsComponent from "$lib/components/manager/gameweek-points.svelte";
  import LeaderboardsComponent from "$lib/components/homepage/leaderboards.svelte";
  import LeagueTableComponent from "$lib/components/homepage/league-table.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";
  import FullScreenSpinner from "$lib/components/shared/full-screen-spinner.svelte";

  let activeTab: string = $state("fixtures");
  let isLoading = $state(true);
  let loadingMessage = $state("Loading");
  let seasonName = $state("");

  const tabs = [
    { id: "fixtures", label: "Fixtures", authOnly: false },
    { id: "points", label: "Points", authOnly: true },
    { id: "leaderboards", label: "Leaderboards", authOnly: false },
    { id: "league-table", label: "Table", authOnly: false },
  ];

  onMount(() => {
    if (!$authSignedInStore) {
      isLoading = false;
    }
  });

  $effect(() => {
    if ($userIdCreatedStore?.data) {
        isLoading = true;
        loadingMessage = "Loading Data";
        Promise.all([
            storeManager.syncStores(),
            appStore.checkServerVersion(),
            userStore.sync()
        ]).then(() => {
            loadingMessage = "Getting Season Name";
            loadCurrentStatusDetails();
            loadingMessage = "Loading Complete";
        }).catch(error => {
            console.error('Error loading data:', error);
            loadingMessage = "Error Loading Data";
        }).finally(() => {
            isLoading = false;
        });
    }
  });

  async function loadCurrentStatusDetails(){
    seasonName = await seasonStore.getSeasonName($leagueStore?.activeSeasonId ?? 1) ?? "-";
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

</script>

{#if isLoading}
    <FullScreenSpinner message={loadingMessage} />
{:else}
    <HomepageHeader {seasonName} />

    <div class="bg-panel">
      <TabContainer {tabs} {activeTab} {setActiveTab} />
      
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
{/if}
