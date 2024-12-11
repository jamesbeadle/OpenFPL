import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  LeagueStatus,
  AppStatusDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";

export class LeagueService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getLeagueStatus(): Promise<LeagueStatus> {
    console.log("BACKEND CALL TO GET LEAGUE STATUS");
    const result = await this.actor.getLeagueStatus();
    if (isError(result)) throw new Error("Failed to fetch league status");
    return result.ok;
  }
}
