import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { AppStatusDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";

export class AppService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getAppStatus(): Promise<AppStatusDTO> {
    console.log("Service: get app status");
    const result = await this.actor.getAppStatus();
    if (isError(result)) throw new Error("Failed to fetch system state");
    return result.ok;
  }
}
