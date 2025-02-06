import type { ClubDTO } from "../../../../external_declarations/data_canister/data_canister.did";

export interface TeamStats extends ClubDTO {
  played: number;
  wins: number;
  draws: number;
  losses: number;
  goalsFor: number;
  goalsAgainst: number;
  points: number;
}
