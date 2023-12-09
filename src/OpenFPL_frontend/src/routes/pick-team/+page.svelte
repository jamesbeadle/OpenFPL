<script lang="ts">
  import { onDestroy, onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import { writable } from "svelte/store";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { managerStore } from "$lib/stores/manager-store";

  import BonusPanel from "$lib/components/pick-team/bonus-panel.svelte";
  import AddPlayerModal from "$lib/components/pick-team/add-player-modal.svelte";
  import OpenChatIcon from "$lib/icons/OpenChatIcon.svelte";
  import SimpleFixtures from "$lib/components/simple-fixtures.svelte";
  import AddPlayerIcon from "$lib/icons/AddPlayerIcon.svelte";
  import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
  import AddIcon from "$lib/icons/AddIcon.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import RemovePlayerIcon from "$lib/icons/RemovePlayerIcon.svelte";
  import PlayerCaptainIcon from "$lib/icons/PlayerCaptainIcon.svelte";
  import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
  import {
    formatUnixDateToReadable,
    formatUnixTimeToTime,
    getCountdownTime,
    getPositionAbbreviation,
    getAvailableFormations,
  } from "../../lib/utils/Helpers";
  import { getFlagComponent } from "../../lib/utils/Helpers";
  import type { FantasyTeam } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import { Spinner, busyStore } from "@dfinity/gix-components";

  interface FormationDetails {
    positions: number[];
  }

  const formations: Record<string, FormationDetails> = {
    "3-4-3": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3] },
    "3-5-2": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3] },
    "4-3-3": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3] },
    "4-4-2": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3] },
    "4-5-1": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3] },
    "5-4-1": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3] },
    "5-3-2": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3] },
  };
  const availableFormations = writable<string[]>([
    "3-4-3",
    "3-5-2",
    "4-3-3",
    "4-4-2",
    "4-5-1",
    "5-4-1",
    "5-3-2",
  ]);

  let activeSeason: string;
  let activeGameweek: number;
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let selectedFormation: string = "4-4-2";
  let selectedPosition = -1;
  let selectedColumn = -1;
  let pitchView = true;
  let showAddPlayer = false;
  let teamValue = 0;
  let newTeam = true;
  let isSaveButtonActive = false;

  let sessionAddedPlayers: number[] = [];

  const fantasyTeam = writable<FantasyTeam | null>(null);
  const transfersAvailable = writable(newTeam ? Infinity : 3);
  const bankBalance = writable(1200);
  const bonusUsedInSession = writable<boolean>(false);

  let pitchHeight = 0;
  let pitchElement: HTMLElement;

  let isLoading = true;

  $: gridSetup = getGridSetup(selectedFormation);

  $: if ($fantasyTeam) {
    disableInvalidFormations();
    updateTeamValue();
    isSaveButtonActive = checkSaveButtonConditions();
  }

  $: {
    if ($fantasyTeam) {
      getGridSetup(selectedFormation);
      if ($fantasyTeam.playerIds.filter((x) => x > 0).length == 11) {
        const newFormation = getTeamFormation($fantasyTeam);
        selectedFormation = newFormation;
      }
    }
  }

  $: rowHeight = (pitchHeight * 0.9) / 4;
  $: gridSetupComplete = rowHeight > 0;

  onMount(() => {
    try {
      if (typeof window !== "undefined") {
        window.addEventListener("resize", updatePitchHeight);
        updatePitchHeight();
      }

      async function loadData() {
        await systemStore.sync();
        await teamStore.sync();
        await playerStore.sync();

        activeSeason = $systemStore?.activeSeason.name ?? "-";
        activeGameweek = $systemStore?.activeGameweek ?? 1;

        const storedViewMode = localStorage.getItem("viewMode");
        if (storedViewMode) {
          pitchView = storedViewMode === "pitch";
        }

        let nextFixture = await fixtureStore.getNextFixture();

        let userFantasyTeam = await managerStore.getFantasyTeam();
        fantasyTeam.set(userFantasyTeam);

        let principalId = $fantasyTeam?.principalId ?? "";

        if (principalId.length > 0) {
          newTeam = false;
          bankBalance.set(Number(userFantasyTeam.bankBalance));
        }

        if (activeGameweek > 1 && principalId.length > 0) {
          transfersAvailable.set(userFantasyTeam.transfersAvailable);
        }

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
        nextFixtureDate = formatUnixDateToReadable(
          Number(nextFixture?.kickOff)
        );
        nextFixtureTime = formatUnixTimeToTime(Number(nextFixture?.kickOff));

        let countdownTime = getCountdownTime(Number(nextFixture?.kickOff));
        countdownDays = countdownTime.days.toString();
        countdownHours = countdownTime.hours.toString();
        countdownMinutes = countdownTime.minutes.toString();
        isLoading = false;
      }

      loadData();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching team details." },
        err: error,
      });
      console.error("Error fetching team details:", error);
      isLoading = false;
    }
  });

  function updatePitchHeight() {
    if (!pitchElement) {
      return;
    }
    pitchHeight = pitchElement.clientHeight;
  }

  function getGridSetup(formation: string): number[][] {
    const formationSplits = formation.split("-").map(Number);
    const setups = [
      [1],
      ...formationSplits.map((s) =>
        Array(s)
          .fill(0)
          .map((_, i) => i + 1)
      ),
    ];
    return setups;
  }

  function getTeamFormation(team: FantasyTeam): string {
    const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);

      if (teamPlayer) {
        positionCounts[teamPlayer.position]++;
      }
    });

    for (const formation of Object.keys(formations)) {
      const formationPositions = formations[formation].positions;
      let isMatch = true;

      const formationCount = formationPositions.reduce((acc, pos) => {
        acc[pos] = (acc[pos] || 0) + 1;
        return acc;
      }, {} as Record<number, number>);

      for (const pos in formationCount) {
        if (formationCount[pos] !== positionCounts[pos]) {
          isMatch = false;
          break;
        }
      }

      if (isMatch) {
        return formation;
      }
    }

    console.error("No valid formation found for the team");
    return selectedFormation;
  }

  function showPitchView() {
    pitchView = true;
    localStorage.setItem("viewMode", "pitch");
  }

  function showListView() {
    pitchView = false;
    localStorage.setItem("viewMode", "list");
  }

  function loadAddPlayer(row: number, col: number) {
    selectedPosition = row;
    selectedColumn = col;
    showAddPlayer = true;
  }

  function closeAddPlayerModal() {
    showAddPlayer = false;
  }

  function handlePlayerSelection(player: PlayerDTO) {
    if ($fantasyTeam) {
      if (
        canAddPlayerToCurrentFormation(player, $fantasyTeam, selectedFormation)
      ) {
        addPlayerToTeam(player, $fantasyTeam, selectedFormation);
      } else {
        const newFormation = findValidFormationWithPlayer($fantasyTeam, player);
        repositionPlayersForNewFormation($fantasyTeam, newFormation);
        selectedFormation = newFormation;
        addPlayerToTeam(player, $fantasyTeam, newFormation);
      }
      if (!newTeam && activeGameweek > 1) {
        transfersAvailable.update((n) => (n > 0 ? n - 1 : 0));
      }
      bankBalance.update((n) =>
        n - Number(player.value) > 0 ? n - Number(player.value) : n
      );

      if (!$fantasyTeam.playerIds.includes(player.id)) {
        sessionAddedPlayers.push(player.id);
      }
    }
  }

  function canAddPlayerToCurrentFormation(
    player: PlayerDTO,
    team: FantasyTeam,
    formation: string
  ): boolean {
    const positionCounts: { [key: number]: number } = {
      0: 0,
      1: 0,
      2: 0,
      3: 0,
    };
    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[teamPlayer.position]++;
      }
    });

    positionCounts[player.position]++;

    const [def, mid, fwd] = formation.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce(
      (a, b) => a + b,
      0
    );

    return totalPlayers + additionalPlayersNeeded <= 11;
  }

  function addPlayerToTeam(
    player: PlayerDTO,
    team: FantasyTeam,
    formation: string
  ) {
    const indexToAdd = getAvailablePositionIndex(
      player.position,
      team,
      formation
    );
    if (indexToAdd === -1) {
      console.error("No available position to add the player.");
      return;
    }

    fantasyTeam.update((currentTeam) => {
      if (!currentTeam) return null;
      const newPlayerIds = Uint16Array.from(currentTeam.playerIds);
      if (indexToAdd < newPlayerIds.length) {
        newPlayerIds[indexToAdd] = player.id;
        return { ...currentTeam, playerIds: newPlayerIds };
      } else {
        console.error(
          "Index out of bounds when attempting to add player to team."
        );
        return currentTeam;
      }
    });

    updateCaptainIfNeeded($fantasyTeam!);
  }

  function getAvailablePositionIndex(
    position: number,
    team: FantasyTeam,
    formation: string
  ): number {
    const formationArray = formations[formation].positions;
    for (let i = 0; i < formationArray.length; i++) {
      if (formationArray[i] === position && team.playerIds[i] === 0) {
        return i;
      }
    }
    return -1;
  }

  function findValidFormationWithPlayer(
    team: FantasyTeam,
    player: PlayerDTO
  ): string {
    const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[teamPlayer.position]++;
      }
    });

    positionCounts[player.position]++;

    let bestFitFormation: string | null = null;
    let minimumAdditionalPlayersNeeded = Number.MAX_SAFE_INTEGER;

    for (const formation of Object.keys(formations) as string[]) {
      if (formation === selectedFormation) {
        continue;
      }

      const formationPositions = formations[formation].positions;
      let formationDetails: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

      formationPositions.forEach((pos) => {
        formationDetails[pos]++;
      });

      const additionalPlayersNeeded = Object.keys(formationDetails).reduce(
        (total, key) => {
          const position = parseInt(key);
          return (
            total +
            Math.max(0, formationDetails[position] - positionCounts[position])
          );
        },
        0
      );

      if (
        additionalPlayersNeeded < minimumAdditionalPlayersNeeded &&
        formationDetails[player.position] > positionCounts[player.position] - 1
      ) {
        bestFitFormation = formation;
        minimumAdditionalPlayersNeeded = additionalPlayersNeeded;
      }
    }

    if (bestFitFormation) {
      return bestFitFormation;
    }

    console.error("No valid formation found for the player");
    return selectedFormation;
  }

  function repositionPlayersForNewFormation(
    team: FantasyTeam,
    newFormation: string
  ) {
    const newFormationArray = formations[newFormation].positions;
    let newPlayerIds: number[] = new Array(11).fill(0);

    team.playerIds.forEach((playerId) => {
      const player = $playerStore.find((p) => p.id === playerId);
      if (player) {
        for (let i = 0; i < newFormationArray.length; i++) {
          if (
            newFormationArray[i] === player.position &&
            newPlayerIds[i] === 0
          ) {
            newPlayerIds[i] = playerId;
            break;
          }
        }
      }
    });

    team.playerIds = newPlayerIds;
  }

  function getActualIndex(rowIndex: number, colIndex: number): number {
    let startIndex = gridSetup
      .slice(0, rowIndex)
      .reduce((sum, currentRow) => sum + currentRow.length, 0);
    return startIndex + colIndex;
  }

  function removePlayer(playerId: number) {
    selectedPosition = -1;
    selectedColumn = -1;
    fantasyTeam.update((currentTeam) => {
      if (!currentTeam) return null;

      const playerIndex = currentTeam.playerIds.indexOf(playerId);
      if (playerIndex === -1) {
        console.error("Player not found in the team.");
        return currentTeam;
      }

      const newPlayerIds = Uint16Array.from(currentTeam.playerIds);
      newPlayerIds[playerIndex] = 0;

      if (sessionAddedPlayers.includes(playerId)) {
        if (!newTeam && activeGameweek > 1) {
          transfersAvailable.update((n) => n + 1);
        }
        sessionAddedPlayers = sessionAddedPlayers.filter(
          (id) => id !== playerId
        );
      }
      bankBalance.update(
        (n) =>
          n + Number($playerStore.find((x) => x.id === playerId)?.value) ?? 0
      );

      return { ...currentTeam, playerIds: newPlayerIds };
    });

    updateCaptainIfNeeded($fantasyTeam!);
  }

  function setCaptain(playerId: number) {
    selectedPosition = -1;
    selectedColumn = -1;
    fantasyTeam.update((currentTeam) => {
      if (!currentTeam) return null;
      return { ...currentTeam, captainId: playerId };
    });
  }

  function updateCaptainIfNeeded(currentTeam: FantasyTeam) {
    if (
      !currentTeam.captainId ||
      currentTeam.captainId === 0 ||
      !currentTeam.playerIds.includes(currentTeam.captainId)
    ) {
      const newCaptainId = getHighestValuedPlayerId(currentTeam);
      setCaptain(newCaptainId);
    }
  }

  function getHighestValuedPlayerId(team: FantasyTeam): number {
    let highestValue = 0;
    let highestValuedPlayerId = 0;

    team.playerIds.forEach((playerId) => {
      const player = $playerStore.find((p) => p.id === playerId);
      if (player && Number(player.value) > highestValue) {
        highestValue = Number(player.value);
        highestValuedPlayerId = playerId;
      }
    });

    return highestValuedPlayerId;
  }

  function disableInvalidFormations() {
    if (!$fantasyTeam || !$fantasyTeam.playerIds) {
      return;
    }

    const formations = getAvailableFormations($playerStore, $fantasyTeam);
    availableFormations.set(formations);
  }

  function updateTeamValue() {
    const team = $fantasyTeam;
    if (team) {
      let totalValue = 0;
      team.playerIds.forEach((id) => {
        const player = $playerStore.find((p) => p.id === id);
        if (player) {
          totalValue += Number(player.value);
        }
      });
      teamValue = totalValue / 4;
    }
  }

  function checkSaveButtonConditions(): boolean {
    const teamCount = new Map();
    for (const playerId of $fantasyTeam?.playerIds || []) {
      if (playerId > 0) {
        const player = $playerStore.find((p) => p.id === playerId);
        if (player) {
          teamCount.set(player.teamId, (teamCount.get(player.teamId) || 0) + 1);
          if (teamCount.get(player.teamId) > 2) {
            return false;
          }
        }
      }
    }

    if (!isBonusConditionMet($fantasyTeam)) {
      return false;
    }

    if ($fantasyTeam?.playerIds.filter((id) => id > 0).length !== 11) {
      return false;
    }

    if ($bankBalance < 0) {
      return false;
    }

    if ($transfersAvailable < 0) {
      return false;
    }

    if (!isValidFormation($fantasyTeam, selectedFormation)) {
      return false;
    }

    return true;
  }

  function isBonusConditionMet(team: FantasyTeam | null): boolean {
    if (!team) {
      return false;
    }

    const gameweekCounts: { [key: number]: number } = {};

    const bonusGameweeks = [
      team.hatTrickHeroGameweek,
      team.teamBoostGameweek,
      team.captainFantasticGameweek,
      team.braceBonusGameweek,
      team.passMasterGameweek,
      team.goalGetterGameweek,
      team.noEntryGameweek,
      team.safeHandsGameweek,
    ];

    for (const gw of bonusGameweeks) {
      if (gw !== 0) {
        gameweekCounts[gw] = (gameweekCounts[gw] || 0) + 1;
        if (gameweekCounts[gw] > 1) {
          return false;
        }
      }
    }

    return true;
  }

  function isValidFormation(
    team: FantasyTeam,
    selectedFormation: string
  ): boolean {
    const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };
    team.playerIds.forEach((id) => {
      const teamPlayer = $playerStore.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[teamPlayer.position]++;
      }
    });

    const [def, mid, fwd] = selectedFormation.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce(
      (a, b) => a + b,
      0
    );

    return totalPlayers + additionalPlayersNeeded <= 11;
  }

  function autofillTeam() {
    if (!$fantasyTeam || !$playerStore) return;

    let updatedFantasyTeam = {
      ...$fantasyTeam,
      playerIds: Uint16Array.from($fantasyTeam.playerIds),
    };
    let remainingBudget = $bankBalance;

    const teamCounts = new Map<number, number>();
    updatedFantasyTeam.playerIds.forEach((playerId) => {
      if (playerId > 0) {
        const player = $playerStore.find((p) => p.id === playerId);
        if (player) {
          teamCounts.set(
            player.teamId,
            (teamCounts.get(player.teamId) || 0) + 1
          );
        }
      }
    });

    const formationPositions = formations[selectedFormation].positions;

    formationPositions.forEach((position, index) => {
      if (remainingBudget <= 0) return;
      if (updatedFantasyTeam.playerIds[index] > 0) return; // Skip positions already filled

      const availablePlayers = $playerStore
        .filter(
          (player) =>
            player.position === position &&
            !updatedFantasyTeam.playerIds.includes(player.id) &&
            (teamCounts.get(player.teamId) || 0) < 2 // Check for team player limit
        )
        .sort((a, b) => Number(a.value) - Number(b.value));

      for (let player of availablePlayers) {
        const potentialNewBudget = remainingBudget - Number(player.value);
        if (potentialNewBudget >= 0) {
          updatedFantasyTeam.playerIds[index] = player.id;
          remainingBudget = potentialNewBudget;
          teamCounts.set(
            player.teamId,
            (teamCounts.get(player.teamId) || 0) + 1
          );
          break; // Found a suitable player, break the loop
        }
      }
    });

    if (remainingBudget >= 0) {
      fantasyTeam.set(updatedFantasyTeam);
      bankBalance.set(remainingBudget);
    }
  }

  async function saveFantasyTeam() {
    busyStore.startBusy({
      initiator: "save-team",
      text: "Saving fantasy team...",
    });

    let team = $fantasyTeam;
    if (team?.captainId === 0 || !team?.playerIds.includes(team?.captainId)) {
      team!.captainId = getHighestValuedPlayerId(team!);
    }

    if (
      team?.safeHandsGameweek === activeGameweek &&
      team?.safeHandsPlayerId !== team?.playerIds[0]
    ) {
      team.safeHandsPlayerId = team?.playerIds[0];
    }

    if (
      team?.captainFantasticGameweek === activeGameweek &&
      team?.captainFantasticPlayerId !== team?.captainId
    ) {
      team.captainFantasticPlayerId = team?.captainId;
    }

    try {
      await managerStore.saveFantasyTeam(
        team!,
        activeGameweek,
        $bonusUsedInSession
      );
      busyStore.stopBusy("save-team");
      toastsShow({
        text: "Team saved successully!",
        level: "success",
        position: "bottom",
        duration: 2000,
      });
    } catch (error) {
      toastsError({
        msg: { text: "Error saving team." },
        err: error,
      });
      console.error("Error saving team:", error);
    } finally {
      busyStore.stopBusy("save-team");
    }
  }
