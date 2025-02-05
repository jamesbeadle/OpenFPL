import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { toasts } from "$lib/stores/toasts-store";
import type { FixtureDTO } from "../../../../external_declarations/data_canister/data_canister.did";
import { isError } from "$lib/utils/helpers";

export class FixtureService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getFixtures(): Promise<FixtureDTO[] | undefined> {
    try {
      const result = await this.actor.getFixtures();
      if (isError(result)) throw new Error("Failed to fetch fixtures");
      return result.ok;
    } catch (error) {
      console.error("Error fetching fixtures: ", error);
      toasts.addToast({ type: "error", message: "Error fetching fixtures." });
    }
  }
}
