
import type { Fixture, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
export type FixtureWithTeams = {
    fixture: Fixture;
    homeTeam: Team | undefined;
    awayTeam: Team | undefined;
};
