<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { playerStore } from "$lib/stores/player-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { seasonStore } from "$lib/stores/season-store";
  import type { AppStatusDTO, PickTeamDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { allFormations, autofillTeam, checkBonusUsedInSession, checkSaveButtonConditions, getAvailableFormations, getHighestValuedPlayerId, getTeamFormation, isBonusConditionMet, isValidFormation } from "$lib/utils/pick-team.helpers";
  import SetTeamName from "./modals/set-team-name-modal.svelte";
  import { appStore } from "$lib/stores/app-store";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import { leagueStore } from "$lib/stores/league-store";
  import DesktopButtons from "./desktop-buttons.svelte";
  import MobileButtons from "./mobile-buttons.svelte";

  export let fantasyTeam: Writable<PickTeamDTO>;
  export let selectedFormation: Writable<string>;
  export let availableFormations: Writable<string[]>;
  export let pitchView: Writable<Boolean>;

  let startingFantasyTeam: PickTeamDTO;
  let isSaveButtonActive: Writable<boolean>;
  let activeSeason: string;
  let activeGameweek: number;
  let newUsername = writable("");
  let showUsernameModal = false;
  let bonusUsedInSession = false;
  let transferWindowPlayed = writable(false);
  let transferWindowPlayedInSession = false;
  let isLoading = true;
  let appStatus: AppStatusDTO;
  let pitchViewActive = writable(true);

  $: if ($fantasyTeam && $playerStore.length > 0) {
    disableInvalidFormations();
    $isSaveButtonActive = checkSaveButtonConditions(isLoading, $fantasyTeam, $playerStore, appStatus, $selectedFormation);
  }

  $: {
    if ($fantasyTeam) {
      
      if ($fantasyTeam.playerIds.filter((x) => x > 0).length == 11) {
        const newFormation = getTeamFormation($fantasyTeam, $playerStore);
        $selectedFormation = newFormation;
      }

      if(startingFantasyTeam){
        bonusUsedInSession = checkBonusUsedInSession($fantasyTeam, startingFantasyTeam);
      }
    }
  }

  onMount(async () => {
    let appStatusResult = await appStore.getAppStatus();
    appStatus = appStatusResult ? appStatusResult : appStatus;
    startingFantasyTeam = $fantasyTeam;
    loadData();
    disableInvalidFormations()
    isLoading = false;
  });
  
  async function loadData() {

    let foundSeason = $seasonStore.find(x => x.id == $leagueStore!.activeSeasonId);
    if(foundSeason){
      activeSeason = foundSeason.name;
    }
    activeGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1;

    const storedViewMode = localStorage.getItem("viewMode");
    if (storedViewMode) {
      $pitchViewActive = storedViewMode === "pitch";
      pitchView.set($pitchViewActive);
    }

    let transferWindowGameweek = $fantasyTeam?.transferWindowGameweek ?? 0;
    $transferWindowPlayed = transferWindowGameweek > 0;

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

  function showPitchView() {
    $pitchViewActive = true;
    pitchView.set($pitchViewActive);
  }

  function showListView() {
    $pitchViewActive = false;
    pitchView.set($pitchViewActive);
  }

  function disableInvalidFormations() {
    if (!$fantasyTeam || !$fantasyTeam.playerIds || $fantasyTeam.principalId == '') {
      availableFormations.set(Object.keys(allFormations));
      return;
    }

    const formations = getAvailableFormations($playerStore, $fantasyTeam);
    availableFormations.set(formations);
  }

  function autoFillFantasyTeam() {
    if (!$fantasyTeam || !$playerStore) return;
    $fantasyTeam = autofillTeam($fantasyTeam, $playerStore, $selectedFormation);
  }

  function playTransferWindow() {
    transferWindowPlayedInSession = true;
    $transferWindowPlayed = true;
    fantasyTeam.set({ ...$fantasyTeam, transferWindowGameweek: $leagueStore!.unplayedGameweek });
  }

  async function updateUsername() {
    if ($newUsername == "") { return; }
    fantasyTeam.set({ ...$fantasyTeam, username: $newUsername });
    showUsernameModal = false;
    saveFantasyTeam();
  }

  async function saveFantasyTeam() {
    if (!$fantasyTeam) { return; }

    if ($fantasyTeam.username == "") {
      showUsernameModal = true;
      return;
    }

    isLoading = true;

    let team = $fantasyTeam;
    if (team?.captainId === 0 || !team?.playerIds.includes(team?.captainId)) {
      team!.captainId = getHighestValuedPlayerId(team!, $playerStore);
    }

    if (team?.safeHandsGameweek === activeGameweek && team?.safeHandsPlayerId !== team?.playerIds[0]) {
      team.safeHandsPlayerId = team?.playerIds[0];
    }

    if (team?.captainFantasticGameweek === activeGameweek && team?.captainFantasticPlayerId !== team?.captainId) {
      team.captainFantasticPlayerId = team?.captainId;
    }

    await managerStore.saveFantasyTeam(team!, activeGameweek, bonusUsedInSession, transferWindowPlayedInSession);
    isLoading = false;
  }

  function closeUsernameModal() {
    showUsernameModal = false;
  }
</script>

{#if isLoading}
  <WidgetSpinner />
{:else}
  <SetTeamName
    visible={showUsernameModal}
    setUsername={updateUsername}
    cancelModal={closeUsernameModal}
    {newUsername}
  />

  <div class="hidden xl:flex flex-col md:flex-row">
    <DesktopButtons 
      {pitchViewActive} 
      {selectedFormation} 
      {availableFormations}  
      {transferWindowPlayed} 
      {isSaveButtonActive} 
      {fantasyTeam}
      {showPitchView}
      {showListView}
      {playTransferWindow}
      {autoFillFantasyTeam}
      {saveFantasyTeam} />
  </div>

  <div class="flex xl:hidden flex-col">
    <MobileButtons 
      {pitchViewActive} 
      {selectedFormation} 
      {availableFormations}  
      {transferWindowPlayed} 
      {isSaveButtonActive} 
      {fantasyTeam}
      {showPitchView}
      {showListView}
      {playTransferWindow}
      {autoFillFantasyTeam}
      {saveFantasyTeam}
    />
  </div>
{/if}
