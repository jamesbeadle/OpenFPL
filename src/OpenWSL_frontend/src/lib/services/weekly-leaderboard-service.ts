import { idlFactory } from "../../../../declarations/OpenWSL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";
import type { WeeklyLeaderboardDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";

export class WeeklyLeaderboardService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENWSL_BACKEND_CANISTER_ID,
    );
  }

  async getWeeklyLeaderboard(): Promise<WeeklyLeaderboardDTO> {
    const result = await this.actor.getWeeklyLeaderboard();
    if (isError(result)) throw new Error("Failed to fetch countries");
    return result.ok;
  }
}
