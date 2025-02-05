import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type { CountryDTO } from "../../../../declarations/data_canister/data_canister.did";
import { toasts } from "$lib/stores/toasts-store";

export class CountryService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getCountries(): Promise<CountryDTO[] | undefined> {
    try {
      const result = await this.actor.getCountries();
      if (isError(result)) throw new Error("Failed to fetch countries");
      return result.ok;
    } catch (error) {
      console.error("Error fetching countries: ", error);
      toasts.addToast({ type: "error", message: "Error fetching countries." });
    }
  }
}
