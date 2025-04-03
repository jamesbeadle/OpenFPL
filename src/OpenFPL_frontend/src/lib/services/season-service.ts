import { authStore } from "$lib/stores/auth-store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { toasts } from "$lib/stores/toasts-store";
import type {
  LeagueId,
  Seasons,
  GetSeasons,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class SeasonService {
  private actor: any;

  constructor() {}

  async getSeasons(): Promise<Seasons | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const leagueId: LeagueId = 1;
      let dto: GetSeasons = { leagueId };
      const result = await identityActor.getSeasons(dto);
      if (isError(result)) throw new Error("Failed to fetch seasons");
      return result.ok;
    } catch (error) {
      console.error("Error fetching seasons: ", error);
      toasts.addToast({ type: "error", message: "Error fetching seasons." });
    }
  }
}
