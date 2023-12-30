import type {
  FixtureDTO,
  ClubDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
export type FixtureWithTeams = {
  fixture: FixtureDTO;
  homeTeam: ClubDTO | undefined;
  awayTeam: ClubDTO | undefined;
};
