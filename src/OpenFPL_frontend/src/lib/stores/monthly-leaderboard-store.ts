import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  LeaderboardEntry,
  MonthlyLeaderboardDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createMonthlyLeaderboardStore() {
  const { subscribe, set } = writable<MonthlyLeaderboardDTO[] | null>(null);
  const itemsPerPage = 25;

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function syncMonthlyLeaderboard() {
    let category = "monthly_leaderboards";
    const newHashValues: DataCacheDTO[] = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getMonthlyLeaderboardCache(
        systemState?.calculationSeasonId,
        systemState?.calculationGameweek
      );
      localStorage.setItem(
        "monthly_leaderboard_data",
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }

  async function getMonthlyLeaderboard(
    clubId: number,
    month: number,
    currentPage: number
    ): Promise<MonthlyLeaderboardDTO> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    

    if(currentPage < 4 && month == systemState?.calculationMonth){
        const cachedData = localStorage.getItem(
            "monthly_leaderboard_data"
        );

        if (cachedData) {
            let cachedLeaderboards: MonthlyLeaderboardDTO[] = JSON.parse(cachedData);
            let clubLeaderboard = cachedLeaderboards.find((x) => x.clubId === clubId);
            
            if (clubLeaderboard) {
                return {
                    ...clubLeaderboard,
                    entries: clubLeaderboard.entries.slice(offset, offset + limit),
                };
            }
        }
    }

    let leaderboardData = await actor.getClubLeaderboard(
        systemState?.calculationSeasonId,
        month,
        clubId,
        limit,
        offset
      );
      return leaderboardData;
  }

  return {
    subscribe,
    syncMonthlyLeaderboard,
    getMonthlyLeaderboard
  };
}

export const monthlyLeaderboardStore = createMonthlyLeaderboardStore();
