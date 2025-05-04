import { LeaderboardService } from "$lib/services/leaderboard-service";
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

function createLeaderboardStore() {
  async function getWeeklyLeaderboard(
    dto: GetWeeklyLeaderboard,
  ): Promise<WeeklyLeaderboard | undefined> {
    return new LeaderboardService().getWeeklyLeaderboard(dto);
  }

  async function getMonthlyLeaderboard(
    dto: GetMonthlyLeaderboard,
  ): Promise<MonthlyLeaderboard | undefined> {
    return new LeaderboardService().getMonthlyLeaderboard(dto);
  }

  async function getSeasonLeaderboard(
    dto: GetSeasonLeaderboard,
  ): Promise<SeasonLeaderboard | undefined> {
    return new LeaderboardService().getSeasonLeaderboard(dto);
  }

  async function getMostValuableTeamLeaderboard(
    dto: GetMostValuableTeamLeaderboard,
  ): Promise<MostValuableTeamLeaderboard | undefined> {
    return new LeaderboardService().getMostValuableTeamLeaderboard(dto);
  }

  return {
    getWeeklyLeaderboard,
    getMonthlyLeaderboard,
    getSeasonLeaderboard,
    getMostValuableTeamLeaderboard,
  };
}

export const leaderboardStore = createLeaderboardStore();
