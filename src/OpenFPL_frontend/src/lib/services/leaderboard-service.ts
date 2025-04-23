import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { toasts } from "$lib/stores/toasts-store";
import type {
  GetWeeklyLeaderboard,
  WeeklyLeaderboard,
  WeeklyRewardsLeaderboard,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class LeaderboardService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getWeeklyLeaderboard(dto: GetWeeklyLeaderboard): Promise<WeeklyLeaderboard | undefined> {
    try {

      const result = await this.actor.getWeeklyLeaderboard(dto);
      if (isError(result)) {
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Failed to get weekly leaderboard: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching weekly leaderboard.",
      });
    }
  }
}
