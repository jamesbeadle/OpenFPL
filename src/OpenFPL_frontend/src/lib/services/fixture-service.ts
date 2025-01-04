import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type { FixtureDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { toasts } from "$lib/stores/toasts-store";

export class FixtureService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getPostponedFixtures(): Promise<FixtureDTO[] | undefined> {
    try {
      const result = await this.actor.getPostponedFixtures();
      if (isError(result))
        throw new Error("Failed to fetch postponed fixtures");
      return result.ok;
    } catch (error) {
      console.error("Error fetching postponed fixtures: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching postponed fixtures.",
      });
    }
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
