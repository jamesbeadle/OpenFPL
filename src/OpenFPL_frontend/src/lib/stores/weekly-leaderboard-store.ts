import { writable } from "svelte/store";
import type {
  WeeklyLeaderboardDTO,
  WeeklyRewardsDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { WeeklyLeaderboardService } from "$lib/services/weekly-leaderboard-service";

function createWeeklyLeaderboardStore() {
  const { subscribe, set } = writable<WeeklyLeaderboardDTO | null>(null);

  async function getWeeklyLeaderboard(
    seasonId: number,
    gameweek: number,
    page: number,
  ): Promise<WeeklyLeaderboardDTO | undefined> {
    const offset = (page - 1) * 25;

    return new WeeklyLeaderboardService().getWeeklyLeaderboard(
      offset,
      seasonId,
      gameweek,
    );
  }

  async function getWeeklyRewards(
    seasonId: number,
    gameweek: number,
  ): Promise<WeeklyRewardsDTO | undefined> {
    return new WeeklyLeaderboardService().getWeeklyRewards(seasonId, gameweek);
  }

  return {
    subscribe,
    setWeeklyLeaderboard: (leaderboard: WeeklyLeaderboardDTO) =>
      set(leaderboard),
    getWeeklyLeaderboard,
    getWeeklyRewards,
  };
}

export const weeklyLeaderboardStore = createWeeklyLeaderboardStore();
