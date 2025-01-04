import type { FormationDetails } from "$lib/interfaces/FormationDetails";
import type { GameweekData } from "$lib/interfaces/GameweekData";
import type {
  AppStatusDTO,
  FantasyTeamSnapshot,
  LeagueStatus,
  PickTeamDTO,
  PlayerDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { calculateAgeFromNanoseconds, convertPositionToIndex } from "./helpers";

export const allFormations: Record<string, FormationDetails> = {
  "3-4-3": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3] },
  "3-5-2": { positions: [0, 1, 1, 1, 2, 2, 2, 2, 2, 3, 3] },
  "4-3-3": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 3, 3, 3] },
  "4-4-2": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3] },
  "4-5-1": { positions: [0, 1, 1, 1, 1, 2, 2, 2, 2, 2, 3] },
  "5-4-1": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3] },
  "5-3-2": { positions: [0, 1, 1, 1, 1, 1, 2, 2, 2, 3, 3] },
};

export function getTeamFormation(
  team: PickTeamDTO,
  allPlayers: PlayerDTO[],
): string {
  let teamFormation: string = "4-4-2";
  const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

  team.playerIds.forEach((id) => {
    const teamPlayer = allPlayers.find((p) => p.id === id);

    if (teamPlayer) {
      positionCounts[convertPositionToIndex(teamPlayer.position)]++;
    }
  });

  for (const formation of Object.keys(allFormations)) {
    const formationPositions = allFormations[formation].positions;
    let isMatch = true;

    const formationCount = formationPositions.reduce(
      (acc, pos) => {
        acc[pos] = (acc[pos] || 0) + 1;
        return acc;
      },
      {} as Record<number, number>,
    );

    for (const pos in formationCount) {
      if (formationCount[pos] !== positionCounts[pos]) {
        isMatch = false;
        break;
      }
    }

    if (isMatch) {
      teamFormation = formation;
    }
  }

  return teamFormation;
}

export function getTeamFormationReadOnly(
  team: FantasyTeamSnapshot | null,
  allPlayers: PlayerDTO[],
): string {
  let teamFormation: string = "4-4-2";
  if (!team) {
    return teamFormation;
  }
  const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

  team.playerIds.forEach((id) => {
    const teamPlayer = allPlayers.find((p) => p.id === id);

    if (teamPlayer) {
      positionCounts[convertPositionToIndex(teamPlayer.position)]++;
    }
  });

  for (const formation of Object.keys(allFormations)) {
    const formationPositions = allFormations[formation].positions;
    let isMatch = true;

    const formationCount = formationPositions.reduce(
      (acc, pos) => {
        acc[pos] = (acc[pos] || 0) + 1;
        return acc;
      },
      {} as Record<number, number>,
    );

    for (const pos in formationCount) {
      if (formationCount[pos] !== positionCounts[pos]) {
        isMatch = false;
        break;
      }
    }

    if (isMatch) {
      teamFormation = formation;
    }
  }

  return teamFormation;
}

export function getAvailableFormations(
  players: PlayerDTO[],
  team: PickTeamDTO,
): string[] {
  const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };
  team.playerIds.forEach((id: number) => {
    const teamPlayer = players.find((p) => p.id === id);
    if (teamPlayer) {
      positionCounts[convertPositionToIndex(teamPlayer.position)]++;
    }
  });

  const formations = [
    "3-4-3",
    "3-5-2",
    "4-3-3",
    "4-4-2",
    "4-5-1",
    "5-4-1",
    "5-3-2",
  ];
  return formations.filter((formation) => {
    const [def, mid, fwd] = formation.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce(
      (a, b) => a + b,
      0,
    );

    return totalPlayers + additionalPlayersNeeded <= 11;
  });
}

export function isValidFormation(
  team: PickTeamDTO,
  selectedFormation: string,
  players: PlayerDTO[],
): boolean {
  const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };
  team.playerIds.forEach((id) => {
    const teamPlayer = players.find((p) => p.id === id);
    if (teamPlayer) {
      positionCounts[convertPositionToIndex(teamPlayer.position)]++;
    }
  });

  const [def, mid, fwd] = selectedFormation.split("-").map(Number);
  const minDef = Math.max(0, def - (positionCounts[1] || 0));
  const minMid = Math.max(0, mid - (positionCounts[2] || 0));
  const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
  const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

  const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
  const totalPlayers = Object.values(positionCounts).reduce((a, b) => a + b, 0);

  return totalPlayers + additionalPlayersNeeded <= 11;
}

