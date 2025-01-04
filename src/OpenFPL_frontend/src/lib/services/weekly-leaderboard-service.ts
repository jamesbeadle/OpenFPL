import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  GetWeeklyLeaderboardDTO,
  WeeklyLeaderboardDTO,
  WeeklyRewardsDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { toasts } from "$lib/stores/toasts-store";

export class WeeklyLeaderboardService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getWeeklyLeaderboard(
    offset: number,
    seasonId: number,
    gameweek: number,
  ): Promise<WeeklyLeaderboardDTO | undefined> {
    try {
      let dto: GetWeeklyLeaderboardDTO = {
        offset: BigInt(offset),
        seasonId: seasonId,
        limit: BigInt(25),
        searchTerm: "",
        gameweek: gameweek,
      };
      const result = await this.actor.getWeeklyLeaderboard(dto);
      if (isError(result))
        throw new Error("Failed to fetch weekly leaderboard");
      return result.ok;
    } catch (error) {
      console.error("Failed to get weekly leaderboard: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching weekly leaderboard.",
      });
    }
  }

  async getWeeklyRewards(
    seasonId: number,
    gameweek: number,
  ): Promise<WeeklyRewardsDTO | undefined> {
    try {
      //TODO: REmove
      return {
        seasonId: 1,
        rewards: [],
        gameweek: 1,
      };
      const result = await this.actor.getWeeklyRewards(seasonId, gameweek);
      if (isError(result)) throw new Error("Failed to get weekly rewards");
      return result.ok;
    } catch (error) {
      console.error("Failed to get weekly rewards: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching weekly rewards.",
      });
    }
  }
}
