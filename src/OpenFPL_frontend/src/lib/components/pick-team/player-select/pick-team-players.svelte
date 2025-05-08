<script lang="ts">
  import { onMount } from "svelte";

  import { leagueStore } from "$lib/stores/league-store";
  import { playerStore } from "$lib/stores/player-store";
  import { teamSetupStore } from "$lib/stores/team-setup-store";
  import { canAddPlayerToCurrentFormation, findValidFormationWithPlayer, getAvailablePositionIndex, getHighestValuedPlayerId, getTeamFormation, repositionPlayersForNewFormation } from "$lib/utils/pick-team.helpers";
  
  import ConfirmCaptainChange from "../modals/confirm-captain-change-modal.svelte";
  import AddPlayerModal from "../modals/add-player-modal.svelte";
  import SelectedPlayersPitch from "./selected-players-pitch.svelte";
  import SelectedPlayersList from "./selected-players-list.svelte";
  import { convertPositionToIndex } from "$lib/utils/Helpers";
  import LocalSpinner from "../../shared/global/local-spinner.svelte";
  import type { Player } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  interface Props {
    pitchView: boolean;
    selectedFormation: string;
    sessionAddedPlayers: number[];
  }
  let { pitchView, selectedFormation, sessionAddedPlayers }: Props = $props();

  let isLoading = $state(true);
  let showAddPlayerModal = $state(false);
  let showCaptainModal = $state(false);
  let startingTeamPlayerIds: number[] = [];
  let positionsChanged = new Set<number>();
  let selectedPosition = $state(-1);
  let canSellPlayer = $state(true);
  let newCaptainId = $state(0);
  let newCaptain = $state("");

  onMount(async () => {
      await loadData();
      if ($teamSetupStore) {
        startingTeamPlayerIds = Array.from($teamSetupStore.playerIds);
      }
      isLoading = false;
  });

  async function loadData() {
    if (!$teamSetupStore) {
      return;
    }

    canSellPlayer = $teamSetupStore.firstGameweek || $teamSetupStore.transferWindowGameweek != $leagueStore!.unplayedGameweek || $teamSetupStore.transfersAvailable > 0;
    if ($teamSetupStore && (!$teamSetupStore.playerIds || $teamSetupStore.playerIds.length !== 11)) {
      $teamSetupStore = {
        ...$teamSetupStore,
        playerIds: new Uint16Array(11).fill(0),
      };
    }
  }

  function setTeamFormation(){
   
  }

  function loadAddPlayer(row: number) {
    selectedPosition = row;
    showAddPlayerModal = true;
  }

  function setCaptain(playerId: number) {
    if (playerId > 0) {
      newCaptainId = playerId;
      let player = $playerStore.find((x) => x.id === newCaptainId);
      newCaptain = `${player?.firstName} ${player?.lastName}`;
      showCaptainModal = true;
      return;
    }

    newCaptainId = getHighestValuedPlayerId($teamSetupStore!, $playerStore);
    let player = $playerStore.find((x) => x.id === newCaptainId);    
    newCaptain = `${player?.firstName} ${player?.lastName}`;
    showCaptainModal = true;
  }

  function removePlayer(playerId: number) {
      selectedPosition = -1;
      if(!$teamSetupStore){ return };
      const playerIndex = $teamSetupStore!.playerIds.indexOf(playerId);
      if (playerIndex === -1) {
        console.error("Player not found in the team.");
        return;
      }

      const newPlayerIds = Uint16Array.from($teamSetupStore!.playerIds);
      newPlayerIds[playerIndex] = 0;

      let transfersAvailable = $teamSetupStore!.transfersAvailable;
      
      if (sessionAddedPlayers.includes(playerId)) {
        if (!$teamSetupStore!.firstGameweek && $teamSetupStore!.transferWindowGameweek !== $leagueStore!.unplayedGameweek) {
          transfersAvailable += 1;
        }
        sessionAddedPlayers = sessionAddedPlayers.filter((id) => id !== playerId);
        positionsChanged.delete(playerIndex); 
      }
      
      let bankQuarterMillions = $teamSetupStore.bankQuarterMillions + $playerStore.find((x) => x.id === playerId)!.valueQuarterMillions;

      let updatedFantasyTeam = { ...$teamSetupStore!, playerIds: newPlayerIds, bankQuarterMillions, transfersAvailable };
      $teamSetupStore = updatedFantasyTeam;
  }

  function changeCaptain() {
    selectedPosition = -1;
    $teamSetupStore = { ...$teamSetupStore!, captainId: newCaptainId };
    showCaptainModal = false;
  }

  function handlePlayerSelection(player: Player) {
    if (canAddPlayerToCurrentFormation($playerStore, player, $teamSetupStore!, selectedFormation)) 
    {
      addPlayerToTeam(player, selectedFormation);
    } else {
      const newFormation = findValidFormationWithPlayer($playerStore, $teamSetupStore!, player, selectedFormation);
      let updatedFantasyTeam = {
        ...$teamSetupStore!,
        playerIds: repositionPlayersForNewFormation($playerStore, $teamSetupStore!, newFormation),
        bankQuarterMillions: $teamSetupStore!.bankQuarterMillions - player.valueQuarterMillions
      };
      $teamSetupStore = updatedFantasyTeam;
      selectedFormation = newFormation;
      addPlayerToTeam(player, newFormation);
    }
    if (!sessionAddedPlayers.includes(player.id)) {
      sessionAddedPlayers.push(player.id);
    }
    setTeamFormation();
  }

  function addPlayerToTeam(player: Player, formation: string) {
    const indexToAdd = getAvailablePositionIndex(convertPositionToIndex(player.position), $teamSetupStore!, formation);
    if (indexToAdd === -1) {
      console.error("No available position to add the player.");
      return;
    }

    const newPlayerIds = Uint16Array.from($teamSetupStore!.playerIds);
    if (indexToAdd < newPlayerIds.length) {
      newPlayerIds[indexToAdd] = player.id;

      let transfersAvailable = $teamSetupStore!.transfersAvailable;
      if (!positionsChanged.has(indexToAdd) && 
          !$teamSetupStore!.firstGameweek && 
          $teamSetupStore!.transferWindowGameweek !== $leagueStore!.unplayedGameweek &&
          !startingTeamPlayerIds.includes(player.id)) {
        transfersAvailable -= 1;
        positionsChanged.add(indexToAdd);
      }

      let bankQuarterMillions = $teamSetupStore!.bankQuarterMillions - player.valueQuarterMillions;
    
      let updatedFantasyTeam = { ...$teamSetupStore!, playerIds: newPlayerIds, bankQuarterMillions, transfersAvailable };
      $teamSetupStore = updatedFantasyTeam;
    } else {
      console.error(
        "Index out of bounds when attempting to add player to team."
      );
      return $teamSetupStore;
    }

    if ($teamSetupStore!.captainId > 0 && $teamSetupStore!.playerIds.filter((x) => x == $teamSetupStore!.captainId).length == 0) 
    {
      newCaptainId = getHighestValuedPlayerId($teamSetupStore!, $playerStore);
      changeCaptain();
    }
  }

  function closeAddPlayerModal(){
    showAddPlayerModal = false;
  }

  function closeConfirmCaptainModal(){
    showCaptainModal = false;
  }
  
</script>

{#if showCaptainModal}
  <ConfirmCaptainChange
    newCaptain={newCaptain}
    onClose={closeConfirmCaptainModal}
    onConfirm={changeCaptain}
  />
{/if}

{#if showAddPlayerModal}
  <AddPlayerModal
    {handlePlayerSelection}
    filterPosition={selectedPosition}
    onClose={closeAddPlayerModal}
  />
{/if}

{#if isLoading}
  <LocalSpinner />
{:else}
  {#if pitchView}
    <SelectedPlayersPitch {selectedFormation} {canSellPlayer} {sessionAddedPlayers} {loadAddPlayer} {removePlayer} {setCaptain} />
  {:else}
    <SelectedPlayersList {selectedFormation} {canSellPlayer} {sessionAddedPlayers} {loadAddPlayer} {removePlayer} {setCaptain} />
  {/if}
{/if}

