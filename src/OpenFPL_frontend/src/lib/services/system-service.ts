import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { SystemStateDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";

export class SystemService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  async getSystemState(): Promise<SystemStateDTO> {
    const result = await this.actor.getSystemState();
    if (isError(result)) throw new Error("Failed to fetch system state");
    return result.ok;
  }
}
