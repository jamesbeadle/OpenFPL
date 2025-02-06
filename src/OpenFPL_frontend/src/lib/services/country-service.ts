import { authStore } from "$lib/stores/auth.store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type { CountryDTO } from "../../../../external_declarations/data_canister/data_canister.did";
import { toasts } from "$lib/stores/toasts-store";

export class CountryService {
  private actor: any;

  constructor() {}

  async getCountries(): Promise<CountryDTO[] | undefined> {
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
