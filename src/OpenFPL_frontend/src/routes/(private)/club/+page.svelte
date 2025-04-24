<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/state";
  import { storeManager } from "$lib/managers/store-manager";

  import ClubPlayers from "$lib/components/club/club-players.svelte";
  import ClubFixtures from "$lib/components/club/club-fixtures.svelte";
  import TabContainer from "$lib/components/shared/global/tab-container.svelte";
  import ClubHeader from "$lib/components/club/club-header.svelte";
  import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";

  let isLoading = $state(true);
  
  let activeTab: string = $state("players");
  const tabs: { id: string; label: string; authOnly: boolean }[] = $state([
    { id: "playes", label: "Fixtures", authOnly: false },
    { id: "fixtures", label: "Points", authOnly: false }
  ]);

  let id = $state(0);

  onMount(async () => {
    await storeManager.syncStores();
    isLoading = false;
  });
  
  $effect(() => {
    id = Number(page.url.searchParams.get("id"));
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
        <ClubPlayers clubId={id} />
      {:else if activeTab === "fixtures"}
        <ClubFixtures clubId={id} />
      {/if}
    </div>
  {/if}