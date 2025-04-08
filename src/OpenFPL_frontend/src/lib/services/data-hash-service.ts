import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import type { DataHash } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class DataHashService {
  constructor() {}

  async getAppDataHashes(): Promise<DataHash[] | undefined> {
    try {
      const actor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await actor.getDataHashes();
      if (isError(result))
        throw new Error("Failed to fetch data hashes from backend.");
      return result.ok;
    } catch (error) {
      console.error("Failed to fetch data hashes from backend: ", error);
    }
  }

  async getICFCDataHash(): Promise<string | undefined> {
    try {
      const actor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await actor.getICFCDataHash();
      if (isError(result))
        throw new Error("Failed to fetch ICFC data hash from backend.");
      return result.ok;
    } catch (error) {
      console.error("Failed to fetch ICFC data hash from backend: ", error);
      return undefined;
    }
  }
}
