import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCache,
  LeaderboardEntry,
  PaginatedClubLeaderboard,
  PaginatedLeaderboard,
  SystemState,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createLeaderboardStore() {
  const { subscribe, set } = writable<PaginatedLeaderboard | null>(null);
  const itemsPerPage = 25;

  let systemState: SystemState;
  systemStore.subscribe((value) => {
    systemState = value as SystemState;
  });

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

  async function getWeeklyLeaderboardPage(
    gameweek: number,
    currentPage: number
  ): Promise<PaginatedLeaderboard> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;

    if (currentPage <= 4) {
      const cachedData = localStorage.getItem("weekly_leaderboard_data");
      if (cachedData) {
        let cachedLeaderboard: PaginatedLeaderboard = JSON.parse(cachedData);
        return {
          entries: cachedLeaderboard.entries.slice(offset, offset + limit),
          gameweek: cachedLeaderboard.gameweek,
          seasonId: cachedLeaderboard.seasonId,
          totalEntries: cachedLeaderboard.totalEntries,
        };
      }
    }

    let leaderboardData = await actor.getWeeklyLeaderboard(
      systemState?.activeSeason.id,
      gameweek,
      limit,
      offset
    );
    return leaderboardData;
  }

  async function getMonthlyLeaderboard(
    clubId: number,
    month: number,
    currentPage: number
  ): Promise<PaginatedClubLeaderboard | null> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;

    if (currentPage <= 4) {
      const cachedData = localStorage.getItem("monthly_leaderboard_data");
      if (cachedData) {
        let cachedLeaderboards: PaginatedClubLeaderboard[] =
          JSON.parse(cachedData);
        let clubLeaderboard = cachedLeaderboards.find(
          (x) => x.clubId === clubId
        );
        if (clubLeaderboard) {
          return {
            ...clubLeaderboard,
            entries: clubLeaderboard.entries.slice(offset, offset + limit),
          };
        }
      }
    }

    let leaderboardData = await actor.getClubLeaderboard(
      systemState?.activeSeason.id,
      month,
      clubId,
      limit,
      offset
    );
    return leaderboardData;
  }

  async function getSeasonLeaderboardPage(
    currentPage: number
  ): Promise<PaginatedLeaderboard> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;

    if (currentPage <= 4) {
      const cachedData = localStorage.getItem("season_leaderboard_data");
      if (cachedData) {
        let cachedLeaderboard: PaginatedLeaderboard = JSON.parse(cachedData);
        return {
          ...cachedLeaderboard,
          entries: cachedLeaderboard.entries.slice(offset, offset + limit),
        };
      }
    }

    let leaderboardData = await actor.getSeasonLeaderboard(
      systemState?.activeSeason.id,
      limit,
      offset
    );
    return leaderboardData;
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
    getSeasonLeaderboardPage,
    getLeadingWeeklyTeam,
  };
}

export const leaderboardStore = createLeaderboardStore();
