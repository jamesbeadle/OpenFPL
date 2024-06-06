import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  GetMonthlyLeaderboardDTO,
  MonthlyLeaderboardDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/helpers";

function createMonthlyLeaderboardStore() {
  const { subscribe, set } = writable<MonthlyLeaderboardDTO[] | null>(null);
  const itemsPerPage = 25;
  const category = "monthly_leaderboard_data";

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  async function sync(seasonId: number, month: number) {
    let category = "monthly_leaderboards";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing monthly leaderboard store");
      return;
    }

    let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataCacheDTO) => x.category === category) ??
      null;

    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash?.hash != localHash) {
      const limit = itemsPerPage;
      const offset = 0;

      let dto: GetMonthlyLeaderboardDTO = {
        offset: BigInt(offset),
        seasonId: seasonId,
        limit: BigInt(limit),
        searchTerm: "",
        month: month,
        clubId: 1,
      };

      let result = await actor.getMonthlyLeaderboards(dto);

      if (isError(result)) {
        console.error("Error syncing monthly leaderboards");
        return;
      }

      let updatedLeaderboardData = result.ok;

      localStorage.setItem(
        category,
        JSON.stringify(updatedLeaderboardData, replacer),
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedLeaderboardData);
    } else {
      const cachedMonthlyLeaderboardsData = localStorage.getItem(category);
      let cachedMonthlyLeaderboards: MonthlyLeaderboardDTO[] = [];
      try {
        cachedMonthlyLeaderboards = JSON.parse(
          cachedMonthlyLeaderboardsData || "[]",
        );
      } catch (e) {
        cachedMonthlyLeaderboards = [];
      }
      set(cachedMonthlyLeaderboards);
    }
  }

  async function getMonthlyLeaderboard(
    seasonId: number,
    clubId: number,
    month: number,
    currentPage: number,
    searchTerm: string,
  ): Promise<MonthlyLeaderboardDTO> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;

    if (currentPage <= 4 && month == systemState?.calculationMonth) {
      const cachedData = localStorage.getItem(category);

      if (cachedData) {
        let cachedLeaderboards: MonthlyLeaderboardDTO[] =
          JSON.parse(cachedData);
        let clubLeaderboard = cachedLeaderboards.find(
          (x) => x.clubId === clubId,
        );

        if (clubLeaderboard) {
          return {
            ...clubLeaderboard,
            entries: clubLeaderboard.entries.slice(offset, offset + limit),
          };
        }
      }
    }

    let result = await actor.getClubLeaderboards(
      seasonId,
      month,
      clubId,
      limit,
      offset,
      searchTerm,
    );

    let emptyReturn = {
      month: 0,
      clubId: 0,
      totalEntries: 0n,
      seasonId: 0,
      entries: [],
    };

    if (isError(result)) {
      console.error("Error fetching monthly leaderboard");
      return emptyReturn;
    }

    let leaderboardData = result.ok as MonthlyLeaderboardDTO[];
    let clubLeaderboard = leaderboardData.find((x) => x.clubId === clubId);
    if (!clubLeaderboard) {
      return emptyReturn;
    }

    return {
      ...clubLeaderboard,
      entries: clubLeaderboard.entries.slice(offset, offset + limit),
    };
  }

  return {
    subscribe,
    sync,
    getMonthlyLeaderboard,
  };
}

export const monthlyLeaderboardStore = createMonthlyLeaderboardStore();
