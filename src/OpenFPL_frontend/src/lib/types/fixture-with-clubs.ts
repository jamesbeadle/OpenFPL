import type {
  Club,
  Fixture,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export type FixtureWithClubs = {
  fixture: Fixture;
  homeClub: Club | undefined;
  awayClub: Club | undefined;
};
