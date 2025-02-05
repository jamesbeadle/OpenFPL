import { toasts } from "$lib/stores/toasts-store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { LeagueStatus } from "../../../../declarations/data_canister/data_canister.did";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";

export class LeagueService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getLeagueStatus(): Promise<LeagueStatus | undefined> {
    try {
      const result = await this.actor.getLeagueStatus();
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
