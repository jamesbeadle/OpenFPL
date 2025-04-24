import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { toasts } from "$lib/stores/toasts-store";
import type {
  GetMonthlyLeaderboard,
  GetMostValuableTeamLeaderboard,
  GetSeasonLeaderboard,
  GetWeeklyLeaderboard,
  MonthlyLeaderboard,
  MostValuableTeamLeaderboard,
  SeasonLeaderboard,
  WeeklyLeaderboard,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class LeaderboardService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getWeeklyLeaderboard(
    dto: GetWeeklyLeaderboard,
  ): Promise<WeeklyLeaderboard | undefined> {
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

  async getMonthlyLeaderboard(
    dto: GetMonthlyLeaderboard,
  ): Promise<MonthlyLeaderboard | undefined> {
    try {
      const result = await this.actor.getMonthlyLeaderboard(dto);
      if (isError(result)) {
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Failed to get monthly leaderboard: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching monthly leaderboard.",
      });
    }
  }

  async getSeasonLeaderboard(
    dto: GetSeasonLeaderboard,
  ): Promise<SeasonLeaderboard | undefined> {
    try {
      const result = await this.actor.getSeasonLeaderboard(dto);
      if (isError(result)) {
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Failed to get season leaderboard: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching season leaderboard.",
      });
    }
  }

  async getMostValuableTeamLeaderboard(
    dto: GetMostValuableTeamLeaderboard,
  ): Promise<MostValuableTeamLeaderboard | undefined> {
    try {
      const result = await this.actor.getMostValuableTeamLeaderboard(dto);
      if (isError(result)) {
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Failed to get most valuable team leaderboard: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching most valuable team leaderboard.",
      });
    }
  }
}
