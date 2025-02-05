import type {
  ClubDTO,
  FixtureDTO,
} from "../../../../external_declarations/data_canister/data_canister.did";

export type FixtureWithClubs = {
  fixture: FixtureDTO;
  homeTeam: ClubDTO | undefined;
  awayTeam: ClubDTO | undefined;
};