export function isBonusConditionMet(team: PickTeamDTO | null): boolean {
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
    team.oneNationGameweek,
    team.prospectsGameweek,
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

export function getHighestValuedPlayerId(
  team: PickTeamDTO,
  players: PlayerDTO[],
): number {
  let highestValue = 0;
  let highestValuedPlayerId = 0;

  team.playerIds.forEach((playerId) => {
    const player = players.find((p) => p.id === playerId);
    if (player && player.valueQuarterMillions > highestValue) {
      highestValue = player.valueQuarterMillions;
      highestValuedPlayerId = playerId;
    }
  });

  return highestValuedPlayerId;
}

export function calculateBonusPoints(
  gameweekData: GameweekData[],
  fantasyTeam: FantasyTeamSnapshot,
) {
  gameweekData.forEach((data) => {
    let bonusPoints = 0;
    if (
      fantasyTeam.goalGetterPlayerId === data.player.id &&
      fantasyTeam.goalGetterGameweek === data.gameweek
    ) {
      bonusPoints += data.goals * data.goalPoints * 2;
    }

    if (
      fantasyTeam.passMasterPlayerId === data.player.id &&
      fantasyTeam.passMasterGameweek === data.gameweek
    ) {
      bonusPoints += data.assists * data.assistPoints * 2;
    }

    if (
      fantasyTeam.noEntryPlayerId === data.player.id &&
      fantasyTeam.noEntryGameweek === data.gameweek &&
      data.cleanSheets > 0
    ) {
      bonusPoints += data.points * 2;
    }

    if (
      fantasyTeam.teamBoostClubId === data.player.clubId &&
      fantasyTeam.teamBoostGameweek === data.gameweek
    ) {
      bonusPoints += data.points;
    }

    if (
      fantasyTeam.safeHandsPlayerId === data.player.id &&
      fantasyTeam.safeHandsGameweek === data.gameweek &&
      data.saves >= 5
    ) {
      bonusPoints += data.points * 2;
    }

    if (
      fantasyTeam.oneNationCountryId === data.nationalityId &&
      fantasyTeam.oneNationGameweek === data.gameweek
    ) {
      bonusPoints += data.points;
    }

    if (
      isPlayerUnder21(data.player) &&
      fantasyTeam.prospectsGameweek === data.gameweek
    ) {
      bonusPoints += data.points;
    }

    if (fantasyTeam.braceBonusGameweek === data.gameweek && data.goals >= 2) {
      bonusPoints += data.points;
    }

    if (fantasyTeam.hatTrickHeroGameweek === data.gameweek && data.goals >= 3) {
      bonusPoints += data.points * 2;
    }

    data.bonusPoints = bonusPoints;
    data.totalPoints = data.points + bonusPoints;

    if (
      fantasyTeam.captainFantasticPlayerId === data.player.id &&
      fantasyTeam.captainFantasticGameweek === data.gameweek &&
      data.goals > 0
    ) {
      if (fantasyTeam.captainId === data.player.id) {
        data.totalPoints *= 2;
      }
    } else if (fantasyTeam.captainId === data.player.id) {
      data.totalPoints *= 2;
    }
  });
}

export function sortPlayersByPointsThenValue(gameweekData: GameweekData[]) {
  gameweekData.sort((a, b) => {
    if (b.totalPoints === a.totalPoints) {
      return b.player.valueQuarterMillions - a.player.valueQuarterMillions;
    }
    return b.totalPoints - a.totalPoints;
  });
}

export function sortPlayersByClubThenValue(
  players: PlayerDTO[],
  filterTeam: number,
) {
  players.sort((a, b) => {
    if (filterTeam === -1) {
      return b.valueQuarterMillions - a.valueQuarterMillions;
    } else {
      if (a.clubId === b.clubId) {
        return b.valueQuarterMillions - a.valueQuarterMillions;
      }
      return a.clubId - b.clubId;
    }
  });
}

function isPlayerUnder21(player: PlayerDTO): boolean {
  let playerAge = calculateAgeFromNanoseconds(Number(player.dateOfBirth));
  return playerAge < 21;
}

export function getTotalBonusPoints(
  gameweekData: GameweekData,
  fantasyTeam: FantasyTeamSnapshot,
  points: number,
): number {
  if (!gameweekData) {
    console.error("No gameweek data found:", gameweekData);
    return 0;
  }

  let bonusPoints = 0;
  var pointsForGoal = 0;
  var pointsForAssist = 0;
  switch (convertPositionToIndex(gameweekData.player.position)) {
    case 0:
      pointsForGoal = 20;
      pointsForAssist = 15;
      break;
    case 1:
      pointsForGoal = 20;
      pointsForAssist = 15;
      break;
    case 2:
      pointsForGoal = 15;
      pointsForAssist = 10;
      break;
    case 3:
      pointsForGoal = 10;
      pointsForAssist = 10;
      break;
  }

  if (
    fantasyTeam.goalGetterGameweek === gameweekData.gameweek &&
    fantasyTeam.goalGetterPlayerId === gameweekData.player.id
  ) {
    bonusPoints = gameweekData.goals * pointsForGoal * 2;
  }

  if (
    fantasyTeam.passMasterGameweek === gameweekData.gameweek &&
    fantasyTeam.passMasterPlayerId === gameweekData.player.id
  ) {
    bonusPoints = gameweekData.assists * pointsForAssist * 2;
  }

  if (
    fantasyTeam.noEntryGameweek === gameweekData.gameweek &&
    fantasyTeam.noEntryPlayerId === gameweekData.player.id &&
    (convertPositionToIndex(gameweekData.player.position) === 0 ||
      convertPositionToIndex(gameweekData.player.position) === 1) &&
    gameweekData.cleanSheets
  ) {
    bonusPoints = points * 2;
  }

  if (
    fantasyTeam.safeHandsGameweek === gameweekData.gameweek &&
    convertPositionToIndex(gameweekData.player.position) === 0 &&
    gameweekData.saves >= 5
  ) {
    bonusPoints = points * 2;
  }

  if (
    fantasyTeam.captainFantasticGameweek === gameweekData.gameweek &&
    fantasyTeam.captainId === gameweekData.player.id &&
    gameweekData.goals > 0
  ) {
    bonusPoints = points;
  }

  if (
    fantasyTeam.oneNationGameweek === gameweekData.gameweek &&
    fantasyTeam.oneNationCountryId === gameweekData.player.nationality
  ) {
    bonusPoints = points * 2;
  }

  if (
    fantasyTeam.prospectsGameweek === gameweekData.gameweek &&
    calculateAgeFromNanoseconds(Number(gameweekData.player.dateOfBirth)) < 21
  ) {
    bonusPoints = points * 2;
  }

  if (
    fantasyTeam.braceBonusGameweek === gameweekData.gameweek &&
    gameweekData.goals >= 2
  ) {
    bonusPoints = points;
  }

  if (
    fantasyTeam.hatTrickHeroGameweek === gameweekData.gameweek &&
    gameweekData.goals >= 3
  ) {
    bonusPoints = points * 2;
  }

  if (
    fantasyTeam.teamBoostGameweek === gameweekData.gameweek &&
    gameweekData.player.clubId === fantasyTeam.teamBoostClubId
  ) {
    bonusPoints = points;
  }

  return bonusPoints;
}

export function canAddPlayerToCurrentFormation(
  players: PlayerDTO[],
  player: PlayerDTO,
  team: PickTeamDTO,
  formation: string,
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
      positionCounts[convertPositionToIndex(teamPlayer.position)]++;
    }
  });

  positionCounts[convertPositionToIndex(player.position)]++;

  const [def, mid, fwd] = formation.split("-").map(Number);
  const minDef = Math.max(0, def - (positionCounts[1] || 0));
  const minMid = Math.max(0, mid - (positionCounts[2] || 0));
  const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
  const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

  const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
  const totalPlayers = Object.values(positionCounts).reduce((a, b) => a + b, 0);

  return totalPlayers + additionalPlayersNeeded <= 11;
}

