import { writable } from 'svelte/store';
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";
import { systemStore } from '$lib/stores/system-store';
import type { SystemState, PaginatedLeaderboard, PaginatedClubLeaderboard, LeaderboardEntry, DataCache } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createLeaderboardStore() {
  const { subscribe, set } = writable<PaginatedLeaderboard | null>(null);
  const itemsPerPage = 25;
  
  let systemState: SystemState;
  systemStore.subscribe(value => { systemState = value as SystemState });
  
  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  
  async function syncWeeklyLeaderboard() {
    let category = "weekly_leaderboard";
    const newHashValues: DataCache[] = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getWeeklyLeaderboardCache(
        systemState?.activeSeason.id,
        systemState?.focusGameweek
      );
      localStorage.setItem(
        "weekly_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }

  async function syncMonthlyLeaderboards() {
    let category = "monthly_leaderboards";
    const newHashValues: DataCache[] = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getClubLeaderboardsCache(
        systemState?.activeSeason.id,
        systemState?.activeMonth
      );
      localStorage.setItem(
        "monthly_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }

  async function syncSeasonLeaderboard() {
    let category = "season_leaderboard";
    const newHashValues: DataCache[] = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getSeasonLeaderboardCache(
        systemState?.activeSeason.id
      );
      localStorage.setItem(
        "season_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }

  async function getWeeklyLeaderboard(): Promise<PaginatedLeaderboard> {
    const cachedWeeklyLeaderboardData = localStorage.getItem(
      "weekly_leaderboard_data"
    );

    let cachedWeeklyLeaderboard: PaginatedLeaderboard;
    try {
      cachedWeeklyLeaderboard = JSON.parse(
        cachedWeeklyLeaderboardData ||
          "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }"
      );
    } catch (e) {
      cachedWeeklyLeaderboard = {
        entries: [],
        gameweek: 0,
        seasonId: 0,
        totalEntries: 0n,
      };
    }

    return cachedWeeklyLeaderboard;
  }

  async function getWeeklyLeaderboardPage(gameweek: number, currentPage: number): Promise<PaginatedLeaderboard> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let weeklyLeaderboardData = await actor.getWeeklyLeaderboard(
      systemState?.activeSeason.id,
      gameweek,
      limit,
      offset
    );
    return weeklyLeaderboardData;
  }

  async function getMonthlyLeaderboard(clubId: number): Promise<PaginatedClubLeaderboard | null> {
    const cachedMonthlyLeaderboardData = localStorage.getItem(
      "monthly_leaderboards_data"
    );
    let cachedMonthlyLeaderboards: PaginatedClubLeaderboard[];
    try {
      cachedMonthlyLeaderboards = JSON.parse(
        cachedMonthlyLeaderboardData || "[]"
      );
    } catch (e) {
      cachedMonthlyLeaderboards = [];
    }

    let clubLeaderboard =
      cachedMonthlyLeaderboards.find((x) => x.clubId === clubId) ?? null;
    return clubLeaderboard;
  }

  async function getSeasonLeaderboard(): Promise<PaginatedLeaderboard> {
    const cachedSeasonLeaderboardData = localStorage.getItem(
      "season_leaderboard_data"
    );

    let cachedSeasonLeaderboard: PaginatedLeaderboard;
    try {
      cachedSeasonLeaderboard = JSON.parse(
        cachedSeasonLeaderboardData ||
          "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }"
      );
    } catch (e) {
      cachedSeasonLeaderboard = {
        entries: [],
        gameweek: 0,
        seasonId: 0,
        totalEntries: 0n,
      };
    }

    return cachedSeasonLeaderboard;
  }

  async function getLeadingWeeklyTeam(): Promise<LeaderboardEntry> {
    let weeklyLeaderboard = await getWeeklyLeaderboard();
    return weeklyLeaderboard.entries[0];
  }

  return {
    subscribe,
    syncWeeklyLeaderboard,
    syncMonthlyLeaderboards,
    syncSeasonLeaderboard,
    getWeeklyLeaderboard,
    getWeeklyLeaderboardPage,
    getMonthlyLeaderboard,
    getSeasonLeaderboard,
    getLeadingWeeklyTeam
  };
}

export const leaderboardStore = createLeaderboardStore();
