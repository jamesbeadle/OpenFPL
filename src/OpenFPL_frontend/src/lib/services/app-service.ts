import { isError } from "../utils/helpers";
import { ActorFactory } from "$lib/utils/actor.factory";
import type { AppStatus } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { authStore } from "$lib/stores/auth-store";

export class AppService {
  constructor() {}

  async getAppStatus(): Promise<AppStatus | undefined> {
    console.log("getting app status");
    console.log(process.env.OPENFPL_BACKEND_CANISTER_ID);
    console.log(authStore);
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );

    const result = await identityActor.getAppStatus();
    console.log(result);
    if (isError(result)) throw new Error("Failed to get app status");
    return result.ok;
  }
}