export function findValidFormationWithPlayer(
  players: PlayerDTO[],
  team: PickTeamDTO,
  player: PlayerDTO,
  selectedFormation: string,
): string {
  const positionCounts: Record<number, number> = { 0: 0, 1: 0, 2: 0, 3: 0 };

  team.playerIds.forEach((id) => {
    const teamPlayer = players.find((p) => p.id === id);
    if (teamPlayer) {
      positionCounts[convertPositionToIndex(teamPlayer.position)]++;
    }
  });

  positionCounts[convertPositionToIndex(player.position)]++;

  let bestFitFormation: string | null = null;
  let minimumAdditionalPlayersNeeded = Number.MAX_SAFE_INTEGER;

  for (const formation of Object.keys(allFormations) as string[]) {
    if (formation === selectedFormation) {
      continue;
    }

    const formationPositions = allFormations[formation].positions;
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
      0,
    );

    if (
      additionalPlayersNeeded < minimumAdditionalPlayersNeeded &&
      formationDetails[convertPositionToIndex(player.position)] >
        positionCounts[convertPositionToIndex(player.position)] - 1
    ) {
      bestFitFormation = formation;
      minimumAdditionalPlayersNeeded = additionalPlayersNeeded;
    }
  }

  if (bestFitFormation) {
    return bestFitFormation;
  }

  return selectedFormation;
}

