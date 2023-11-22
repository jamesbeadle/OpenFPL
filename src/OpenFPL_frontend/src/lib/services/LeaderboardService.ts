import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCache,
  LeaderboardEntry,
  PaginatedClubLeaderboard,
  PaginatedLeaderboard,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../../utils/Helpers";
import { SystemService } from "./SystemService";

export class LeaderboardService {
  private actor: any;
  private itemsPerPage = 25;
  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  async updateWeeklyLeaderboardData() {
    let category = "weekly_leaderboard";
    const newHashValues: DataCache[] = await this.actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category == category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let systemService = new SystemService();
      await systemService.updateSystemStateData();
      let systemState = await systemService.getSystemState();
      let updatedLeaderboardData = await this.actor.getWeeklyLeaderboardCache(
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

  async updateMonthlyLeaderboardData() {
    let category = "monthly_leaderboards";
    const newHashValues: DataCache[] = await this.actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category == category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let systemService = new SystemService();
      await systemService.updateSystemStateData();
      let systemState = await systemService.getSystemState();
      let updatedLeaderboardData = await this.actor.getClubLeaderboardsCache(
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

  async updateSeasonLeaderboardData() {
    let category = "season_leaderboard";
    const newHashValues: DataCache[] = await this.actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category == category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let systemService = new SystemService();
      await systemService.updateSystemStateData();
      let systemState = await systemService.getSystemState();
      let updatedLeaderboardData = await this.actor.getSeasonLeaderboardCache(
        systemState?.activeSeason.id
      );
      localStorage.setItem(
        "season_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }

  async getWeeklyLeaderboard(): Promise<PaginatedLeaderboard> {
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

  async getWeeklyLeaderboardPage(
    gameweek: number,
    currentPage: number
  ): Promise<PaginatedLeaderboard> {
    const limit = this.itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let systemService = new SystemService();
    await systemService.updateSystemStateData();
    let systemState = await systemService.getSystemState();
    let weeklyLeaderboardData = await this.actor.getWeeklyLeaderboard(
      systemState?.activeSeason.id,
      gameweek,
      limit,
      offset
    );
    return weeklyLeaderboardData;
  }

  async getMonthlyLeaderboard(
    clubId: number
  ): Promise<PaginatedClubLeaderboard | null> {
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

  async getSeasonLeaderboard(): Promise<PaginatedLeaderboard> {
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

  async getLeadingWeeklyTeam(): Promise<LeaderboardEntry> {
    let weeklyLeaderboard = await this.getWeeklyLeaderboard();
    return weeklyLeaderboard.entries[0];
  }
}
