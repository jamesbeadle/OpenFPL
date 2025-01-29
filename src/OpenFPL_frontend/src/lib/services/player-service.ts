import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type { PlayerDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { toasts } from "$lib/stores/toasts-store";

export class PlayerService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getPlayers(): Promise<PlayerDTO[] | undefined> {
    try {
      const result = await this.actor.getPlayers();
      if (isError(result)) throw new Error("Failed to fetch league players");
      return result.ok;
    } catch (error) {
      console.error("Error fetching league players: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching league players.",
      });
    }
  }
}