export function getAvailablePositionIndex(
  position: number,
  team: PickTeamDTO,
  formation: string,
): number {
  const formationArray = allFormations[formation].positions;
  for (let i = 0; i < formationArray.length; i++) {
    if (formationArray[i] === position && team.playerIds[i] === 0) {
      return i;
    }
  }
  return -1;
}

export function repositionPlayersForNewFormation(
  players: PlayerDTO[],
  fantasyTeam: PickTeamDTO,
  newFormation: string,
): number[] {
  const newFormationArray = allFormations[newFormation].positions;
  let newPlayerIds: number[] = new Array(11).fill(0);

  fantasyTeam.playerIds.forEach((playerId) => {
    const player = players.find((p) => p.id === playerId);
    if (player) {
      for (let i = 0; i < newFormationArray.length; i++) {
        if (
          newFormationArray[i] === convertPositionToIndex(player.position) &&
          newPlayerIds[i] === 0
        ) {
          newPlayerIds[i] = playerId;
          break;
        }
      }
    }
  });

  return newPlayerIds;
}

export function getGridSetup(formation: string): number[][] {
  const formationSplits = formation.split("-").map(Number);
  const setups = [
    [1],
    ...formationSplits.map((s) =>
      Array(s)
        .fill(0)
        .map((_, i) => i + 1),
    ),
  ];
  return setups;
}

export function checkBonusUsedInSession(
  fantasyTeam: PickTeamDTO,
  startingFantasyTeam: PickTeamDTO,
): boolean {
  let usedGoalGetterInSession =
    fantasyTeam.goalGetterGameweek != startingFantasyTeam.goalGetterGameweek;
  let usedPassMasterInSession =
    fantasyTeam.passMasterGameweek != startingFantasyTeam.passMasterGameweek;
  let usedNoEntryInSession =
    fantasyTeam.noEntryGameweek != startingFantasyTeam.noEntryGameweek;
  let usedTeamBoostInSession =
    fantasyTeam.teamBoostGameweek != startingFantasyTeam.teamBoostGameweek;
  let usedSafeHandsInSession =
    fantasyTeam.safeHandsGameweek != startingFantasyTeam.safeHandsGameweek;
  let usedCaptainFantasticInSession =
    fantasyTeam.captainFantasticGameweek !=
    startingFantasyTeam.captainFantasticGameweek;
  let usedProspectsInSession =
    fantasyTeam.prospectsGameweek != startingFantasyTeam.prospectsGameweek;
  let usedOneNationInSession =
    fantasyTeam.oneNationGameweek != startingFantasyTeam.oneNationGameweek;
  let usedBraceBonusInSession =
    fantasyTeam.braceBonusGameweek != startingFantasyTeam.braceBonusGameweek;
  let usedHatTrickHeroInSession =
    fantasyTeam.hatTrickHeroGameweek !=
    startingFantasyTeam.hatTrickHeroGameweek;
  return (
    usedGoalGetterInSession ||
    usedPassMasterInSession ||
    usedNoEntryInSession ||
    usedTeamBoostInSession ||
    usedSafeHandsInSession ||
    usedCaptainFantasticInSession ||
    usedProspectsInSession ||
    usedOneNationInSession ||
    usedBraceBonusInSession ||
    usedHatTrickHeroInSession
  );
}

