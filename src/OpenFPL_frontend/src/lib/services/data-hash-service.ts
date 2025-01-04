import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type { DataHashDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { toasts } from "$lib/stores/toasts-store";

export class DataHashService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getDataHashes(): Promise<DataHashDTO[] | undefined> {
    try {
      const result = await this.actor.getDataHashes();
      if (isError(result)) throw new Error("Failed to fetch data hashes");
      return result.ok;
    } catch (error) {
      console.error("Error fetching data hashes: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching data hashes.",
      });
    }
  }
}
