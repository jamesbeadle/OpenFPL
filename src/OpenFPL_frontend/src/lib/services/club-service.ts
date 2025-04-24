import { toasts } from "$lib/stores/toasts-store";
import { authStore } from "$lib/stores/auth-store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "$lib/utils/Helpers";
import type {
  Clubs,
  LeagueId,
  GetClubs,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class ClubService {
  constructor() {}

  async getClubs(): Promise<Clubs | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const leagueId: LeagueId = Number(process.env.LEAGUE_ID);
      let dto: GetClubs = { leagueId };
      const result = await identityActor.getClubs(dto);
      if (isError(result)) throw new Error("Failed to fetch clubs");
      return result.ok;
    } catch (error) {
      console.error("Error fetching clubs: ", error);
      toasts.addToast({ type: "error", message: "Error fetching clubs." });
    }
  }
}
