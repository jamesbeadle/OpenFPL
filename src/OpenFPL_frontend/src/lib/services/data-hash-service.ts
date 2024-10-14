import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";
import type { DataHashDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class DataHashService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getDataHashes(): Promise<DataHashDTO[]> {
    const result = await this.actor.getDataHashes();
    console.log(result);
    if (isError(result)) throw new Error("Failed to fetch data hashes");
    return result.ok;
  }
}
