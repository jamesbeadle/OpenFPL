import { authStore } from "$lib/stores/auth.store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { toasts } from "$lib/stores/toasts-store";
import type { Country } from "../../../../declarations/data_canister/data_canister.did";

export class CountryService {
  private actor: any;

  constructor() {}

  async getCountries(): Promise<Country[] | undefined> {
    try {
      const identityActor: any =
        await ActorFactory.createDataCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_DATA ?? "",
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
