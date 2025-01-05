<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  
  import { storeManager } from "$lib/managers/store-manager";
  import { managerStore } from "$lib/stores/manager-store";
  import { appStore } from "$lib/stores/app-store";
  import type { PickTeamDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { allFormations } from "$lib/utils/pick-team.helpers";
  
  import Layout from "../Layout.svelte";
  import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
  import PickTeamPlayers from "$lib/components/pick-team/pick-team-players.svelte";
  import PickTeamButtons from "$lib/components/pick-team/pick-team-buttons.svelte";
  import PickTeamHeader from "$lib/components/pick-team/pick-team-header.svelte";
  import SimpleFixtures from "$lib/components/simple-fixtures.svelte";
  import BonusPanel from "$lib/components/pick-team/bonus-panel.svelte";
  import OnHold from "$lib/components/pick-team/on-hold.svelte";
    
  let fantasyTeam = writable<PickTeamDTO | undefined>(undefined);
  let availableFormations = writable(Object.keys(allFormations));   
  let selectedFormation = writable('4-4-2');
  const pitchView = writable(true);
  
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
      <PickTeamHeader {fantasyTeam} />
      <PickTeamButtons {fantasyTeam} {pitchView} {selectedFormation} {availableFormations} />
      <div class="flex flex-col xl:flex-row mt-2 xl:mt-0">
        <PickTeamPlayers {fantasyTeam} {pitchView} {selectedFormation} />
        <div class="hidden xl:flex w-full xl:w-1/2 ml-2">
          <SimpleFixtures />
        </div>
      </div>
      <BonusPanel {fantasyTeam} />
    </div>
    {/if}
  {/if}
</Layout>