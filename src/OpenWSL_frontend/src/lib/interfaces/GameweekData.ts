import type { PlayerDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export interface GameweekData {
  player: PlayerDTO;
  gameweek: number;
  points: number;
  bonusPoints: number;
  totalPoints: number;
  appearance: number;
  goals: number;
  assists: number;
  goalsConceded: number;
  saves: number;
  cleanSheets: number;
  penaltySaves: number;
  missedPenalties: number;
  yellowCards: number;
  redCards: number;
  ownGoals: number;
  highestScoringPlayerId: number;
  goalPoints: number;
  assistPoints: number;
  goalsConcededPoints: number;
  cleanSheetPoints: number;
  isCaptain: boolean;
  nationalityId: number;
}
