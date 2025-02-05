import { toasts } from "$lib/stores/toasts-store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { ClubDTO } from "../../../../declarations/data_canister/data_canister.did";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";

export class ClubService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getClubs(): Promise<ClubDTO[] | undefined> {
    try {
      const result = await this.actor.getClubs();
      if (isError(result)) throw new Error("Failed to fetch clubs");
      return result.ok;
    } catch (error) {
      console.error("Error fetching clubs: ", error);
      toasts.addToast({ type: "error", message: "Error fetching clubs." });
    }
  }
}
