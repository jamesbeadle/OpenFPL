import { LeaderboardService } from "$lib/services/leaderboard-service";
import type {
  GetWeeklyLeaderboard,
  WeeklyLeaderboard,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createLeaderboardStore() {
  async function getWeeklyLeaderboard(
    dto: GetWeeklyLeaderboard,
  ): Promise<WeeklyLeaderboard | undefined> {
    return new LeaderboardService().getWeeklyLeaderboard(dto);
  }

  async function getMonthlyLeaderboard(
    dto: GetWeeklyLeaderboard,
  ): Promise<WeeklyLeaderboard | undefined> {
    return new LeaderboardService().getWeeklyLeaderboard(dto);
  }

  async function getSeasonLeaderboard(
    dto: GetWeeklyLeaderboard,
  ): Promise<WeeklyLeaderboard | undefined> {
    return new LeaderboardService().getWeeklyLeaderboard(dto);
  }

  async function getMostValuableTeamsLeaderboard(
    dto: GetWeeklyLeaderboard,
  ): Promise<WeeklyLeaderboard | undefined> {
    return new LeaderboardService().getWeeklyLeaderboard(dto);
  }

  return {
    getWeeklyLeaderboard,
    getMonthlyLeaderboard,
    getSeasonLeaderboard,
    getMostValuableTeamsLeaderboard,
  };
}

export const leaderboardStore = createLeaderboardStore();
