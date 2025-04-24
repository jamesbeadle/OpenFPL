import { ActorFactory } from "../utils/actor.factory";
import { toasts } from "$lib/stores/toasts-store";
import { authStore } from "$lib/stores/auth-store";
import type {
  GetMostValuableGameweekPlayers,
  MostValuableGameweekPlayers,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { isError } from "$lib/utils/Helpers";

export class MVPService {

  constructor() {}

  async getMostValuableGameweekPlayers(dto: GetMostValuableGameweekPlayers): Promise<MostValuableGameweekPlayers | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.getMostValuableGameweekPlayers(dto);
      if (isError(result)) throw new Error("Failed to fetch most valuable gameweek players");
      return result.ok;
    } catch (error) {
      console.error("Error fetching fixtures: ", error);
      toasts.addToast({ type: "error", message: "Error fetching most valuable gameweek players." });
    }
  }
}
