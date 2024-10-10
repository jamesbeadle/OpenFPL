import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";
import type { WeeklyLeaderboardDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class WeeklyLeaderboardService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getWeeklyLeaderboard(): Promise<WeeklyLeaderboardDTO> {
    const result = await this.actor.getWeeklyLeaderboard();
    if (isError(result)) throw new Error("Failed to fetch countries");
    return result.ok;
  }
}
