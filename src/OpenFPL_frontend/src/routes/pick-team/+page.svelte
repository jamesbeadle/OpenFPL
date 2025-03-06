<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  
  import { storeManager } from "$lib/managers/store-manager";
  import { managerStore } from "$lib/stores/manager-store";
  import { appStore } from "$lib/stores/app-store";
  import type { TeamSelectionDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { allFormations } from "$lib/utils/pick-team.helpers";
  
  import Layout from "../Layout.svelte";
  import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
  import PickTeamButtons from "$lib/components/pick-team/pick-team-buttons.svelte";
  import PickTeamHeader from "$lib/components/pick-team/pick-team-header.svelte";
  import SimpleFixtures from "$lib/components/simple-fixtures.svelte";
  import OnHold from "$lib/components/pick-team/on-hold.svelte";
  import PickTeamLeftPanel from "$lib/components/pick-team/pick-team-left-panel.svelte";
  import PickTeamBanner from "$lib/components/pick-team/pick-team-banner.svelte";
    
  let fantasyTeam = writable<TeamSelectionDTO | undefined>(undefined);
  let availableFormations = writable(Object.keys(allFormations));   
  let selectedFormation = writable('4-4-2');
  let teamValue = writable(0);
  const pitchView = writable(true);
  let sessionAddedPlayers = writable<number[]>([]);
  
  let isLoading = true;
  let showWelcomeBanner = false;

  onMount(async () => {
      await storeManager.syncStores();
      await loadData();
      isLoading = false;
  });

  async function loadData() {
    const storedViewMode = localStorage.getItem("viewMode");
    if (storedViewMode) {
      pitchView.set(storedViewMode === "pitch");
    }

    const hasSeenBanner = localStorage.getItem("hasSeenPickTeamBanner");
    
    let userFantasyTeam = await managerStore.getCurrentTeam();
    fantasyTeam.set(userFantasyTeam);

    fantasyTeam.update((currentTeam) => {
      if (
        currentTeam &&
        (!currentTeam.playerIds || currentTeam.playerIds.length !== 11)
      ) {
        return {
          ...currentTeam,
          playerIds: new Uint16Array(11).fill(0),
        };
      }
      return currentTeam;
    });

    if (!hasSeenBanner && (userFantasyTeam.firstGameweek || userFantasyTeam.playerIds.every(id => id === 0))) {
      showWelcomeBanner = true;
    }
  }

  function handleBannerDismiss() {
    showWelcomeBanner = false;
    localStorage.setItem("hasSeenPickTeamBanner", "true");
  }

</script>

<Layout>
  {#if isLoading}
    <WidgetSpinner />
  {:else}
    {#if $appStore?.onHold}
      <OnHold />
    {:else}
    <div>
      {#if showWelcomeBanner}
        <PickTeamBanner 
          bind:visible={showWelcomeBanner} 
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
          <PickTeamLeftPanel
            {fantasyTeam}
            {pitchView}
            {selectedFormation}
            {teamValue}
            {sessionAddedPlayers}
          />
        </div>
        <div class="hidden xl:block xl:flex-1">
          <SimpleFixtures />
        </div>
      </div>
    </div>
    {/if}
  {/if}
</Layout>