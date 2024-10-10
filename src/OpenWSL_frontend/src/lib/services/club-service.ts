import { idlFactory } from "../../../../declarations/OpenWSL_backend";
import type { ClubDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";

export class ClubService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENWSL_BACKEND_CANISTER_ID,
    );
  }

  async getClubs(): Promise<ClubDTO[]> {
    const result = await this.actor.getClubs();
    if (isError(result)) throw new Error("Failed to fetch clubs");
    return result.ok;
  }
}
