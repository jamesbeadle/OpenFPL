<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/state";
  import { storeManager } from "$lib/managers/store-manager";

  import TeamPlayers from "$lib/components/club/team-players.svelte";
  import TeamFixtures from "$lib/components/club/team-fixtures.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";
  import ClubHeader from "$lib/components/club/club-header.svelte";
  import LocalSpinner from "$lib/components/shared/local-spinner.svelte";

  let isLoading = true;
  
  let activeTab: string = "players";
  const tabs = [
    { id: "playes", label: "Fixtures", authOnly: false },
    { id: "fixtures", label: "Points", authOnly: false },
    { id: "loaned-players", label: "Leaderboards", authOnly: false }
  ];

  $: id = Number(page.url.searchParams.get("id"));

  onMount(async () => {
    await storeManager.syncStores();
    isLoading = false;
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

  {#if isLoading}
    <LocalSpinner />
  {:else}
    <ClubHeader clubId={id} />
    <div class="bg-panel">
      <TabContainer {activeTab} {setActiveTab} {tabs} />
      {#if activeTab === "players"}
        <TeamPlayers clubId={id} />
      {:else if activeTab === "fixtures"}
        <TeamFixtures clubId={id} />
      {/if}
    </div>
  {/if}
