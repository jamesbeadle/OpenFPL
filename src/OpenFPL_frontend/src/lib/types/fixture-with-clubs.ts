import type {
  ClubDTO,
  FixtureDTO,
} from "../../../../external_declarations/data_canister/data_canister.did";

export type FixtureWithClubs = {
  fixture: FixtureDTO;
  homeClub: ClubDTO | undefined;
  awayClub: ClubDTO | undefined;
};
