<script lang="ts">
  import { onMount } from "svelte";
  import type { TeamSetup } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  import { storeManager } from "$lib/managers/store-manager";
  import { managerStore } from "$lib/stores/manager-store";
  import { appStore } from "$lib/stores/app-store";
  import { allFormations } from "$lib/utils/pick-team.helpers";
  
  import PickTeamButtons from "$lib/components/pick-team/header/pick-team-buttons.svelte";
  import PickTeamHeader from "$lib/components/pick-team/header/pick-team-header.svelte";
  import PickTeamPlayers from "$lib/components/pick-team/player-select/pick-team-players.svelte";
  import BonusPanel from "$lib/components/pick-team/bonus-select/bonus-panel.svelte";
  import LeagueFixtures from "$lib/components/shared/league-fixtures.svelte";
  import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";
    
  let isLoading = $state(true);
  let pitchView = $state(true); 
  let fantasyTeam = $state<TeamSetup | undefined>(undefined);
  let availableFormations = $state(Object.keys(allFormations));  
  let selectedFormation = $state('4-4-2');
  let sessionAddedPlayers = $state<number[]>([]);
  let teamValue = $state(0);
  
  onMount(async () => {
      setDisplayMode();
      await storeManager.syncStores();
      await loadData();
      isLoading = false;
  });

  function setDisplayMode(){
    const storedViewMode = localStorage.getItem("viewMode");
    if (storedViewMode) {
      pitchView = storedViewMode === "pitch";
    }
  }

  async function loadData() {    
    let userFantasyTeam = await managerStore.getTeamSelection();
    fantasyTeam = userFantasyTeam;
    if (fantasyTeam && (!fantasyTeam.playerIds || fantasyTeam.playerIds.length !== 11)) {
      return {
        ...fantasyTeam,
        playerIds: new Uint16Array(11).fill(0),
      };
    }
  }
  
  function showPitchView(){
    pitchView = true;
  }

  function showListView(){
    pitchView = false;
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
      <PickTeamHeader {fantasyTeam} {teamValue} />
      <PickTeamButtons 
        {fantasyTeam} 
        {pitchView} 
        {selectedFormation} 
        {availableFormations}
        {teamValue}
        {sessionAddedPlayers}
        {showPitchView}
        {showListView}
      />
      <div class="flex flex-col mt-2 xl:flex-row xl:mt-0 xl:space-x-2">
        <div class="xl:w-[800px]">
          <div class="flex flex-col w-full">
            <PickTeamPlayers 
              {fantasyTeam} 
              {pitchView} 
              {selectedFormation} 
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