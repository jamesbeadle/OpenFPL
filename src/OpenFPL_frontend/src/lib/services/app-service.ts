import type { AppStatusDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { isError } from "../utils/helpers";
import { idlFactory as backend_canister } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "$lib/utils/actor.factory";

export class AppService {
  constructor() {}

  async getAppStatus(): Promise<AppStatusDTO | undefined> {
    const identityActor: any = await ActorFactory.createActor(
      backend_canister,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );

    const result = await identityActor.getAppStatus();
    if (isError(result)) throw new Error("Failed to get app status");
    return result.ok;
  }
}
