import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { FootballLeagueDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";

export class LeagueService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENWSL_BACKEND_CANISTER_ID,
    );
  }

  async getLeagues(): Promise<FootballLeagueDTO[]> {
    const result = await this.actor.getLeagues();
    if (isError(result)) throw new Error("Failed to fetch leagues");
    return result.ok;
  }
}
