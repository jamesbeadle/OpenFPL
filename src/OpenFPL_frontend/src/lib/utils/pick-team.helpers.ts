import type { FormationDetails } from "$lib/interfaces/FormationDetails";
import type { GameweekData } from "$lib/interfaces/GameweekData";
import type {
  FantasyTeamSnapshot,
  PickTeamDTO,
  PlayerDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { calculateAgeFromNanoseconds, convertPlayerPosition } from "./helpers";

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
      positionCounts[convertPlayerPosition(teamPlayer.position)]++;
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
      positionCounts[convertPlayerPosition(teamPlayer.position)]++;
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
      positionCounts[convertPlayerPosition(teamPlayer.position)]++;
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
      positionCounts[convertPlayerPosition(teamPlayer.position)]++;
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
  switch (convertPlayerPosition(gameweekData.player.position)) {
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
    (convertPlayerPosition(gameweekData.player.position) === 0 ||
      convertPlayerPosition(gameweekData.player.position) === 1) &&
    gameweekData.cleanSheets
  ) {
    bonusPoints = points * 2;
  }

  if (
    fantasyTeam.safeHandsGameweek === gameweekData.gameweek &&
    convertPlayerPosition(gameweekData.player.position) === 0 &&
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
