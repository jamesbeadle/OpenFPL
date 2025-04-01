import { isError } from "../utils/helpers";
import { idlFactory as backend_canister } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "$lib/utils/actor.factory";
import type { AppStatus } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class AppService {
  constructor() {}

  async getAppStatus(): Promise<AppStatus | undefined> {
    const identityActor: any = await ActorFactory.createActor(
      backend_canister,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );

    const result = await identityActor.getAppStatus();
    if (isError(result)) throw new Error("Failed to get app status");
    return result.ok;
  }
}
