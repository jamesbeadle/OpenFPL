import { Position } from "$lib/enums/Position";
import type { FormationDetails } from "$lib/interfaces/FormationDetails";
import type {
  PickTeamDTO,
  PlayerDTO,
  PlayerPosition,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { convertPlayerPosition } from "./helpers";

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
    team.countrymenGameweek,
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



export function getHighestValuedPlayerId(team: PickTeamDTO, players: PlayerDTO[]): number {
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