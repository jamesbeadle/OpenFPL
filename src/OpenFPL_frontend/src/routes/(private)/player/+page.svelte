<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/state";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerStore } from "$lib/stores/player-store";
  import { clubStore } from "$lib/stores/club-store";
  import PlayerGameweekHistory from "$lib/components/player/player-gameweek-history.svelte";

  import PlayerHeader from "$lib/components/player/player-header.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";
  import LocalSpinner from "$lib/components/shared/local-spinner.svelte";
  import type { Club, Player__1 } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  $: id = Number(page.url.searchParams.get("id"));

  let selectedGameweek: number = 1;
  let selectedPlayer: Player__1;
  let playerClub: Club;
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

  {#if isLoading}
    <LocalSpinner />
  {:else}
    <PlayerHeader player={selectedPlayer} club={playerClub} gameweek={selectedGameweek} />
    
    <div class="bg-panel">
      <TabContainer {tabs} {activeTab} {setActiveTab}  />
     
      {#if activeTab === "history"}
        <PlayerGameweekHistory />
      {/if}
    </div>
  {/if}
