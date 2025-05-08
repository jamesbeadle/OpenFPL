<script lang="ts">
  import { onMount } from "svelte";
  import { playerStore } from "$lib/stores/player-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { seasonStore } from "$lib/stores/season-store";
  import { allFormations, autofillTeam, checkBonusUsedInSession, checkSaveButtonConditions, getAvailableFormations, getHighestValuedPlayerId, getTeamFormation } from "$lib/utils/pick-team.helpers";
  import { appStore } from "$lib/stores/app-store";
  import { leagueStore } from "$lib/stores/league-store";
  import DesktopButtons from "./desktop-buttons.svelte";
  import MobileButtons from "./mobile-buttons.svelte";
  import {toastsStore } from "$lib/stores/toasts-store";
  import LocalSpinner from "../../shared/global/local-spinner.svelte";
  import type { AppStatus, TeamSetup } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { teamSetupStore } from "$lib/stores/team-setup-store";

  interface Props {
    selectedFormation: string;
    availableFormations: string[];
    pitchView: Boolean;
    teamValue: number;
    teamFormation: string;
    sessionAddedPlayers: number[];
    showPitchView : () => void;
    showListView : () => void; 
  }
  
  let { selectedFormation, availableFormations, teamValue, teamFormation, sessionAddedPlayers, showPitchView, showListView }: Props = $props();
  
  let startingFantasyTeam: TeamSetup | undefined = $state(undefined);
  let isSaveButtonActive = $state(false);
  let activeSeason: string;
  let activeGameweek: number;
  let bonusUsedInSession = false;
  let transferWindowPlayed = $state(false);
  let transferWindowPlayedInSession = false;
  let isLoading = $state(true);
  let appStatus: AppStatus;
  let pitchViewActive = $state(true);

  $effect(() => {
    if ($teamSetupStore && $playerStore.length > 0) {
      disableInvalidFormations();
      isSaveButtonActive = checkSaveButtonConditions(isLoading, $teamSetupStore, $playerStore, appStatus, selectedFormation);
    }
    if ($teamSetupStore) {
        
        if ($teamSetupStore.playerIds.filter((x) => x > 0).length == 11) {
          const newFormation = getTeamFormation($teamSetupStore, $playerStore);
          selectedFormation = newFormation;
        }

        if(startingFantasyTeam){
          bonusUsedInSession = checkBonusUsedInSession($teamSetupStore, startingFantasyTeam);
        }
      }
  });

  onMount(async () => {
    let appStatusResult = await appStore.getAppStatus();
    appStatus = appStatusResult ? appStatusResult : appStatus;
    startingFantasyTeam = $teamSetupStore!;
    loadData();
    disableInvalidFormations()
    isLoading = false;
  });
  
  async function loadData() {

    let foundSeason = $seasonStore.find(x => x.id == $leagueStore!.activeSeasonId);
    if(foundSeason){
      activeSeason = foundSeason.name;
    }
    activeGameweek = $leagueStore!.unplayedGameweek;

    let transferWindowGameweek = $teamSetupStore?.transferWindowGameweek ?? 0;
    transferWindowPlayed = transferWindowGameweek > 0;

    if ($teamSetupStore && (!$teamSetupStore.playerIds || $teamSetupStore.playerIds.length !== 11)) {
      $teamSetupStore = {
          ...$teamSetupStore,
          playerIds: new Uint16Array(11).fill(0),
        };
      }
  }

  function disableInvalidFormations() {
    if (!$teamSetupStore || !$teamSetupStore.playerIds || $teamSetupStore.principalId == '') {
      availableFormations = Object.keys(allFormations);
      return;
    }

    const formations = getAvailableFormations($playerStore, $teamSetupStore);
    availableFormations = formations;
  }

  function autoFillFantasyTeam() {
    if (!$teamSetupStore || !$playerStore) return;
    
    if (!$teamSetupStore.firstGameweek && $teamSetupStore.transferWindowGameweek !== $leagueStore!.unplayedGameweek) {
      const emptySlots = 11 - $teamSetupStore.playerIds.filter(id => id > 0).length;
      if (emptySlots > $teamSetupStore.transfersAvailable) {
        toastsStore.addToast({
          message: `Cannot auto-fill team - insufficient transfers available (${emptySlots} needed, ${$teamSetupStore.transfersAvailable} remaining)`,
          type: "error",
          duration: 2000
        });
        return;
      }
    }
    
    const oldPlayerIds = new Set($teamSetupStore.playerIds);
    $teamSetupStore = autofillTeam($teamSetupStore, $playerStore, selectedFormation);

    const newPlayers = $teamSetupStore!.playerIds.filter(id => id > 0 && !oldPlayerIds.has(id));
    sessionAddedPlayers = [...sessionAddedPlayers, ...newPlayers];
  }

  function playTransferWindow() {
    transferWindowPlayedInSession = true;
    transferWindowPlayed = true;
    $teamSetupStore = { ...$teamSetupStore!, transferWindowGameweek: $leagueStore!.unplayedGameweek };
  }

  async function saveFantasyTeam() {
    if (!$teamSetupStore) { return; }

    isLoading = true;

    let team = $teamSetupStore;
    if (team?.captainId === 0 || !team?.playerIds.includes(team?.captainId)) {
      team!.captainId = getHighestValuedPlayerId(team!, $playerStore);
    }

    if (team?.safeHandsGameweek === activeGameweek && team?.safeHandsPlayerId !== team?.playerIds[0]) {
      team.safeHandsPlayerId = team?.playerIds[0];
    }

    if (team?.captainFantasticGameweek === activeGameweek && team?.captainFantasticPlayerId !== team?.captainId) {
      team.captainFantasticPlayerId = team?.captainId;
    }

    await managerStore.saveFantasyTeam(team!, activeGameweek, transferWindowPlayedInSession);
    isLoading = false;
  }

  function handleResetTeam() {
    if (!$teamSetupStore || !startingFantasyTeam) return;
    
    $teamSetupStore = {
      ...startingFantasyTeam,
      playerIds: Uint16Array.from(startingFantasyTeam.playerIds)
    };
    
    toastsStore.addToast({
      message: "Team reset successfully",
      type: "info",
      duration: 2000
    });
  }
</script>

{#if isLoading}
  <LocalSpinner />
{:else}

  <div class="flex-col hidden xl:flex md:flex-row">
    <DesktopButtons 
      {pitchViewActive} 
      {selectedFormation} 
      {availableFormations}  
      {transferWindowPlayed} 
      {isSaveButtonActive} 
      startingFantasyTeam={startingFantasyTeam!}
      {showPitchView}
      {showListView}
      {playTransferWindow}
      {autoFillFantasyTeam}
      {saveFantasyTeam}
      {handleResetTeam}
    />
  </div>

  <div class="flex flex-col xl:hidden">
    <MobileButtons 
      {pitchViewActive} 
      {selectedFormation} 
      {availableFormations}  
      {transferWindowPlayed} 
      {isSaveButtonActive} 
      startingFantasyTeam={startingFantasyTeam!}
      {showPitchView}
      {showListView}
      {playTransferWindow}
      {autoFillFantasyTeam}
      {saveFantasyTeam}
      {handleResetTeam}
    />
  </div>
{/if}
