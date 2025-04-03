import { authStore } from "$lib/stores/auth-store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { toasts } from "$lib/stores/toasts-store";
import type { Countries } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class CountryService {
  private actor: any;

  constructor() {}

  async getCountries(): Promise<Countries | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.getCountries();
      if (isError(result)) throw new Error("Failed to fetch countries");
      return result.ok;
    } catch (error) {
      console.error("Error fetching countries: ", error);
      toasts.addToast({ type: "error", message: "Error fetching countries." });
    }
  }
}
