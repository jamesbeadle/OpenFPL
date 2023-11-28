import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export interface TeamStats extends Team {
  played: number;
  wins: number;
  draws: number;
  losses: number;
  goalsFor: number;
  goalsAgainst: number;
  points: number;
}
