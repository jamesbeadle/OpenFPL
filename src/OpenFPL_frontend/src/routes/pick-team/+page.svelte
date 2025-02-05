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
  import PickTeamPlayers from "$lib/components/pick-team/pick-team-players.svelte";
  import PickTeamButtons from "$lib/components/pick-team/pick-team-buttons.svelte";
  import PickTeamHeader from "$lib/components/pick-team/pick-team-header.svelte";
  import SimpleFixtures from "$lib/components/simple-fixtures.svelte";
  import BonusPanel from "$lib/components/pick-team/bonus-panel.svelte";
  import OnHold from "$lib/components/pick-team/on-hold.svelte";
    
  let fantasyTeam = writable<TeamSelectionDTO | undefined>(undefined);
  let availableFormations = writable(Object.keys(allFormations));   
  let selectedFormation = writable('4-4-2');
  let teamValue = writable(0);
  const pitchView = writable(true);
  let sessionAddedPlayers = writable<number[]>([]);
  
  let isLoading = true;
  
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
      <PickTeamHeader {fantasyTeam} {teamValue} />
      <PickTeamButtons 
        {fantasyTeam} 
        {pitchView} 
        {selectedFormation} 
        {availableFormations}
        {teamValue}
        {sessionAddedPlayers}
      />
      <div class="flex flex-col mt-2 xl:flex-row xl:mt-0">
        <PickTeamPlayers {fantasyTeam} {pitchView} {selectedFormation} {teamValue} {sessionAddedPlayers} />
        <div class="hidden w-full ml-2 xl:flex xl:w-1/2">
          <SimpleFixtures />
        </div>
      </div>
      <BonusPanel {fantasyTeam} />
    </div>
    {/if}
  {/if}
</Layout>