<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import { writable } from "svelte/store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { managerStore } from "$lib/stores/manager-store";
  import PickTeamHeader from "$lib/components/pick-team/pick-team-header.svelte";
  import PickTeamButtons from "$lib/components/pick-team/pick-team-buttons.svelte";
  import PickTeamPlayers from "$lib/components/pick-team/pick-team-players.svelte";
  import BonusPanel from "$lib/components/pick-team/bonus-panel.svelte";
  import SimpleFixtures from "$lib/components/simple-fixtures.svelte";
  import { Spinner } from "@dfinity/gix-components";
  import type { PickTeamDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import { allFormations } from "$lib/utils/pick-team.helpers";
    import { systemStore } from "$lib/stores/system-store";
    import OnHold from "$lib/components/pick-team/on-hold.svelte";
    import { storeManager } from "$lib/managers/store-manager";

  let availableFormations = writable<string[]>([]);
  let selectedFormation = writable<string>('4-4-2');
  
  let transfersAvailable = writable<number>(3);  
  let bankBalance = writable<number>(0);
  let teamValue = writable<number>(0);
  let loadingPlayers = writable<boolean>(true);  
  let onHold = writable<boolean>(true);  

  let isLoading = true;
  
  const pitchView = writable(true);

  const fantasyTeam = writable<PickTeamDTO>({
    playerIds: [],
    oneNationCountryId: 0,
    username : '',
    goalGetterPlayerId : 0,
    hatTrickHeroGameweek : 0,
    transfersAvailable : 0,
    teamBoostGameweek : 0,
    captainFantasticGameweek : 0,
    oneNationGameweek : 0,
    bankQuarterMillions : 0,
    noEntryPlayerId : 0,
    safeHandsPlayerId : 0,
    braceBonusGameweek : 0,
    passMasterGameweek : 0,
    teamBoostClubId : 0,
    goalGetterGameweek : 0,
    captainFantasticPlayerId : 0,
    transferWindowGameweek : 0,
    noEntryGameweek : 0,
    prospectsGameweek : 0,
    safeHandsGameweek : 0,
    principalId : '',
    passMasterPlayerId : 0,
    captainId : 0,
    canisterId: '',
    monthlyBonusesAvailable : 0,
    firstGameweek: true
  });
  

  onMount(async () => {
    try {
      
      await storeManager.syncStores();

      onHold.set($systemStore?.onHold ?? true);
      $availableFormations = Object.keys(allFormations);
      
      await loadData();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching team details." },
        err: error,
      });
      console.error("Error fetching team details:", error);
    } finally {
      isLoading = false;
      $loadingPlayers = false;
    }
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

    bankBalance.set($fantasyTeam.bankQuarterMillions);

    if($fantasyTeam.principalId == ""){
      bankBalance.set(1200);
      transfersAvailable.set(Infinity);
      return;
    }

    if($fantasyTeam.firstGameweek){
      transfersAvailable.set(Infinity);
    }

  }

</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <div>
      {#if $systemStore?.onHold}
        <div class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-2" role="alert">
          <p class="font-bold">Saving your team is currently disabled</p>
          <p>but OpenWSL will be back soon.</p>
        </div>      
      {/if}
      <div class="hidden md:flex">
        <PickTeamHeader {fantasyTeam} 
        {transfersAvailable}
        {bankBalance}
        {teamValue}/>
      </div>
      <PickTeamButtons
        {fantasyTeam}
        startingFantasyTeam={$fantasyTeam}
        {pitchView}
        {selectedFormation}
        {availableFormations}
        {transfersAvailable}
        {bankBalance}
      />
      <div class="flex flex-col xl:flex-row mt-2 xl:mt-0">
        <PickTeamPlayers
          {loadingPlayers}
          {fantasyTeam}
          {pitchView}
          {selectedFormation}
          {transfersAvailable}
          {bankBalance}
          {teamValue}
        />
        <div class="hidden xl:flex w-full xl:w-1/2 ml-2">
          <SimpleFixtures />
        </div>
        <div class="flex md:hidden w-full mt-4">
          <PickTeamHeader 
            {fantasyTeam} 
            {transfersAvailable}
            {bankBalance}
            {teamValue}
          />
        </div>
      </div>
      <BonusPanel {fantasyTeam}  />
    </div>
  {/if}
</Layout>
