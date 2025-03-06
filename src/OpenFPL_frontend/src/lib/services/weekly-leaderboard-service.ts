import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  GetWeeklyLeaderboardDTO,
  GetWeeklyRewardsDTO,
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
    searchTerm: string,
  ): Promise<WeeklyLeaderboardDTO | undefined> {
    try {
      let dto: GetWeeklyLeaderboardDTO = {
        offset: BigInt(offset),
        seasonId: seasonId,
        limit: BigInt(25),
        searchTerm: searchTerm,
        gameweek: gameweek,
      };

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

  async getWeeklyRewards(
    seasonId: number,
    gameweek: number,
  ): Promise<WeeklyRewardsDTO | undefined> {
    try {
      let dto: GetWeeklyRewardsDTO = {
        seasonId: seasonId,
        gameweek: gameweek,
      };
      const result = await this.actor.getWeeklyRewards(dto);
      if (isError(result)) {
        return;
      }
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
