import { toasts } from "$lib/stores/toasts-store";
import { authStore } from "$lib/stores/auth.store";
import type { ClubDTO, LeagueId } from "../../../../external_declarations/data_canister/data_canister.did";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";

export class ClubService {
  private actor: any;

  constructor() {}

  async getClubs(): Promise<ClubDTO[] | undefined> {
    try {
      const identityActor: any = await ActorFactory.createDataCanisterIdentityActor(
        authStore,
        process.env.CANISTER_ID_DATA ?? "",
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