export function isBonusUsed(
  fantasyTeam: PickTeamDTO | null,
  bonusId: number,
): boolean {
  if (!fantasyTeam) return false;
  switch (bonusId) {
    case 1:
      return fantasyTeam.goalGetterGameweek &&
        fantasyTeam.goalGetterGameweek > 0
        ? true
        : false;
    case 2:
      return fantasyTeam.passMasterGameweek &&
        fantasyTeam.passMasterGameweek > 0
        ? true
        : false;
    case 3:
      return fantasyTeam.noEntryGameweek && fantasyTeam.noEntryGameweek > 0
        ? true
        : false;
    case 4:
      return fantasyTeam.teamBoostGameweek && fantasyTeam.teamBoostGameweek > 0
        ? true
        : false;
    case 5:
      return fantasyTeam.safeHandsGameweek && fantasyTeam.safeHandsGameweek > 0
        ? true
        : false;
    case 6:
      return fantasyTeam.captainFantasticGameweek &&
        fantasyTeam.captainFantasticGameweek > 0
        ? true
        : false;
    case 7:
      return fantasyTeam.prospectsGameweek && fantasyTeam.prospectsGameweek > 0
        ? true
        : false;
    case 8:
      fantasyTeam.oneNationGameweek && fantasyTeam.oneNationGameweek > 0
        ? true
        : false;
      return false;
    case 9:
      return fantasyTeam.braceBonusGameweek &&
        fantasyTeam.braceBonusGameweek > 0
        ? true
        : false;
    case 10:
      return fantasyTeam.hatTrickHeroGameweek &&
        fantasyTeam.hatTrickHeroGameweek > 0
        ? true
        : false;
    default:
      return false;
  }
}

export function bonusPlayedThisWeek(
  fantasyTeam: PickTeamDTO | null,
  leagueStatus: LeagueStatus | null,
): boolean {
  if (!fantasyTeam || !leagueStatus) return false;
  let activeGameweek =
    leagueStatus.activeGameweek == 0
      ? leagueStatus.unplayedGameweek
      : leagueStatus.activeGameweek;
  let bonusPlayed: boolean =
    fantasyTeam.goalGetterGameweek == activeGameweek ||
    fantasyTeam.passMasterGameweek == activeGameweek ||
    fantasyTeam.noEntryGameweek == activeGameweek ||
    fantasyTeam.teamBoostGameweek == activeGameweek ||
    fantasyTeam.safeHandsGameweek == activeGameweek ||
    fantasyTeam.captainFantasticGameweek == activeGameweek ||
    fantasyTeam.braceBonusGameweek == activeGameweek ||
    fantasyTeam.hatTrickHeroGameweek == activeGameweek;
  return bonusPlayed;
}

export function autofillTeam(
  fantasyTeam: PickTeamDTO,
  players: PlayerDTO[],
  selectedFormation: string,
): PickTeamDTO {
  let updatedFantasyTeam = {
    ...fantasyTeam,
    playerIds: Uint16Array.from(fantasyTeam.playerIds),
  };
  let remainingBudget = fantasyTeam.bankQuarterMillions;

  const teamCounts = new Map<number, number>();
  updatedFantasyTeam.playerIds.forEach((playerId) => {
    if (playerId > 0) {
      const player = players.find((p) => p.id === playerId);
      if (player) {
        teamCounts.set(player.clubId, (teamCounts.get(player.clubId) || 0) + 1);
      }
    }
  });

  const formationPositions = allFormations[selectedFormation].positions;

  formationPositions.forEach((position, index) => {
    if (remainingBudget <= 0) return;
    if (updatedFantasyTeam.playerIds[index] > 0) return;

    const availablePlayers = players
      .filter(
        (player) =>
          convertPositionToIndex(player.position) === position &&
          !updatedFantasyTeam.playerIds.includes(player.id) &&
          (teamCounts.get(player.clubId) || 0) < 2,
      )
      .sort((a, b) => a.valueQuarterMillions - b.valueQuarterMillions);

    const topN = 3;
    const candidates = availablePlayers.slice(0, topN);
    const randomPlayer =
      candidates[Math.floor(Math.random() * candidates.length)];

    if (randomPlayer) {
      const potentialNewBudget =
        remainingBudget - randomPlayer.valueQuarterMillions;
      if (potentialNewBudget >= 0) {
        updatedFantasyTeam.playerIds[index] = randomPlayer.id;
        remainingBudget = potentialNewBudget;
        teamCounts.set(
          randomPlayer.clubId,
          (teamCounts.get(randomPlayer.clubId) || 0) + 1,
        );
      }
    }
  });

  if (remainingBudget >= 0) {
    updatedFantasyTeam.captainId = getHighestValuedPlayerId(
      updatedFantasyTeam,
      players,
    );
    updatedFantasyTeam.bankQuarterMillions = remainingBudget;
  }
  return updatedFantasyTeam;
}

