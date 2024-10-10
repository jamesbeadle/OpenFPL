import { writable } from 'svelte/store';
import type { WeeklyLeaderboardDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createWeeklyLeaderboardStore() {
  const { subscribe, set } = writable<WeeklyLeaderboardDTO | null>(null);

  return {
    subscribe,
    setWeeklyLeaderboard: (leaderboard: WeeklyLeaderboardDTO) => set(leaderboard)
  };
}

export const weeklyLeaderboardStore = createWeeklyLeaderboardStore();
