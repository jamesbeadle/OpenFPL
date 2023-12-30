import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  LeaderboardEntry,
  WeeklyLeaderboardDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createWeeklyLeaderboardStore() {
  const { subscribe, set } = writable<WeeklyLeaderboardDTO | null>(null);
  const itemsPerPage = 25;

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function syncWeeklyLeaderboard() {
    let category = "weekly_leaderboard";
    const newHashValues: DataCacheDTO[] = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getWeeklyLeaderboard(
        systemState?.calculationSeasonId,
        systemState?.calculationGameweek
      );
      localStorage.setItem(
        "weekly_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }

  async function getWeeklyLeaderboard(
    gameweek: number,
    currentPage: number
    ): Promise<WeeklyLeaderboardDTO> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;

    if(currentPage <= 4 && gameweek == systemState?.calculationGameweek){
        const cachedData = localStorage.getItem(
            "weekly_leaderboard_data"
        );
        
        if (cachedData) {
            let cachedWeeklyLeaderboard: WeeklyLeaderboardDTO;
            cachedWeeklyLeaderboard = JSON.parse(
                cachedData ||
                  "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }"
            );

            if(cachedWeeklyLeaderboard){
                return {
                    ...cachedWeeklyLeaderboard,
                    entries: cachedWeeklyLeaderboard.entries.slice(offset, offset + limit),
                }
            }
        }
    }

    let leaderboardData = await actor.getweeklyLeaderboard(
        systemState?.calculationSeasonId,
        gameweek,
        limit,
        offset
      );
      return leaderboardData;

  }

  async function getLeadingWeeklyTeam(): Promise<LeaderboardEntry> {
    let weeklyLeaderboard = await getWeeklyLeaderboard(
        systemState.calculationGameweek,
        1
    );
    return weeklyLeaderboard.entries[0];
  }

  return {
    subscribe,
    syncWeeklyLeaderboard,
    getWeeklyLeaderboard,
    getLeadingWeeklyTeam,
  };
}

export const weeklyLeaderboardStore = createWeeklyLeaderboardStore();
