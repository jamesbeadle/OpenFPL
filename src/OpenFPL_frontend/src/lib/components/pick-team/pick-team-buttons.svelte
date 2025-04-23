<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { playerStore } from "$lib/stores/player-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { seasonStore } from "$lib/stores/season-store";
  import { allFormations, autofillTeam, checkBonusUsedInSession, checkSaveButtonConditions, getAvailableFormations, getHighestValuedPlayerId, getTeamFormation, isBonusConditionMet, isValidFormation, updateTeamValue } from "$lib/utils/pick-team.helpers";
  import { appStore } from "$lib/stores/app-store";
  import { leagueStore } from "$lib/stores/league-store";
  import DesktopButtons from "./desktop-buttons.svelte";
  import MobileButtons from "./mobile-buttons.svelte";
  import { toasts } from "$lib/stores/toasts-store";
  import LocalSpinner from "../shared/local-spinner.svelte";
  import type { AppStatus, TeamSetup } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    interface Props {
      fantasyTeam: Writable<TeamSetup | undefined>;
      selectedFormation: Writable<string>;
      availableFormations: Writable<string[]>;
      pitchView: Writable<Boolean>;
      teamValue: Writable<number>;
      sessionAddedPlayers: Writable<number[]>;
    }
    let { fantasyTeam,selectedFormation, availableFormations,  pitchView, teamValue, sessionAddedPlayers }: Props = $props();
  
  let startingFantasyTeam: TeamSetup | undefined = $state(undefined);
  let isSaveButtonActive = writable(false);
  let activeSeason: string;
  let activeGameweek: number;
  let newUsername = writable("");
  let showUsernameModal = false;
  let bonusUsedInSession = false;
  let transferWindowPlayed = writable(false);
  let transferWindowPlayedInSession = false;
  let isLoading = $state(true);
  let appStatus: AppStatus;
  let pitchViewActive = writable(true);

  $effect(() => {
    if ($fantasyTeam && $playerStore.length > 0) {
      disableInvalidFormations();
      $isSaveButtonActive = checkSaveButtonConditions(isLoading, $fantasyTeam, $playerStore, appStatus, $selectedFormation);
    }
    if ($fantasyTeam) {
        
        if ($fantasyTeam.playerIds.filter((x) => x > 0).length == 11) {
          const newFormation = getTeamFormation($fantasyTeam, $playerStore);
          $selectedFormation = newFormation;
        }

        if(startingFantasyTeam){
          bonusUsedInSession = checkBonusUsedInSession($fantasyTeam, startingFantasyTeam);
        }
      }
  });

  onMount(async () => {
    let appStatusResult = await appStore.getAppStatus();
    appStatus = appStatusResult ? appStatusResult : appStatus;
    startingFantasyTeam = $fantasyTeam!;
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
    
    if (!$fantasyTeam.firstGameweek && $fantasyTeam.transferWindowGameweek !== $leagueStore!.unplayedGameweek) {
      const emptySlots = 11 - $fantasyTeam.playerIds.filter(id => id > 0).length;
      if (emptySlots > $fantasyTeam.transfersAvailable) {
        toasts.addToast({
          message: `Cannot auto-fill team - insufficient transfers available (${emptySlots} needed, ${$fantasyTeam.transfersAvailable} remaining)`,
          type: "error",
          duration: 2000
        });
        return;
      }
    }
    
    const oldPlayerIds = new Set($fantasyTeam.playerIds);
    $fantasyTeam = autofillTeam($fantasyTeam, $playerStore, $selectedFormation);

    const newPlayers = $fantasyTeam!.playerIds.filter(id => id > 0 && !oldPlayerIds.has(id));
    $sessionAddedPlayers = [...$sessionAddedPlayers, ...newPlayers];
    
    teamValue.set(updateTeamValue($fantasyTeam));
  }

  function playTransferWindow() {
    transferWindowPlayedInSession = true;
    $transferWindowPlayed = true;
    fantasyTeam.set({ ...$fantasyTeam!, transferWindowGameweek: $leagueStore!.unplayedGameweek });
  }

  async function updateUsername() {
    if ($newUsername == "") { return; }
    fantasyTeam.set({ ...$fantasyTeam!, username: $newUsername });
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

    await managerStore.saveFantasyTeam(team!, activeGameweek, transferWindowPlayedInSession);
    isLoading = false;
  }

  function closeUsernameModal() {
    showUsernameModal = false;
  }

  function handleResetTeam() {
    if (!$fantasyTeam || !startingFantasyTeam) return;
    
    $fantasyTeam = {
      ...startingFantasyTeam,
      playerIds: Uint16Array.from(startingFantasyTeam.playerIds)
    };
    teamValue.set(updateTeamValue($fantasyTeam));
    
    toasts.addToast({
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
      {fantasyTeam}
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
      {fantasyTeam}
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
