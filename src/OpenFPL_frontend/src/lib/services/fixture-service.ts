import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type { FixtureDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import type { RequestFixturesDTO } from "../../../../declarations/data_canister/data_canister.did";

export class FixtureService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getPostponedFixtures(): Promise<FixtureDTO[]> {
    const result = await this.actor.getPostponedFixtures();
    if (isError(result)) throw new Error("Failed to fetch postponed fixtures");
    return result.ok;
  }

  async getFixtures(): Promise<FixtureDTO[]> {
    const result = await this.actor.getFixtures(1); //TODO: Set from store
    if (isError(result)) throw new Error("Failed to fetch fixtures");
    return result.ok;
  }
}
