import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type { SeasonDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { toasts } from "$lib/stores/toasts-store";

export class SeasonService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getSeasons(): Promise<SeasonDTO[] | undefined> {
    try {
      const result = await this.actor.getSeasons();
      if (isError(result)) throw new Error("Failed to fetch seasons");
      return result.ok;
    } catch (error) {
      console.error("Error fetching seasons: ", error);
      toasts.addToast({ type: "error", message: "Error fetching seasons." });
    }
  }
}
