<script lang="ts">
  import { onMount } from "svelte";

  import { leagueStore } from "$lib/stores/league-store";
  import { playerStore } from "$lib/stores/player-store";
  import { canAddPlayerToCurrentFormation, findValidFormationWithPlayer, getAvailablePositionIndex, getHighestValuedPlayerId, getTeamFormation, repositionPlayersForNewFormation } from "$lib/utils/pick-team.helpers";
  
  import ConfirmCaptainChange from "../modals/confirm-captain-change-modal.svelte";
  import AddPlayerModal from "../modals/add-player-modal.svelte";
  import SelectedPlayersPitch from "./selected-players-pitch.svelte";
  import SelectedPlayersList from "./selected-players-list.svelte";
  import { convertPositionToIndex } from "$lib/utils/Helpers";
  import LocalSpinner from "../../shared/global/local-spinner.svelte";
  import type { TeamSetup, Player } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  interface Props {
    fantasyTeam: TeamSetup | undefined;
    pitchView: boolean;
    selectedFormation: string;
    sessionAddedPlayers: number[];
  }
  let { fantasyTeam, pitchView, selectedFormation, sessionAddedPlayers }: Props = $props();

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
      console.log("loading complete")
      if (fantasyTeam) {
        console.log("setting player ids")
        startingTeamPlayerIds = Array.from(fantasyTeam.playerIds);
      }
      isLoading = false;
  });

  /*

  Better to set as i go i think

  $effect(() => {
    if (fantasyTeam) {
      setTeamValue();
      setTeamFormation();
    }
  });

  */

  async function loadData() {
    if (!fantasyTeam) {
      return;
    }

    canSellPlayer = fantasyTeam.firstGameweek || fantasyTeam.transferWindowGameweek != $leagueStore!.unplayedGameweek || fantasyTeam.transfersAvailable > 0;
    if (fantasyTeam && (!fantasyTeam.playerIds || fantasyTeam.playerIds.length !== 11)) {
      console.log("setting fantasy team")
      fantasyTeam = {
        ...fantasyTeam,
        playerIds: new Uint16Array(11).fill(0),
      };
    }

    setTeamValue();
    setTeamFormation();
  }

  function setTeamValue() {
    let totalValue = 0;
    fantasyTeam!.playerIds.forEach((id) => {
      const player = $playerStore.find((p) => p.id === id);
      if (player) {
        totalValue += player.valueQuarterMillions;
      }
    });
    
    let updatedFantasyTeam = {
      ...fantasyTeam!,
      teamValue: totalValue / 4,
    };
    fantasyTeam = updatedFantasyTeam;
  }

  function setTeamFormation(){
    if (fantasyTeam!.playerIds.filter((x) => x > 0).length == 11) {
      const newFormation = getTeamFormation(fantasyTeam!, $playerStore);
      selectedFormation = newFormation;
    }
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

    newCaptainId = getHighestValuedPlayerId(fantasyTeam!, $playerStore);
    let player = $playerStore.find((x) => x.id === newCaptainId);    
    newCaptain = `${player?.firstName} ${player?.lastName}`;
    showCaptainModal = true;
  }

  function removePlayer(playerId: number) {
      selectedPosition = -1;
      if(!fantasyTeam){ return };
      const playerIndex = fantasyTeam!.playerIds.indexOf(playerId);
      if (playerIndex === -1) {
        console.error("Player not found in the team.");
        return;
      }

      const newPlayerIds = Uint16Array.from(fantasyTeam!.playerIds);
      newPlayerIds[playerIndex] = 0;

      let transfersAvailable = fantasyTeam!.transfersAvailable;
      
      if (sessionAddedPlayers.includes(playerId)) {
        if (!fantasyTeam!.firstGameweek && fantasyTeam!.transferWindowGameweek !== $leagueStore!.unplayedGameweek) {
          transfersAvailable += 1;
        }
        sessionAddedPlayers = sessionAddedPlayers.filter((id) => id !== playerId);
        positionsChanged.delete(playerIndex); 
      }
      
      let bankQuarterMillions = fantasyTeam.bankQuarterMillions + $playerStore.find((x) => x.id === playerId)!.valueQuarterMillions;

      let updatedFantasyTeam = { ...fantasyTeam!, playerIds: newPlayerIds, bankQuarterMillions, transfersAvailable };
      fantasyTeam = updatedFantasyTeam;

      setTeamValue();
  }

  function changeCaptain() {
    selectedPosition = -1;
    fantasyTeam = { ...fantasyTeam!, captainId: newCaptainId };
    showCaptainModal = false;
  }

  function handlePlayerSelection(player: Player) {
    if (canAddPlayerToCurrentFormation($playerStore, player, fantasyTeam!, selectedFormation)) 
    {
      addPlayerToTeam(player, selectedFormation);
    } else {
      const newFormation = findValidFormationWithPlayer($playerStore, fantasyTeam!, player, selectedFormation);
      let updatedFantasyTeam = {
        ...fantasyTeam!,
        playerIds: repositionPlayersForNewFormation($playerStore, fantasyTeam!, newFormation),
        bankQuarterMillions: fantasyTeam!.bankQuarterMillions - player.valueQuarterMillions
      };
      fantasyTeam = updatedFantasyTeam;
      selectedFormation = newFormation;
      addPlayerToTeam(player, newFormation);
    }
    if (!sessionAddedPlayers.includes(player.id)) {
      sessionAddedPlayers.push(player.id);
    }
    setTeamValue();
    setTeamFormation();
  }

  function addPlayerToTeam(player: Player, formation: string) {
    const indexToAdd = getAvailablePositionIndex(convertPositionToIndex(player.position), fantasyTeam!, formation);
    if (indexToAdd === -1) {
      console.error("No available position to add the player.");
      return;
    }

    const newPlayerIds = Uint16Array.from(fantasyTeam!.playerIds);
    if (indexToAdd < newPlayerIds.length) {
      newPlayerIds[indexToAdd] = player.id;

      let transfersAvailable = fantasyTeam!.transfersAvailable;
      if (!positionsChanged.has(indexToAdd) && 
          !fantasyTeam!.firstGameweek && 
          fantasyTeam!.transferWindowGameweek !== $leagueStore!.unplayedGameweek &&
          !startingTeamPlayerIds.includes(player.id)) {
        transfersAvailable -= 1;
        positionsChanged.add(indexToAdd);
      }

      let bankQuarterMillions = fantasyTeam!.bankQuarterMillions - player.valueQuarterMillions;
    
      let updatedFantasyTeam = { ...fantasyTeam!, playerIds: newPlayerIds, bankQuarterMillions, transfersAvailable };
      fantasyTeam = updatedFantasyTeam;
    } else {
      console.error(
        "Index out of bounds when attempting to add player to team."
      );
      return fantasyTeam;
    }

    if (fantasyTeam!.captainId > 0 && fantasyTeam!.playerIds.filter((x) => x == fantasyTeam!.captainId).length == 0) 
    {
      newCaptainId = getHighestValuedPlayerId(fantasyTeam!, $playerStore);
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
    {fantasyTeam}
    onClose={closeAddPlayerModal}
  />
{/if}

{#if isLoading}
  <LocalSpinner />
{:else}
  {#if pitchView}
    <SelectedPlayersPitch {selectedFormation} {fantasyTeam} {canSellPlayer} {sessionAddedPlayers} {loadAddPlayer} {removePlayer} {setCaptain} />
  {:else}
    <SelectedPlayersList {selectedFormation} {fantasyTeam} {canSellPlayer} {sessionAddedPlayers} {loadAddPlayer} {removePlayer} {setCaptain} />
  {/if}
{/if}

