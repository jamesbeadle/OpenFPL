<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/state";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerStore } from "$lib/stores/player-store";
  import { clubStore } from "$lib/stores/club-store";
  import type {
    ClubDTO,
    PlayerDTO
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import PlayerGameweekHistory from "$lib/components/player/player-gameweek-history.svelte";
    
  import Layout from "../Layout.svelte";
  import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
  import PlayerHeader from "$lib/components/player/player-header.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";

  $: id = Number(page.url.searchParams.get("id"));

  let selectedGameweek: number = 1;
  let selectedPlayer: PlayerDTO;
  let playerClub: ClubDTO;
  let activeTab: string = "history";
  let isLoading = true;

  const tabs = [
    { id: "history", label: "Gameweek History", authOnly: false }
  ];

  onMount(async () => {
    await storeManager.syncStores();
    selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek;
    selectedPlayer = $playerStore.find((x) => x.id === id)!;
    playerClub = $clubStore.find((x) => x.id === selectedPlayer?.clubId)!;
    isLoading = false;
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>
  {#if isLoading}
    <WidgetSpinner />
  {:else}
    <PlayerHeader player={selectedPlayer} club={playerClub} gameweek={selectedGameweek} />
    
    <div class="bg-panel">
      <TabContainer {tabs} {activeTab} {setActiveTab} isLoggedIn={false}  />
     
      {#if activeTab === "history"}
        <PlayerGameweekHistory />
      {/if}
    </div>
  {/if}
</Layout>
