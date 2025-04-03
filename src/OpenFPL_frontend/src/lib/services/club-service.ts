import { toasts } from "$lib/stores/toasts-store";
import { authStore } from "$lib/stores/auth-store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  Club,
  LeagueId,
} from "../../../../declarations/data_canister/data_canister.did";

export class ClubService {
  private actor: any;

  constructor() {}

  async getClubs(): Promise<Club[] | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const leagueId: LeagueId = 1;
      const result = await identityActor.getClubs(leagueId);
      if (isError(result)) throw new Error("Failed to fetch clubs");
      return result.ok;
    } catch (error) {
      console.error("Error fetching clubs: ", error);
      toasts.addToast({ type: "error", message: "Error fetching clubs." });
    }
  }
}