export function countPlayersByTeam(
  players: PlayerDTO[],
  playerIds: Uint16Array | number[],
): Record<number, number> {
  const counts: Record<number, number> = {};
  playerIds.forEach((playerId) => {
    const player = players.find((p) => p.id === playerId);
    if (player) {
      if (!counts[player.clubId]) {
        counts[player.clubId] = 0;
      }
      counts[player.clubId]++;
    }
  });
  return counts;
}

export function reasonToDisablePlayer(
  team: PickTeamDTO,
  players: PlayerDTO[],
  player: PlayerDTO,
  teamPlayerCounts: Record<number, number>,
): string | null {
  const teamCount = teamPlayerCounts[player.clubId] || 0;
  if (teamCount >= 2) return "Max 2 Per Team";

  const canAfford = team.bankQuarterMillions >= player.valueQuarterMillions;
  if (!canAfford) return "Over Budget";

  if (team && team.playerIds.includes(player.id)) return "Selected";

  const positionCounts: { [key: number]: number } = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
  };

  team &&
    team.playerIds.forEach((id) => {
      const teamPlayer = players.find((p) => p.id === id);
      if (teamPlayer) {
        positionCounts[convertPositionToIndex(teamPlayer.position)]++;
      }
    });

  positionCounts[convertPositionToIndex(player.position)]++;

  const isFormationValid = Object.keys(allFormations).some((formation) => {
    const [def, mid, fwd] = formation.split("-").map(Number);
    const minDef = Math.max(0, def - (positionCounts[1] || 0));
    const minMid = Math.max(0, mid - (positionCounts[2] || 0));
    const minFwd = Math.max(0, fwd - (positionCounts[3] || 0));
    const minGK = Math.max(0, 1 - (positionCounts[0] || 0));

    const additionalPlayersNeeded = minDef + minMid + minFwd + minGK;
    const totalPlayers = Object.values(positionCounts).reduce(
      (a, b) => a + b,
      0,
    );

    return totalPlayers + additionalPlayersNeeded <= 11;
  });

  if (!isFormationValid) return "Invalid Formation";

  return null;
}

export function checkSaveButtonConditions(
  isLoading: boolean,
  fantasyTeam: PickTeamDTO,
  players: PlayerDTO[],
  appStatus: AppStatusDTO,
  selectedFormation: string,
): boolean {
  if (isLoading) {
    return true;
  }
  const teamCount = new Map();
  for (const playerId of fantasyTeam?.playerIds || []) {
    if (playerId > 0) {
      const player = players.find((p) => p.id === playerId);
      if (player) {
        teamCount.set(player.clubId, (teamCount.get(player.clubId) || 0) + 1);
        if (teamCount.get(player.clubId) > 2) {
          return false;
        }
      }
    }
  }

  if (appStatus.onHold) {
    return false;
  }

  if (!isBonusConditionMet(fantasyTeam)) {
    return false;
  }

  if (fantasyTeam?.playerIds.filter((id) => id > 0).length !== 11) {
    return false;
  }

  if (fantasyTeam.bankQuarterMillions < 0) {
    return false;
  }

  if (fantasyTeam.transfersAvailable < 0) {
    return false;
  }

  if (!isValidFormation(fantasyTeam, selectedFormation, players)) {
    return false;
  }

  return true;
}
