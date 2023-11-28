<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import { writable, get } from "svelte/store";
  import type {
    FantasyTeam,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import BonusPanel from "$lib/components/pick-team/bonus-panel.svelte";
  import AddPlayerModal from "$lib/components/pick-team/add-player-modal.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import OpenChatIcon from "$lib/icons/OpenChatIcon.svelte";
  import SimpleFixtures from "$lib/components/simple-fixtures.svelte";
  import AddPlayerIcon from "$lib/icons/AddPlayerIcon.svelte";
  import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
  import AddIcon from "$lib/icons/AddIcon.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import RemovePlayerIcon from "$lib/icons/RemovePlayerIcon.svelte";
  import PlayerCaptainIcon from "$lib/icons/PlayerCaptainIcon.svelte";
  import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
  import { SystemService } from "$lib/services/SystemService";
  import { TeamService } from "$lib/services/TeamService";
  import { ManagerService } from "$lib/services/ManagerService";
  import { FixtureService } from "$lib/services/FixtureService";
  import { PlayerService } from "$lib/services/PlayerService";
  import {
    formatUnixDateToReadable,
    formatUnixTimeToTime,
    getCountdownTime,
    getPositionAbbreviation,
    getAvailableFormations,
  } from "../../lib/utils/Helpers";
  import { getFlagComponent } from "../../lib/utils/Helpers";

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

  let activeSeason = "-";
  let activeGameweek = -1;
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  let nextFixtureHomeTeam: Team | undefined = undefined;
  let nextFixtureAwayTeam: Team | undefined = undefined;
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let selectedFormation: string = "4-4-2";
  let selectedPosition = -1;
  let selectedColumn = -1;
  let pitchView = true;
  let showAddPlayer = false;
  let progress = 0;
  let isLoading = true;
  let teamValue = 0;
  let newTeam = true;

  let teams: Team[];
  let players: PlayerDTO[];
  let sessionAddedPlayers: number[] = [];
  const fantasyTeam = writable<FantasyTeam | null>(null);
  const transfersAvailable = writable(newTeam ? Infinity : 3);
  const bankBalance = writable(1200);

  $: gridSetup = getGridSetup(selectedFormation);

  $: if (players && $fantasyTeam) {
    disableInvalidFormations();
    updateTeamValue();
  }

  $: isSaveButtonActive = checkSaveButtonConditions();

  onMount(async () => {
    const systemService = new SystemService();
    const teamService = new TeamService();
    const fixtureService = new FixtureService();
    const managerService = new ManagerService();
    const playerService = new PlayerService();

    await systemService.updateSystemStateData();
    await fixtureService.updateFixturesData();
    await teamService.updateTeamsData();
    await playerService.updatePlayersData();

    isLoading = true;
    try {
      progress = 20;

      const storedViewMode = localStorage.getItem("viewMode");
      if (storedViewMode) {
        pitchView = storedViewMode === "pitch";
      }

      let systemState = await systemService.getSystemState();
      activeGameweek = systemState?.activeGameweek ?? activeGameweek;
      activeSeason = systemState?.activeSeason.name ?? activeSeason;

      progress = 40;

      let nextFixture = await fixtureService.getNextFixture();

      teams = await teamService.getTeams();

      nextFixtureHomeTeam = await teamService.getTeamById(
        nextFixture.homeTeamId
      );

      nextFixtureAwayTeam = await teamService.getTeamById(
        nextFixture.awayTeamId
      );

      let userFantasyTeam = await managerService.getFantasyTeam();
      fantasyTeam.set(userFantasyTeam);

      let principalId = get(fantasyTeam)?.principalId ?? "";

      if (activeGameweek > 1 && principalId.length > 0) {
        newTeam = false;
        transfersAvailable.set(userFantasyTeam.transfersAvailable);
        bankBalance.set(userFantasyTeam.bankBalance);
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

      nextFixtureDate = formatUnixDateToReadable(Number(nextFixture.kickOff));
      nextFixtureTime = formatUnixTimeToTime(Number(nextFixture.kickOff));

      progress = 60;
      let countdownTime = getCountdownTime(Number(nextFixture.kickOff));
      countdownDays = countdownTime.days.toString();
      countdownHours = countdownTime.hours.toString();
      countdownMinutes = countdownTime.minutes.toString();

      progress = 80;
      players = await playerService.getPlayers();

      progress = 100;
      isLoading = false;
    } catch (error) {
      console.error("Error fetching homepage data:", error);
      isLoading = false;
    }
  });

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
    const currentFantasyTeam = get(fantasyTeam);
    if (currentFantasyTeam) {
      if (
        canAddPlayerToCurrentFormation(
          player,
          currentFantasyTeam,
          selectedFormation
        )
      ) {
        addPlayerToTeam(player, currentFantasyTeam, selectedFormation);
      } else {
        const newFormation = findValidFormationWithPlayer(
          currentFantasyTeam,
          player
        );
        repositionPlayersForNewFormation(currentFantasyTeam, newFormation);
        selectedFormation = newFormation;
        addPlayerToTeam(player, currentFantasyTeam, newFormation);
      }
      if (!newTeam && activeGameweek > 1) {
        transfersAvailable.update((n) => (n > 0 ? n - 1 : 0));
      }
      bankBalance.update((n) =>
        n - Number(player.value) > 0 ? n - Number(player.value) : n
      );

      if (!currentFantasyTeam.playerIds.includes(player.id)) {
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
      const teamPlayer = players.find((p) => p.id === id);
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

    updateCaptainIfNeeded(get(fantasyTeam)!);
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
    const positionCounts: Record<number, number> = { 0: 1, 1: 0, 2: 0, 3: 0 };

    team.playerIds.forEach((id) => {
      const teamPlayer = players.find((p) => p.id === id);
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
      const player = players.find((p) => p.id === playerId);
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
        (n) => n + Number(players.find((x) => x.id == playerId)?.value) ?? 0
      );

      return { ...currentTeam, playerIds: newPlayerIds };
    });

    updateCaptainIfNeeded(get(fantasyTeam)!);
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
      currentTeam.captainId == 0 ||
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
      const player = players.find((p) => p.id === playerId);
      if (player && Number(player.value) > highestValue) {
        highestValue = Number(player.value);
        highestValuedPlayerId = playerId;
      }
    });

    return highestValuedPlayerId;
  }

  function disableInvalidFormations() {
    const currentTeam = get(fantasyTeam);
    if (!currentTeam || !currentTeam.playerIds) {
      return;
    }

    const formations = getAvailableFormations(players, currentTeam);
    availableFormations.set(formations);
  }

  function updateTeamValue() {
    const team = get(fantasyTeam);
    if (team) {
      let totalValue = 0;
      team.playerIds.forEach((id) => {
        const player = players.find((p) => p.id === id);
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
        const player = players.find((p) => p.id === playerId);
        if (player) {
          teamCount.set(player.teamId, (teamCount.get(player.teamId) || 0) + 1);
          if (teamCount.get(player.teamId) > 1) {
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

    if (!isValidFormation(players, $fantasyTeam, selectedFormation)) {
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
    players: PlayerDTO[],
    team: FantasyTeam,
    selectedFormation: string
  ): boolean {
    const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };
    team.playerIds.forEach((id) => {
      const teamPlayer = players.find((p) => p.id === id);
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
    const currentFantasyTeam = get(fantasyTeam);
    if (!currentFantasyTeam || !players) return;

    let updatedFantasyTeam = {
      ...currentFantasyTeam,
      playerIds: new Uint16Array(11),
    };
    let remainingBudget = get(bankBalance);

    const teamCounts = new Map<number, number>();
    updatedFantasyTeam.playerIds.forEach((playerId) => {
      if (playerId > 0) {
        const player = players.find((p) => p.id === playerId);
        if (player) {
          teamCounts.set(
            player.teamId,
            (teamCounts.get(player.teamId) || 0) + 1
          );
        }
      }
    });

    let eligibleTeams = Array.from(
      new Set(players.map((player) => player.teamId))
    ).filter((id) => id > 0);
    eligibleTeams.sort(() => Math.random() - 0.5);

    const formationPositions = formations[selectedFormation].positions;

    formationPositions.forEach((position, index) => {
      if (remainingBudget <= 0 || eligibleTeams.length === 0) return;

      const teamId = eligibleTeams.shift();
      if (teamId === undefined) return;

      const availablePlayers = players.filter(
        (player) =>
          player.position === position &&
          player.teamId === teamId &&
          !updatedFantasyTeam.playerIds.includes(player.id) &&
          (teamCounts.get(player.teamId) || 0) < 1
      );

      availablePlayers.sort((a, b) => Number(a.value) - Number(b.value));
      const lowerHalf = availablePlayers.slice(
        0,
        Math.ceil(availablePlayers.length / 2)
      );
      const selectedPlayer =
        lowerHalf[Math.floor(Math.random() * lowerHalf.length)];

      if (selectedPlayer) {
        const potentialNewBudget =
          remainingBudget - Number(selectedPlayer.value);
        if (potentialNewBudget < 0) {
          return;
        }
        updatedFantasyTeam.playerIds[index] = selectedPlayer.id;
        remainingBudget = potentialNewBudget;
        teamCounts.set(
          selectedPlayer.teamId,
          (teamCounts.get(selectedPlayer.teamId) || 0) + 1
        );
      }
    });

    if (remainingBudget >= 0) {
      fantasyTeam.set(updatedFantasyTeam);
      bankBalance.set(remainingBudget);
    }
  }

  async function saveFantasyTeam() {
    isLoading = true;
    let team = get(fantasyTeam);

    if(team?.captainId == 0 || !team?.playerIds.includes(team?.captainId)){
      team!.captainId = getHighestValuedPlayerId(team!);
    }

    if(team?.safeHandsGameweek == activeGameweek && team?.safeHandsPlayerId != team?.playerIds[0]){
      team.safeHandsPlayerId = team?.playerIds[0];
    }

    if(team?.captainFantasticGameweek == activeGameweek && team?.captainFantasticPlayerId != team?.captainId){
      team.captainFantasticPlayerId = team?.captainId;
    }

    let managerService = new ManagerService();
    try {
      await managerService.saveFantasyTeam(team!, activeGameweek);
      isLoading = false;
    } catch (error) {
      console.error("Error fetching homepage data:", error);
    }
  }
</script>

<Layout>
  {#if isLoading}
    <LoadingIcon {progress} />
  {:else}
    <AddPlayerModal
      {handlePlayerSelection}
      filterPosition={selectedPosition}
      filterColumn={selectedColumn}
      {showAddPlayer}
      {closeAddPlayerModal}
      {fantasyTeam}
      {bankBalance}
    />
    <div class="m-4">
      <div class="flex flex-col md:flex-row">
        <div class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xs">Gameweek</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {activeGameweek}
            </p>
            <p class="text-gray-300 text-xs">{activeSeason}</p>
          </div>

          <div
            class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />

          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xs mt-4 md:mt-0">Kick Off:</p>
            <div class="flex">
              <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                {countdownDays}<span class="text-gray-300 text-xs ml-1">d</span>
                : {countdownHours}<span class="text-gray-300 text-xs ml-1"
                  >h</span
                >
                : {countdownMinutes}<span class="text-gray-300 text-xs ml-1"
                  >m</span
                >
              </p>
            </div>
            <p class="text-gray-300 text-xs">
              {nextFixtureDate} | {nextFixtureTime}
            </p>
          </div>

          <div
            class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />

          <div class="flex-grow mb-4 md:mb-0 mt-4 md:mt-0">
            <p class="text-gray-300 text-xs">Players</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {$fantasyTeam?.playerIds.filter((x) => x > 0).length}/11
            </p>
            <p class="text-gray-300 text-xs">Selected</p>
          </div>
        </div>

        <div
          class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Team Value</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              £{teamValue.toFixed(2)}m
            </p>
            <p class="text-gray-300 text-xs">GBP</p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Bank Balance</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              £{($bankBalance / 4).toFixed(2)}m
            </p>
            <p class="text-gray-300 text-xs">GBP</p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Transfers</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {$transfersAvailable === Infinity
                ? "Unlimited"
                : $transfersAvailable}
            </p>
            <p class="text-gray-300 text-xs">Available</p>
          </div>
        </div>
      </div>

      <div class="flex flex-col md:flex-row">
        <div
          class="flex flex-col md:flex-row justify-between items-center text-white m-4 bg-panel p-4 rounded-md md:w-full"
        >
          <div
            class="flex flex-row justify-between md:justify-start flex-grow mb-2 md:mb-0 ml-4 order-3 md:order-1"
          >
            <button
              class={`btn ${
                pitchView ? `fpl-button` : `inactive-btn`
              } px-4 py-2 rounded-l-md font-bold text-md min-w-[125px] my-4`}
              on:click={showPitchView}
              >Pitch View
            </button>
            <button
              class={`btn ${
                !pitchView ? `fpl-button` : `inactive-btn`
              } px-4 py-2 rounded-r-md font-bold text-md min-w-[125px] my-4`}
              on:click={showListView}
              >List View
            </button>
          </div>

          <div
            class="text-center md:text-left w-full mt-4 md:mt-0 md:ml-8 order-2"
          >
            <span class="text-lg"
              >Formation:
              <select
                class="p-2 fpl-dropdown text-lg text-center"
                bind:value={selectedFormation}
              >
                {#each $availableFormations as formation}
                  <option value={formation}>{formation}</option>
                {/each}
              </select>
            </span>
          </div>

          <div class="flex flex-col md:flex-row w-full md:justify-end gap-4 mr-0 md:mr-4 order-1 md:order-3">
            <button
              disabled={$fantasyTeam?.playerIds ? $fantasyTeam?.playerIds.filter((x) => x == 0).length == 0 : true}
              on:click={autofillTeam}
              class={`btn w-full md:w-auto px-4 py-2 rounded ${ $fantasyTeam?.playerIds && $fantasyTeam?.playerIds.filter((x) => x == 0).length > 0 
              ? "fpl-purple-btn" : "bg-gray-500" } text-white min-w-[125px]`}>
              Auto Fill
            </button>
            <button 
              disabled={isSaveButtonActive} 
              on:click={saveFantasyTeam} 
              class={`btn w-full md:w-auto px-4 py-2 rounded  ${isSaveButtonActive ? "fpl-purple-btn" : "bg-gray-500" } text-white min-w-[125px]`}>
              Save Team
            </button>
          </div>
        </div>
      </div>

      <div class="flex flex-col md:flex-row">
        {#if pitchView}
          <div class="relative w-full md:w-1/2 mt-4">
            <img src="pitch.png" alt="pitch" class="w-full" />
            <div class="absolute top-0 left-0 right-0 bottom-0">
              <div class={`flex justify-around w-full h-auto`}>
                <div class="relative inline-block">
                  <img class="h-6 md:h-12 m-0 md:m-1" src="board.png" alt="OpenChat"/>
                  <div class="absolute top-0 left-0 w-full h-full">
                    <a class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0" target="_blank"
                      href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai">
                      <OpenChatIcon className="h-4 md:h-6 mr-1 md:mr-2" />
                      <span class="text-white text-xs md:text-xl mr-4 oc-logo">OpenChat</span>
                    </a>
                  </div>
                </div>
                <div class="relative inline-block">
                  <img class="h-6 md:h-12 m-0 md:m-1" src="board.png" alt="OpenChat"/>
                  <div class="absolute top-0 left-0 w-full h-full">
                    <a class="flex items-center justify-center w-full h-full px-2 md:px-4 ml-1 md:ml-0" target="_blank"
                      href="https://oc.app/community/uf3iv-naaaa-aaaar-ar3ta-cai/channel/231651284198326210763327878874377361028/?ref=zv6hh-xaaaa-aaaar-ac35q-cai">
                      <OpenChatIcon className="h-4 md:h-6 mr-1 md:mr-2" />
                      <span class="text-white text-xs md:text-xl mr-4 oc-logo">OpenChat</span>
                    </a>
                  </div>
                </div>
              </div>
              {#each gridSetup as row, rowIndex}
                <div class="flex justify-around items-center w-full">
                  {#each row as _, colIndex (colIndex)}
                    {@const actualIndex = getActualIndex(rowIndex, colIndex)}
                    {@const playerIds = $fantasyTeam?.playerIds ?? []}
                    {@const playerId = playerIds[actualIndex]}
                    {@const player = players.find((p) => p.id === playerId)}
                    <div class="flex flex-col justify-center items-center flex-1">
                      {#if playerId > 0 && player}
                        {@const team = teams.find((x) => x.id == player.teamId)}
                        <div class="mt-2 mb-2 md:mb-12 flex flex-col items-center text-center">
                          <div class="flex justify-center items-center">
                            <div class="flex justify-between items-end w-full">
                              <button on:click={() => removePlayer(player.id)} class="bg-red-600 mb-1 rounded-sm">
                                <RemovePlayerIcon className="w-5 h-5 p-1" />
                              </button>
                              <div class="flex justify-center items-center flex-grow">
                                <ShirtIcon
                                  className="h-16"
                                  primaryColour={team?.primaryColourHex}
                                  secondaryColour={team?.secondaryColourHex}
                                  thirdColour={team?.thirdColourHex}
                                />
                              </div>
                              {#if $fantasyTeam?.captainId === playerId}
                                <span class="mb-1">
                                  <ActiveCaptainIcon className="w-6 h-6" />
                                </span>
                              {:else}
                                <button on:click={() => setCaptain(player.id)} class="mb-1">
                                  <PlayerCaptainIcon className="w-6 h-6" />
                                </button>
                              {/if}
                            </div>
                          </div>
                          <div class="flex flex-col justify-center items-center text-xs">
                            <div class="flex justify-center items-center bg-gray-700 px-2 py-1 rounded-t-md min-w-[100px]">
                              <p class="min-w-[20px]">
                                {getPositionAbbreviation(player.position)}
                              </p>
                              <svelte:component
                                this={getFlagComponent(player.nationality)}
                                class="h-4 w-4 ml-2 mr-2 min-w-[15px]"
                              />
                              <p class="truncate min-w-[60px] max-w-[60px]">
                                {player.firstName.length > 2
                                  ? player.firstName.substring(0, 1) + "."
                                  : ""}
                                {player.lastName}
                              </p>
                            </div>
                            <div class="flex justify-center items-center bg-white text-black px-2 py-1 rounded-b-md min-w-[100px]">
                              <p class="min-w-[20px]">
                                {team?.abbreviatedName}
                              </p>
                              <BadgeIcon
                                className="h-4 w-4 mr-2 ml-2 min-w-[15px]"
                                primaryColour={team?.primaryColourHex}
                                secondaryColour={team?.secondaryColourHex}
                                thirdColour={team?.thirdColourHex}
                              />
                              <p class="truncate min-w-[60px] max-w-[60px]">
                                £{(Number(player.value) / 4).toFixed(2)}m
                              </p>
                            </div>
                          </div>
                        </div>
                      {:else}
                        <button on:click={() => loadAddPlayer(rowIndex, colIndex)}>
                          <AddPlayerIcon className="h-12 md:h-16 mt-2 mb-2 md:mb-24"/>
                        </button>
                      {/if}
                    </div>
                  {/each}
                </div>
              {/each}
            </div>
          </div>
        {:else}
          <div class="bg-panel rounded-md m-4 flex-1">
            <div class="container-fluid">
              {#each gridSetup as row, rowIndex}
                {#if rowIndex == 0}
                  <div class="flex items-center justify-between py-2 bg-light-gray px-4">
                    <div class="w-1/3">Goalkeeper</div>
                    <div class="w-1/6">(c)</div>
                    <div class="w-1/3">Team</div>
                    <div class="w-1/6">Value</div>
                    <div class="w-1/6">&nbsp;</div>
                  </div>
                {/if}
                {#if rowIndex == 1}
                  <div class="flex items-center justify-between py-2 bg-light-gray px-4">
                    <div class="w-1/3">Defenders</div>
                    <div class="w-1/6">(c)</div>
                    <div class="w-1/3">Team</div>
                    <div class="w-1/6">Value</div>
                    <div class="w-1/6">&nbsp;</div>
                  </div>
                {/if}
                {#if rowIndex == 2}
                  <div class="flex items-center justify-between py-2 bg-light-gray px-4">
                    <div class="w-1/3">Midfielders</div>
                    <div class="w-1/6">(c)</div>
                    <div class="w-1/3">Team</div>
                    <div class="w-1/6">Value</div>
                    <div class="w-1/6">&nbsp;</div>
                  </div>
                {/if}
                {#if rowIndex == 3}
                  <div class="flex items-center justify-between py-2 bg-light-gray px-4">
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
                  {@const player = players.find((p) => p.id === playerId)}
                  {@const team = teams.find((x) => x.id == player?.teamId)}

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
                        <button on:click={() => removePlayer(player.id)} class="bg-red-600 mb-1 rounded-sm">
                          <RemovePlayerIcon className="w-6 h-6 p-2" />
                        </button>
                      </div>
                    {:else}
                      <div class="w-1/3">-</div>
                      <div class="w-1/6">-</div>
                      <div class="w-1/3">-</div>
                      <div class="w-1/6">-</div>
                      <div class="w-1/6 flex items-center">
                        <button on:click={() => loadAddPlayer(rowIndex, colIndex)} class="text-xl rounded fpl-button flex items-center">
                          <AddIcon className="w-6 h-6 p-2" />
                        </button>
                      </div>
                    {/if}
                  </div>
                {/each}
              {/each}
            </div>
          </div>
        {/if}
        <div class="flex w-100 md:w-1/2">
          <SimpleFixtures />
        </div>
      </div>
      <BonusPanel {fantasyTeam} {teams} {players} {activeGameweek} />
    </div>
  {/if}
</Layout>
