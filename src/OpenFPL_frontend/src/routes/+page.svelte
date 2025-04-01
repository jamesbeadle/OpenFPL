<script lang="ts">
  import { onMount } from "svelte";
  
  import { seasonStore } from "$lib/stores/season-store";
  import { leagueStore } from "$lib/stores/league-store";
  import { globalDataLoaded } from "$lib/managers/store-manager";
  import { authSignedInStore } from "$lib/derived/auth.derived";
  

  import HomepageHeader from "$lib/components/homepage/homepage-header.svelte";
  import FixturesComponent from "$lib/components/homepage/fixtures.svelte";
  import GamweekPointsComponent from "$lib/components/manager/gameweek-points.svelte";
  import LeaderboardsComponent from "$lib/components/homepage/leaderboards.svelte";
  import LeagueTableComponent from "$lib/components/homepage/league-table.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";
  import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
  import LandingPage from "$lib/components/landing/landing-page.svelte";
  
  let activeTab: string = "fixtures";
  let isLoading = true;
  let seasonName = "";

  const tabs = [
    { id: "fixtures", label: "Fixtures", authOnly: false },
    { id: "points", label: "Points", authOnly: true },
    { id: "leaderboards", label: "Leaderboards", authOnly: false },
    { id: "league-table", label: "Table", authOnly: false },
  ];

  onMount(() => {
    let unsub: () => void = () => {};
    unsub = globalDataLoaded.subscribe((loaded) => {
      if (loaded) {
        loadCurrentStatusDetails();
        isLoading = false;
        unsub();
      }
    });
    isLoading = false;
  });

  async function loadCurrentStatusDetails(){
    seasonName = await seasonStore.getSeasonName($leagueStore?.activeSeasonId ?? 1) ?? "-";
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

</script>

{#if isLoading}
    <LocalSpinner />
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
