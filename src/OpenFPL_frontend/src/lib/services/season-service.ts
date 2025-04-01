import { authStore } from "$lib/stores/auth-store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { toasts } from "$lib/stores/toasts-store";
import type {
  LeagueId,
  Season,
} from "../../../../declarations/data_canister/data_canister.did";

export class SeasonService {
  private actor: any;

  constructor() {}

  async getSeasons(): Promise<Season[] | undefined> {
    try {
      const identityActor: any =
        await ActorFactory.createDataCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_DATA ?? "",
        );
      const leagueId: LeagueId = 1;
      const result = await identityActor.getSeasons(leagueId);
      if (isError(result)) throw new Error("Failed to fetch seasons");
      return result.ok;
    } catch (error) {
      console.error("Error fetching seasons: ", error);
      toasts.addToast({ type: "error", message: "Error fetching seasons." });
    }
  }
}
