import { ActorFactory } from "../utils/actor.factory";
import { toasts } from "$lib/stores/toasts-store";
import type { FixtureDTO, LeagueId, SeasonId } from "../../../../external_declarations/data_canister/data_canister.did";
import { isError } from "../utils/helpers";
import { authStore } from "$lib/stores/auth.store";

export class FixtureService {
  private actor: any;

  constructor() {}

  async getFixtures(): Promise<FixtureDTO[] | undefined> {
    try {
      const identityActor: any = await ActorFactory.createDataCanisterIdentityActor(
        authStore,
        process.env.CANISTER_ID_DATA ?? "",
      );
      const leagueId: LeagueId = 1;
      const seasonId: SeasonId = 1;
      const result = await identityActor.getFixtures(leagueId, seasonId);
      if (isError(result)) throw new Error("Failed to fetch fixtures");
      return result.ok;
    } catch (error) {
      console.error("Error fetching fixtures: ", error);
      toasts.addToast({ type: "error", message: "Error fetching fixtures." });
    }
  }

  async getPostponedFixtures(): Promise<FixtureDTO[] | undefined> {
    try {
      const identityActor: any = await ActorFactory.createDataCanisterIdentityActor(
        authStore,
        process.env.CANISTER_ID_DATA ?? "",
      );
      const leagueId: LeagueId = 1;
      const result = await identityActor.getPostponedFixtures(leagueId);
      if (isError(result)) throw new Error("Failed to fetch postponed fixtures");
      return result.ok;
    } catch (error) {
      console.error("Error fetching fixtures: ", error);
      toasts.addToast({ type: "error", message: "Error fetching fixtures." });
    }
  }
}
