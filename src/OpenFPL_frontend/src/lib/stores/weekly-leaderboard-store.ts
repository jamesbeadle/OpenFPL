import { writable } from "svelte/store";
import { WeeklyLeaderboardService } from "$lib/services/weekly-leaderboard-service";
import type { WeeklyLeaderboard, WeeklyRewardsLeaderboard } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createWeeklyLeaderboardStore() {
  const { subscribe, set } = writable<WeeklyLeaderboard | null>(null);

  async function getWeeklyLeaderboard(
    seasonId: number,
    gameweek: number,
    page: number,
    searchTerm: string = "",
  ): Promise<WeeklyLeaderboard | undefined> {
    const offset = (page - 1) * 25;
    return new WeeklyLeaderboardService().getWeeklyLeaderboard(
      offset,
      seasonId,
      gameweek,
      searchTerm,
    );
  }

  async function getWeeklyRewards(
    seasonId: number,
    gameweek: number,
  ): Promise<WeeklyRewardsLeaderboard | undefined> {
    return new WeeklyLeaderboardService().getWeeklyRewards(seasonId, gameweek);
  }

  return {
    subscribe,
    setWeeklyLeaderboard: (leaderboard: WeeklyLeaderboard) =>
      set(leaderboard),
    getWeeklyLeaderboard,
    getWeeklyRewards,
  };
}

export const weeklyLeaderboardStore = createWeeklyLeaderboardStore();
