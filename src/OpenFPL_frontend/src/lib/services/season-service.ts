import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";
import type { SeasonDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class SeasonService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getSeasons(): Promise<SeasonDTO[]> {
    const result = await this.actor.getSeasons();
    if (isError(result)) throw new Error("Failed to fetch seasons");
    return result.ok;
  }
}
