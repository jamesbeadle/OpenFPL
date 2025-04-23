<script lang="ts">
  
  import HomepageHeader from "$lib/components/homepage/homepage-header.svelte";

  import TabContainer from "$lib/components/shared/tab-container.svelte";
  import PointsComponent from "$lib/components/home/points.svelte";
  import LeaderboardsComponent from "$lib/components/home/leaderboards.svelte";
  import FixturesComponent from "$lib/components/home/fixtures.svelte";
  import MvpsComponent from "$lib/components/home/mvps.svelte";
  import LeagueTableComponent from "$lib/components/home/league-table.svelte";
  import TrophyRoomComponent from "$lib/components/home/trophy-room.svelte";

  let activeTab: string = "points";

  const tabs = [
    { id: "points", label: "Points" },
    { id: "leaderboards", label: "Leaderboards" },
    { id: "fixtures", label: "Fixtures" },
    { id: "mvps", label: "MVPs" },
    { id: "league-table", label: "League Table" },
    { id: "trophy-room", label: "Trophy Room" },
  ];

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

</script>

<HomepageHeader />

<div class="bg-panel">
  <TabContainer {tabs} {activeTab} {setActiveTab} />
  
  {#if activeTab === "points"}
    <PointsComponent />
  {:else if activeTab === "leaderboards"}
    <LeaderboardsComponent />
  {:else if activeTab === "fixtures"}
  <FixturesComponent />
  {:else if activeTab === "mvps"}
    <MvpsComponent />
  {:else if activeTab === "league-table"}
    <LeagueTableComponent />
  {:else if activeTab === "trophy-room"}
    <TrophyRoomComponent />
  {/if}
</div>