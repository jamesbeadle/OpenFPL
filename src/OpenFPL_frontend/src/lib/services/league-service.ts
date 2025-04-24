import { toasts } from "$lib/stores/toasts-store";
import { authStore } from "$lib/stores/auth-store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "$lib/utils/Helpers";
import type {
  LeagueStatus,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
export class LeagueService {

  constructor() {}

  async getLeagueStatus(): Promise<LeagueStatus | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.getLeagueStatus();
      if (isError(result)) throw new Error("Failed to fetch league status");
      return result.ok;
    } catch (error) {
      console.error("Error fetching league status: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching league status.",
      });
    }
  }
}