</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <AddPlayerModal
      {handlePlayerSelection}
      filterPosition={selectedPosition}
      filterColumn={selectedColumn}
      visible={showAddPlayer}
      {closeAddPlayerModal}
      {fantasyTeam}
      {bankBalance}
    />
    <div>

      <div class="hidden xl:flex page-header-wrapper">
        <div class="content-panel lg:w-1/2">
          <div class="flex-grow mb-4 xl:mb-0">
            <p class="content-panel-header">Gameweek</p>
            <p class="content-panel-stat">
              {activeGameweek}
            </p>
            <p class="content-panel-header">
              {activeSeason}
            </p>
          </div>

          <div class="vertical-divider" />

          <div class="flex-grow mb-4 xl:mb-0">
            <p class="content-panel-header mt-4 xl:mt-0">Kick Off:</p>
            <div class="flex">
              <p class="content-panel-stat">
                {countdownDays}<span class="countdown-text">d</span>
                : {countdownHours}<span class="countdown-text">h</span>
                : {countdownMinutes}<span class="countdown-text">m</span>
              </p>
            </div>
            <p class="content-panel-header">
              {nextFixtureDate} | {nextFixtureTime}
            </p>
          </div>

          <div class="vertical-divider" />

          <div class="flex-grow mb-0 mt-4 xl:mt-0">
            <p class="content-panel-header">Players</p>
            <p class="content-panel-stat">
              {$fantasyTeam?.playerIds.filter((x) => x > 0).length}/11
            </p>
            <p class="content-panel-header">Selected</p>
          </div>
  
        </div>

        <div class="content-panel lg:w-1/2">
          
          <div class="flex-grow mb-4 xl:mb-0">
            <p class="content-panel-header">Team Value</p>
            <p class="content-panel-stat">
              £{teamValue.toFixed(2)}m
            </p>
            <p class="content-panel-header">GBP</p>
          </div>
          
          <div class="vertical-divider" />

          <div class="flex-grow mb-4 xl:mb-0 mt-4 xl:mt-0">
            <p class="content-panel-header">Bank Balance</p>
            <p class="content-panel-stat">
              £{($bankBalance / 4).toFixed(2)}m
            </p>
            <p class="content-panel-header">GBP</p>
          </div>

          <div class="vertical-divider" />

          <div class="flex-grow mb-4 xl:mb-0 mt-4 xl:mt-0">
            <p class="content-panel-header">Transfers</p>
            <p class="content-panel-stat">
              {$transfersAvailable === Infinity
                ? "Unlimited"
                : $transfersAvailable}
            </p>
            <p class="content-panel-header">Available</p>
          </div>
        </div>
      </div>

      <div class="flex xl:flex flex-col md:flex-row">
        
        <div class="bg-panel rounded-md xs:flex flex-row">

          <div class="w-full xs:w-1/2">
            <div class="flex">
              <p class="mx-4 mt-4">Gameweek {activeGameweek} {activeSeason}</p>
            </div>
            <div class="flex flex-row ml-4">
              <button
                class={`btn ${
                  pitchView ? `fpl-button` : `inactive-btn`
                } rounded-l-md tab-switcher-label`}
                on:click={showPitchView}
              >
                Pitch View
              </button>
              <button
                class={`btn ${
                  !pitchView ? `fpl-button` : `inactive-btn`
                } rounded-r-md tab-switcher-label`}
                on:click={showListView}
              >
                List View
              </button>
            </div>
          </div>
          <div class="w-full xs:w-1/2">
            
            <div class="ml-5">
              <span>
                Formation:
                <select
                  class="px-4 mb-1 border-sm fpl-dropdown text-center text-center"
                  bind:value={selectedFormation}
                >
                  {#each $availableFormations as formation}
                    <option value={formation}>{formation}</option>
                  {/each}
                </select>
              </span>
            </div>
  
            <div class="flex flex-row mx-2">
              <button
                disabled={$fantasyTeam?.playerIds
                  ? $fantasyTeam?.playerIds.filter((x) => x === 0).length === 0
                  : true}
                on:click={autofillTeam}
                class={`button-base  
                ${
                  $fantasyTeam?.playerIds &&
                  $fantasyTeam?.playerIds.filter((x) => x === 0).length > 0
                    ? "fpl-purple-btn"
                    : "bg-gray-500"
                } text-white m-2`}
              >
                Auto Fill
              </button>
              <button
                disabled={!isSaveButtonActive}
                on:click={saveFantasyTeam}
                class={`button-base ${
                  isSaveButtonActive ? "fpl-purple-btn" : "bg-gray-500"
                } text-white m-2`}
              >
                Save Team
              </button>
            </div>
          </div>

          

          
        </div>
      </div>
        
      <div class="flex flex-col xl:flex-row mt-2 xl:mt-0">
        {#if pitchView}
          <div class="relative w-full xl:w-1/2 mt-2">
            <img
              src="pitch.png"
              alt="pitch"
              class="w-full h-auto"
              on:load={updatePitchHeight}
              bind:this={pitchElement}
            />
            {#if gridSetupComplete}
              <div class="absolute top-0 left-0 right-0 bottom-0">
                <div class={`flex justify-around w-full h-auto`}>
                  <div class="relative inline-block">
                    <img
                      class="h-6 sm:h-8 md:h-12 m-0 md:m-1"
                      src="board.png"
                      alt="OpenChat"
                    />
                    <div class="absolute top-0 left-0 w-full h-full">
                      <a
                        class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
                        target="_blank"
                        href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
                      >
                        <OpenChatIcon className="h-4 md:h-6 mr-1 md:mr-2" />
                        <span class="text-white text-xs md:text-xl mr-4 oc-logo"
                          >OpenChat</span
                        >
                      </a>
                    </div>
                  </div>
                  <div class="relative inline-block">
                    <img
                      class="h-6 sm:h-8 md:h-12 m-0 md:m-1"
                      src="board.png"
                      alt="OpenChat"
                    />
                    <div class="absolute top-0 left-0 w-full h-full">
                      <a
                        class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0"
                        target="_blank"
                        href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai"
                      >
                        <OpenChatIcon className="h-4 md:h-6 mr-1 md:mr-2" />
                        <span class="text-white text-xs md:text-xl mr-4 oc-logo"
                          >OpenChat</span
                        >
                      </a>
                    </div>
                  </div>
                </div>
                {#each gridSetup as row, rowIndex}
                  <div
                    class="flex justify-around items-center w-full"
                    style="height: {rowHeight}px;"
                  >
                    {#each row as _, colIndex (colIndex)}
                      {@const actualIndex = getActualIndex(rowIndex, colIndex)}
                      {@const playerIds = $fantasyTeam?.playerIds ?? []}
                      {@const playerId = playerIds[actualIndex]}
                      {@const player = $playerStore.find(
                        (p) => p.id === playerId
                      )}
                      <div
                        class="flex flex-col justify-center items-center flex-1 player-card"
                      >
                        {#if playerId > 0 && player}
                          {@const team = $teamStore.find(
                            (x) => x.id === player.teamId
                          )}
                          <div class="flex flex-col items-center text-center">
                            <div class="flex justify-center items-center">
                              <div
                                class="flex justify-between items-end w-full"
                              >
                                <button
                                  on:click={() => removePlayer(player.id)}
                                  class="bg-red-600 mb-1 rounded-sm"
                                >
                                  <RemovePlayerIcon
                                    className="w-4 h-4 sm:w-6 sm:h-6 p-1"
                                  />
                                </button>
                                <div
                                  class="flex justify-center items-center flex-grow"
                                >
                                  <ShirtIcon
                                    className="h-6 xs:h-12 sm:h-12 md:h-16 lg:h-20 xl:h-12 2xl:h-16"
                                    primaryColour={team?.primaryColourHex}
                                    secondaryColour={team?.secondaryColourHex}
                                    thirdColour={team?.thirdColourHex}
                                  />
                                </div>
                                {#if $fantasyTeam?.captainId === playerId}
                                  <span class="mb-1">
                                    <ActiveCaptainIcon
                                      className="w-4 h-4 sm:w-7 sm:h-7 md:w-6 md:h-6"
                                    />
                                  </span>
                                {:else}
                                  <button
                                    on:click={() => setCaptain(player.id)}
                                    class="mb-1"
                                  >
                                    <PlayerCaptainIcon
                                      className="w-4 h-4 sm:w-7 sm:h-7 md:w-6 md:h-6"
                                    />
                                  </button>
                                {/if}
                              </div>
                            </div>
                            <div
                              class="flex flex-col justify-center items-center text-xs sm:text-xs"
                            >
                              <div
                                class="flex justify-center items-center bg-gray-700 rounded-t-md md:px-2 sm:py-1
                                min-w-[60px] xs:min-w-[90px] sm:min-w-[120px]
                                max-w-[60px] xs:max-w-[90px] sm:max-w-[120px]"
                              >
                                <p class="hidden sm:flex sm:min-w-[15px]">
                                  {getPositionAbbreviation(player.position)}
                                </p>
                                <svelte:component
                                  this={getFlagComponent(player.nationality)}
                                  class="hidden xs:flex h-2 w-2 mr-1 sm:h-4 sm:w-4 sm:mx-2 min-w-[15px]"
                                />
                                <p
                                  class="hidden xs:block truncate min-w-[50px] max-w-[50px] xs:min-w-[60px] xs:max-w-[60px]"
                                >
                                  {player.firstName.length > 0
                                    ? player.firstName.substring(0, 1) + "."
                                    : ""}
                                  {player.lastName}
                                </p>
                                <p
                                  class="xs:hidden truncate min-w-[50px] max-w-[50px]"
                                >
                                  {player.lastName}
                                </p>
                              </div>
                              <div
                                class="flex justify-center items-center bg-white text-black md:px-2 sm:py-1 rounded-b-md
                                min-w-[60px] xs:min-w-[90px] sm:min-w-[120px]
                                max-w-[60px] xs:max-w-[90px] sm:max-w-[120px]"
                              >
                                <p class="collapse sm:visible sm:min-w-[20px]">
                                  {team?.abbreviatedName}
                                </p>
                                <BadgeIcon
                                  className="hidden xs:flex h-4 w-4 sm:mx-1 min-w-[15px]"
                                  primaryColour={team?.primaryColourHex}
                                  secondaryColour={team?.secondaryColourHex}
                                  thirdColour={team?.thirdColourHex}
                                />
                                <p class="truncate min-w-[50px] max-w-[50px]">
                                  £{(Number(player.value) / 4).toFixed(2)}m
                                </p>
                              </div>
                            </div>
                          </div>
                        {:else}
                          <button
                            on:click={() => loadAddPlayer(rowIndex, colIndex)}
                            class="flex items-center"
                          >
                            <AddPlayerIcon
                              className="h-12 sm:h-16 md:h-20 lg:h-24 xl:h-16 2xl:h-20"
                            />
                          </button>
                        {/if}
                      </div>
                    {/each}
                  </div>
                {/each}
              </div>
            {/if}
          </div>
        {:else}
          <div class="bg-panel rounded-md">
            {#each gridSetup as row, rowIndex}
              {#if rowIndex === 0}
                <div
                  class="flex items-center justify-between py-2 bg-light-gray border-b border-gray-700 px-4"
                >
                  <div class="w-1/3">Goalkeeper</div>
                  <div class="w-1/6">(c)</div>
                  <div class="w-1/3">Team</div>
                  <div class="w-1/6">Value</div>
                  <div class="w-1/6">&nbsp;</div>
                </div>
              {/if}
              {#if rowIndex === 1}
                <div
                  class="flex items-center justify-between py-2 bg-light-gray border-b border-gray-700 px-4"
                >
                  <div class="w-1/3">Defenders</div>
                  <div class="w-1/6">(c)</div>
                  <div class="w-1/3">Team</div>
                  <div class="w-1/6">Value</div>
                  <div class="w-1/6">&nbsp;</div>
                </div>
              {/if}
              {#if rowIndex === 2}
                <div
                  class="flex items-center justify-between py-2 bg-light-gray border-b border-gray-700 px-4"
                >
                  <div class="w-1/3">Midfielders</div>
                  <div class="w-1/6">(c)</div>
                  <div class="w-1/3">Team</div>
                  <div class="w-1/6">Value</div>
                  <div class="w-1/6">&nbsp;</div>
                </div>
              {/if}
              {#if rowIndex === 3}
                <div
                  class="flex items-center justify-between py-2 bg-light-gray border-b border-gray-700 px-4"
                >
                  <div class="w-1/3">Forwards</div>
                  <div class="w-1/6">(c)</div>
                  <div class="w-1/3">Team</div>
                  <div class="w-1/6">Value</div>
                  <div class="w-1/6">&nbsp;</div>
                </div>
              {/if}
              {#each row as _, colIndex (colIndex)}
                {@const actualIndex = getActualIndex(rowIndex, colIndex)}
                {@const playerIds = $fantasyTeam?.playerIds ?? []}
                {@const playerId = playerIds[actualIndex]}
                {@const player = $playerStore.find((p) => p.id === playerId)}
                {@const team = $teamStore.find(
                  (x) => x.id === player?.teamId
                )}

                <div class="flex items-center justify-between py-2 px-4">
                  {#if playerId > 0 && player}
                    <div class="w-1/3">
                      {player.firstName}
                      {player.lastName}
                    </div>
                    <div class="w-1/6 flex items-center">
                      {#if $fantasyTeam?.captainId === playerId}
                        <span>
                          <ActiveCaptainIcon className="w-6 h-6" />
                        </span>
                      {:else}
                        <button on:click={() => setCaptain(player.id)}>
                          <PlayerCaptainIcon className="w-6 h-6" />
                        </button>
                      {/if}
                    </div>
                    <div class="flex w-1/3 items-center">
                      <BadgeIcon
                        className="h-5 w-5 mr-2"
                        primaryColour={team?.primaryColourHex}
                        secondaryColour={team?.secondaryColourHex}
                        thirdColour={team?.thirdColourHex}
                      />
                      <p>
                        {team?.name}
                      </p>
                    </div>
                    <div class="w-1/6">
                      £{(Number(player.value) / 4).toFixed(2)}m
                    </div>
                    <div class="w-1/6 flex items-center">
                      <button
                        on:click={() => removePlayer(player.id)}
                        class="bg-red-600 mb-1 rounded-sm"
                      >
                        <RemovePlayerIcon className="w-6 h-6 p-2" />
                      </button>
                    </div>
                  {:else}
                    <div class="w-1/3">-</div>
                    <div class="w-1/6">-</div>
                    <div class="w-1/3">-</div>
                    <div class="w-1/6">-</div>
                    <div class="w-1/6 flex items-center">
                      <button
                        on:click={() => loadAddPlayer(rowIndex, colIndex)}
                        class="rounded fpl-button flex items-center"
                      >
                        <AddIcon className="w-6 h-6 p-2" />
                      </button>
                    </div>
                  {/if}
                </div>
              {/each}
            {/each}
          </div>
        {/if}
        <div class="hidden xl:flex w-full xl:w-1/2">
          <SimpleFixtures />
        </div>
      </div>

      <div class="content-panel flex xl:hidden mt-4">
       
        <div class="flex-grow">
          <div class="ml-1">
            <p class="content-panel-header">Players</p>
            <p class="content-panel-stat">
              {$fantasyTeam?.playerIds.filter((x) => x > 0).length}/11
            </p>
            <p class="content-panel-header">Selected</p>
          </div>
        </div>

       
        <div class="vertical-divider" />
        <div class="flex-grow">
          <div class="ml-1">
            <p class="content-panel-header">Team Value</p>
            <p class="content-panel-stat">
              £{teamValue.toFixed(2)}m
            </p>
            <p class="content-panel-header">GBP</p>
          </div>
        </div>

        
        <div class="vertical-divider" />
        <div class="flex-grow">
          <div class="ml-1">
            <p class="content-panel-header">Bank Balance</p>
            <p class="content-panel-stat">
              £{($bankBalance / 4).toFixed(2)}m
            </p>
            <p class="content-panel-header">GBP</p>
          </div>
        </div>

        
        <div class="vertical-divider" />
        <div class="flex-grow">
          <div class="ml-1">
            <p class="content-panel-header">Transfers</p>
            <p class="content-panel-stat">
              {$transfersAvailable === Infinity
                ? "Unlimited"
                : $transfersAvailable}
            </p>
            <p class="content-panel-header">Available</p>
          </div>
        </div>
      </div>

      <div class="flex xl:hidden w-full mt-4">
        <SimpleFixtures />
      </div>
      <BonusPanel {fantasyTeam} {activeGameweek} />
    </div>
  {/if}
</Layout>
