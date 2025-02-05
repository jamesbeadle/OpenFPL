<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";

  import { leagueStore } from "$lib/stores/league-store";
  import { playerStore } from "$lib/stores/player-store";
  import { canAddPlayerToCurrentFormation, findValidFormationWithPlayer, getAvailablePositionIndex, getHighestValuedPlayerId, getTeamFormation, repositionPlayersForNewFormation } from "$lib/utils/pick-team.helpers";
  import type { PlayerDTO, TeamSelectionDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  import ConfirmCaptainChange from "./modals/confirm-captain-change-modal.svelte";
  import AddPlayerModal from "./modals/add-player-modal.svelte";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import SelectedPlayersPitch from "./selected-players-pitch.svelte";
  import SelectedPlayersList from "./selected-players-list.svelte";
  import { convertPositionToIndex } from "$lib/utils/helpers";
  
  export let fantasyTeam: Writable<TeamSelectionDTO | undefined>;
  export let pitchView: Writable<boolean>;
  export let selectedFormation: Writable<string>;
  export let teamValue: Writable<number>;
  export let sessionAddedPlayers: Writable<number[]>;

  let isLoading = true;
  let showAddPlayerModal = false;
  let showCaptainModal = false;
  let newTeam = true;
  let selectedPosition = writable(-1);
  let selectedColumn = -1;
  let canSellPlayer = writable(true);
  let newCaptainId = writable<number>(0);
  let newCaptain = writable<string>("");
  let positionsChanged = new Set<number>();
  let startingTeamPlayerIds: number[] = [];

  onMount(async () => {
    const storedViewMode = localStorage.getItem("viewMode");
      if (storedViewMode) {
        pitchView.set(storedViewMode === "pitch");
      }
      await loadData();
      isLoading = false;
      if ($fantasyTeam) {
        startingTeamPlayerIds = Array.from($fantasyTeam.playerIds);
      }
  });

  async function loadData() {

    if (!$fantasyTeam) {
      return;
    }

    let principalId = $fantasyTeam?.principalId ?? "";
    if (principalId.length > 0) {
        newTeam = false;
    }

    $canSellPlayer = $fantasyTeam.firstGameweek || $fantasyTeam.transferWindowGameweek != $leagueStore!.unplayedGameweek || $fantasyTeam.transfersAvailable > 0;
    
    fantasyTeam.update((currentTeam) => {
      if (currentTeam && (!currentTeam.playerIds || currentTeam.playerIds.length !== 11)) {
        return {
          ...currentTeam,
          playerIds: new Uint16Array(11).fill(0),
        };
      }
      
      return currentTeam;
    });
  }
  
  function loadAddPlayer(row: number, col: number) {
    $selectedPosition = row;
    selectedColumn = col;
    showAddPlayerModal = true;
  }

  function setCaptain(playerId: number) {

    if (playerId > 0) {
      newCaptainId.set(playerId);
      let player = $playerStore.find((x) => x.id === $newCaptainId);
      $newCaptain = `${player?.firstName} ${player?.lastName}`;
      showCaptainModal = true;
      return;
    }

    newCaptainId.set(getHighestValuedPlayerId($fantasyTeam!, $playerStore));
    let player = $playerStore.find((x) => x.id === $newCaptainId);    
    $newCaptain = `${player?.firstName} ${player?.lastName}`;
    showCaptainModal = true;
  }

  function removePlayer(playerId: number) {
      $selectedPosition = -1;
      selectedColumn = -1;
      if(!$fantasyTeam){ return };
      fantasyTeam.update((currentTeam) => {
        const playerIndex = currentTeam!.playerIds.indexOf(playerId);
        if (playerIndex === -1) {
          console.error("Player not found in the team.");
          return currentTeam;
        }

      const newPlayerIds = Uint16Array.from(currentTeam!.playerIds);
      newPlayerIds[playerIndex] = 0;

      let transfersAvailable = currentTeam!.transfersAvailable;
      
      if ($sessionAddedPlayers.includes(playerId)) {
        if (!currentTeam!.firstGameweek && currentTeam!.transferWindowGameweek !== $leagueStore!.unplayedGameweek) {
          transfersAvailable += 1;
        }
        $sessionAddedPlayers = $sessionAddedPlayers.filter((id) => id !== playerId);
        positionsChanged.delete(playerIndex); 
      }

      let newTeamValue = 0;
      newPlayerIds.forEach((id) => {
        const player = $playerStore.find((p) => p.id === id);
        if (player) {
          newTeamValue += player.valueQuarterMillions;
        }
      });
      teamValue.set(newTeamValue / 4);
      
      let bankQuarterMillions = $fantasyTeam.bankQuarterMillions + $playerStore.find((x) => x.id === playerId)!.valueQuarterMillions;
      return { ...currentTeam!, playerIds: newPlayerIds, bankQuarterMillions, transfersAvailable, teamValue };
    })
  }

  $: if ($fantasyTeam) {
    setTeamValue();
    setTeamFormation();
  }

  function setTeamValue() {
    let totalValue = 0;
    $fantasyTeam!.playerIds.forEach((id) => {
      const player = $playerStore.find((p) => p.id === id);
      if (player) {
        totalValue += player.valueQuarterMillions;
      }
    });
    
    let updatedFantasyTeam = {
      ...$fantasyTeam!,
      teamValue: totalValue / 4,
    };
    fantasyTeam.set(updatedFantasyTeam);
  }

  function setTeamFormation(){
    if ($fantasyTeam!.playerIds.filter((x) => x > 0).length == 11) {
      const newFormation = getTeamFormation($fantasyTeam!, $playerStore);
      $selectedFormation = newFormation;
    }
  }

  function changeCaptain() {
    $selectedPosition = -1;
    selectedColumn = -1;
    fantasyTeam.update((currentTeam) => {
      return { ...currentTeam!, captainId: $newCaptainId };
    });
    showCaptainModal = false;
  }

  function handlePlayerSelection(player: PlayerDTO) {
    if (canAddPlayerToCurrentFormation($playerStore, player, $fantasyTeam!, $selectedFormation)) 
    {
      addPlayerToTeam(player, $selectedFormation);
    } else {
      const newFormation = findValidFormationWithPlayer($playerStore, $fantasyTeam!, player, $selectedFormation);
      fantasyTeam.update((team) => {
        return {
          ...team!,
          playerIds: repositionPlayersForNewFormation($playerStore, $fantasyTeam!, newFormation),
          bankQuarterMillions: team!.bankQuarterMillions - player.valueQuarterMillions
        };
      });
      $selectedFormation = newFormation;
      addPlayerToTeam(player, newFormation);
    }
    if (!$sessionAddedPlayers.includes(player.id)) {
      $sessionAddedPlayers.push(player.id);
    }
  }

  function addPlayerToTeam(player: PlayerDTO,formation: string) {
    const indexToAdd = getAvailablePositionIndex(convertPositionToIndex(player.position), $fantasyTeam!, formation);
    if (indexToAdd === -1) {
      console.error("No available position to add the player.");
      return;
    }

    fantasyTeam.update((currentTeam) => {
      const newPlayerIds = Uint16Array.from(currentTeam!.playerIds);
      if (indexToAdd < newPlayerIds.length) {
        newPlayerIds[indexToAdd] = player.id;

        let transfersAvailable = currentTeam!.transfersAvailable;
        if (!positionsChanged.has(indexToAdd) && 
            !currentTeam!.firstGameweek && 
            currentTeam!.transferWindowGameweek !== $leagueStore!.unplayedGameweek &&
            !startingTeamPlayerIds.includes(player.id)) {
          transfersAvailable -= 1;
          positionsChanged.add(indexToAdd);
        }

        let newTeamValue = 0;
        newPlayerIds.forEach((id) => {
          const player = $playerStore.find((p) => p.id === id);
          if (player) {
            newTeamValue += player.valueQuarterMillions;
          }
        });
        teamValue.set(newTeamValue / 4);

        let bankQuarterMillions = currentTeam!.bankQuarterMillions - player.valueQuarterMillions;
      
        return { ...currentTeam!, playerIds: newPlayerIds, teamValue, bankQuarterMillions, transfersAvailable };
      } else {
        console.error(
          "Index out of bounds when attempting to add player to team."
        );
        return currentTeam;
      }
    });

    if ($fantasyTeam!.captainId > 0 && $fantasyTeam!.playerIds.filter((x) => x == $fantasyTeam!.captainId).length == 0) 
    {
      newCaptainId.set(getHighestValuedPlayerId($fantasyTeam!, $playerStore));
      changeCaptain();
    }
  }
  
</script>

<ConfirmCaptainChange
  newCaptain={$newCaptain}
  bind:visible={showCaptainModal}
  onConfirm={changeCaptain}
/>

<AddPlayerModal
  {handlePlayerSelection}
  filterPosition={selectedPosition}
  bind:visible={showAddPlayerModal}
  {fantasyTeam}
/>

{#if isLoading}
  <WidgetSpinner />
{:else}
  {#if $pitchView}
    <SelectedPlayersPitch {selectedFormation} {fantasyTeam} {canSellPlayer} {sessionAddedPlayers} {loadAddPlayer} {removePlayer} {setCaptain} />
  {:else}
    <SelectedPlayersList {selectedFormation} {fantasyTeam} {canSellPlayer} {sessionAddedPlayers} {loadAddPlayer} {removePlayer} {setCaptain} />
  {/if}
{/if}

