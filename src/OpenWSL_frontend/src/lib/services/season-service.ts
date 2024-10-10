import { idlFactory } from "../../../../declarations/OpenWSL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";
import type { SeasonDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";

export class SeasonService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENWSL_BACKEND_CANISTER_ID,
    );
  }

  async getSeasons(): Promise<SeasonDTO[]> {
    const result = await this.actor.getSeasons();
    if (isError(result)) throw new Error("Failed to fetch seasons");
    return result.ok;
  }
}
