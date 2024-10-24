import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
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

  async getFixtures(seasonId: number): Promise<FixtureDTO[]> {
    let dto: RequestFixturesDTO = {
      leagueId: 1,
      seasonId: seasonId,
    };
    const result = await this.actor.getFixtures(dto);
    if (isError(result)) throw new Error("Failed to fetch fixtures");
    return result.ok;
  }
}
