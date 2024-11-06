import { writable } from "svelte/store";
import type { WeeklyLeaderboardDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { WeeklyLeaderboardService } from "$lib/services/weekly-leaderboard-service";

function createWeeklyLeaderboardStore() {
  const { subscribe, set } = writable<WeeklyLeaderboardDTO | null>(null);

  async function getWeeklyLeaderboard(
    seasonId: number,
    gameweek: number,
    page: number,
  ): Promise<WeeklyLeaderboardDTO | null> {
    const offset = (page - 1) * 25;

    return new WeeklyLeaderboardService().getWeeklyLeaderboard(
      offset,
      seasonId,
      gameweek,
    );
  }

  return {
    subscribe,
    setWeeklyLeaderboard: (leaderboard: WeeklyLeaderboardDTO) =>
      set(leaderboard),
    getWeeklyLeaderboard,
  };
}

export const weeklyLeaderboardStore = createWeeklyLeaderboardStore();
