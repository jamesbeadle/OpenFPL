<script lang="ts">
  import { onMount } from "svelte";
  
  import { storeManager } from "$lib/managers/store-manager";
  import { managerStore } from "$lib/stores/manager-store";
  import { appStore } from "$lib/stores/app-store";
  import type { PlayerId, TeamSetup } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { allFormations } from "$lib/utils/pick-team.helpers";
  
  import PickTeamButtons from "$lib/components/pick-team/header/pick-team-buttons.svelte";
  import PickTeamHeader from "$lib/components/pick-team/header/pick-team-header.svelte";
  import PickTeamPlayers from "$lib/components/pick-team/player-select/pick-team-players.svelte";
  import BonusPanel from "$lib/components/pick-team/bonus-select/bonus-panel.svelte";
  import LeagueFixtures from "$lib/components/shared/league-fixtures.svelte";
  import PickTeamBanner from "$lib/components/pick-team/header/pick-team-banner.svelte";
  import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";
    
  let fantasyTeam = $state<TeamSetup | undefined>(undefined);
  let availableFormations = $state(Object.keys(allFormations));   
  let selectedFormation = $state('4-4-2');
  let teamValue = $state(0);
  let pitchView = $state(true);
  let sessionAddedPlayers = $state<number[]>([]);
  
  let isLoading = $state(true);
  let showWelcomeBanner = $state(false);

  onMount(async () => {
    console.log("mounting pick team")
      await storeManager.syncStores();
      console.log("stores synced")
      await loadData();
      isLoading = false;
  });

  async function loadData() {
    const storedViewMode = localStorage.getItem("viewMode");
    if (storedViewMode) {
      pitchView = storedViewMode === "pitch";
    }

    const hasSeenBanner = localStorage.getItem("hasSeenPickTeamBanner");
    
    let userFantasyTeam = await managerStore.getTeamSelection();
    fantasyTeam = userFantasyTeam;
    if (fantasyTeam && (!fantasyTeam.playerIds || fantasyTeam.playerIds.length !== 11)) {
      return {
        ...fantasyTeam,
        playerIds: new Uint16Array(11).fill(0),
      };
    }

    if (!hasSeenBanner && (userFantasyTeam.firstGameweek || userFantasyTeam.playerIds.every((id: PlayerId) => id === 0))) {
      showWelcomeBanner = true;
    }
  }

  function handleBannerDismiss() {
    showWelcomeBanner = false;
    localStorage.setItem("hasSeenPickTeamBanner", "true");
  }

</script>

<svelte:head>
  <link rel="preload" href="/board.png" as="image" />
  <link rel="preload" href="/brace-bonus.png" as="image" />
  <link rel="preload" href="/one-nation.png" as="image" />
  <link rel="preload" href="/hat-trick-hero.png" as="image" />
  <link rel="preload" href="/pass-master.png" as="image" />
  <link rel="preload" href="/prospects.png" as="image" />
  <link rel="preload" href="/safe-hands.png" as="image" />
  <link rel="preload" href="/team-boost.png" as="image" />
  <link rel="preload" href="/goal-getter.png" as="image" />
  <link rel="preload" href="/no-entry.png" as="image" />
  <link rel="preload" href="/captain-fantastic.png" as="image" />
  <link rel="preload" href="/pitch.png" as="image" />
</svelte:head>

  {#if isLoading}
    <LocalSpinner />
  {:else}
    {#if $appStore?.onHold}
            
      <div class="relative w-full xl:w-1/2 mt-2">
        <p>The system is currently under going maintenance. Please check back soon.</p>
      </div>
    {:else}
    <div>
      {#if showWelcomeBanner}
        <PickTeamBanner 
          visible={showWelcomeBanner} 
          onDismiss={handleBannerDismiss}
        />
      {/if}
      <PickTeamHeader {fantasyTeam} {teamValue} />
      <PickTeamButtons 
        {fantasyTeam} 
        {pitchView} 
        {selectedFormation} 
        {availableFormations}
        {teamValue}
        {sessionAddedPlayers}
      />
      <div class="flex flex-col mt-2 xl:flex-row xl:mt-0 xl:space-x-2">
        <div class="xl:w-[800px]">
            
          <div class="flex flex-col w-full">
            <PickTeamPlayers 
              {fantasyTeam} 
              {pitchView} 
              {selectedFormation} 
              {teamValue} 
              {sessionAddedPlayers} 
            />
            <div class="w-full mt-2">
              <BonusPanel {fantasyTeam} />
            </div>
          </div> 
            
        </div>
        <div class="hidden xl:block xl:flex-1">
          <LeagueFixtures />
        </div>
      </div>
    </div>
    {/if}
  {/if}