import { ActorFactory } from "../utils/actor.factory";
import { toasts } from "$lib/stores/toasts-store";
import { authStore } from "$lib/stores/auth-store";
import type {
  Fixtures,
  LeagueId,
  SeasonId,
  GetFixtures,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { isError } from "$lib/utils/helpers";

export class FixtureService {
  private actor: any;

  constructor() {}

  async getFixtures(): Promise<Fixtures | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const leagueId: LeagueId = Number(process.env.LEAGUE_ID);
      const seasonId: SeasonId = 1;
      let dto: GetFixtures = { leagueId, seasonId };
      const result = await identityActor.getFixtures(dto);
      if (isError(result)) throw new Error("Failed to fetch fixtures");
      return result.ok;
    } catch (error) {
      console.error("Error fetching fixtures: ", error);
      toasts.addToast({ type: "error", message: "Error fetching fixtures." });
    }
  }

  /* async getPostponedFixtures(): Promise<Fixtures | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const leagueId: LeagueId = Number(process.env.LEAGUE_ID);
      const result = await identityActor.getPostponedFixtures(leagueId);
      if (isError(result))
        throw new Error("Failed to fetch postponed fixtures");
      return result.ok;
    } catch (error) {
      console.error("Error fetching fixtures: ", error);
      toasts.addToast({ type: "error", message: "Error fetching fixtures." });
    }
  } */
}
