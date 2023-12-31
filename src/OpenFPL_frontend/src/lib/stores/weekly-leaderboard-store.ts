import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  LeaderboardEntry,
  SystemStateDTO,
  WeeklyLeaderboardDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/Helpers";

function createWeeklyLeaderboardStore() {
  const { subscribe, set } = writable<WeeklyLeaderboardDTO | null>(null);
  const itemsPerPage = 25;
  const category = "weekly_leaderboard";

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    let category = "weekly_leaderboard";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing leaderboard store");
      return;
    }

    let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataCacheDTO) => x.category === category) ??
      null;
    const localHash = localStorage.getItem(category);

    if (categoryHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getWeeklyLeaderboard(
        systemState?.calculationSeasonId,
        systemState?.calculationGameweek,
        100,
        0
      );

      if(isError(updatedLeaderboardData)){
        console.error("error fetching leaderboard store")
      }

      localStorage.setItem(
        category,
        JSON.stringify(updatedLeaderboardData.ok, replacer)
      );
      localStorage.setItem(category, categoryHash?.hash ?? "");
      set(updatedLeaderboardData.ok);
    }
  }

  async function getWeeklyLeaderboard(
    seasonId: number,
    gameweek: number,
    currentPage: number
  ): Promise<WeeklyLeaderboardDTO> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;

    if (currentPage <= 4 && gameweek == systemState?.calculationGameweek) {
      const cachedData = localStorage.getItem(category);

      if (cachedData) {
        let cachedWeeklyLeaderboard: WeeklyLeaderboardDTO;
        cachedWeeklyLeaderboard = JSON.parse(
          cachedData ||
            "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }"
        );

        if (cachedWeeklyLeaderboard) {
          return {
            ...cachedWeeklyLeaderboard,
            entries: cachedWeeklyLeaderboard.entries.slice(
              offset,
              offset + limit
            ),
          };
        }
      }
    }

    let leaderboardData = await actor.getweeklyLeaderboard(
      seasonId,
      gameweek,
      limit,
      offset
    );

    localStorage.setItem(category, JSON.stringify(leaderboardData, replacer));

    return leaderboardData;
  }

  async function getLeadingWeeklyTeam(): Promise<LeaderboardEntry> {
    let weeklyLeaderboard = await getWeeklyLeaderboard(
      systemState.calculationSeasonId,
      systemState.calculationGameweek,
      1
    );
    return weeklyLeaderboard.entries[0];
  }

  return {
    subscribe,
    sync,
    getWeeklyLeaderboard,
    getLeadingWeeklyTeam,
  };
}

export const weeklyLeaderboardStore = createWeeklyLeaderboardStore();
