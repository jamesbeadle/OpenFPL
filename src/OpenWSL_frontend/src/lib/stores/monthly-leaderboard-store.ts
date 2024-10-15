import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenWSL_backend";
import type {
  DataHashDTO,
  GetMonthlyLeaderboardDTO,
  MonthlyLeaderboardDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/helpers";

function createMonthlyLeaderboardStore() {
  const { subscribe, set } = writable<MonthlyLeaderboardDTO | null>(null);
  const itemsPerPage = 25;
  const category = "monthly_leaderboard_data";

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });
  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENWSL_BACKEND_CANISTER_ID,
  );

  async function sync(seasonId: number, month: number, clubId: number) {
    let category = "monthly_leaderboards";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing monthly leaderboard store");
      return;
    }

    let dataCacheValues: DataHashDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataHashDTO) => x.category === category) ?? null;

    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash?.hash != localHash) {
      const limit = itemsPerPage;
      const offset = 0;

      let dto: GetMonthlyLeaderboardDTO = {
        seasonId: seasonId,
        month: month,
        searchTerm: "",
        clubId: clubId,
        offset: BigInt(offset),
        limit: BigInt(limit),
      };
      let result = await actor.getMonthlyLeaderboard(dto);
      if (isError(result)) {
        let emptyLeaderboard = {
          entries: [],
          month: 0,
          seasonId: 0,
          totalEntries: 0n,
        };
        localStorage.setItem(
          category,
          JSON.stringify(emptyLeaderboard, replacer),
        );
        localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");

        console.error("error fetching leaderboard store");
        return;
      }

      let updatedLeaderboardData = result.ok;

      localStorage.setItem(
        category,
        JSON.stringify(updatedLeaderboardData.ok, replacer),
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedLeaderboardData.ok);
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

      if (cachedData && cachedData != "undefined") {
        let cachedMonthlyLeaderboard: MonthlyLeaderboardDTO;
        cachedMonthlyLeaderboard = JSON.parse(cachedData, replacer);

        if (cachedMonthlyLeaderboard) {
          return {
            ...cachedMonthlyLeaderboard,
            entries: cachedMonthlyLeaderboard.entries.slice(
              offset,
              offset + limit,
            ),
          };
        }
      }
    }

    let dto: GetMonthlyLeaderboardDTO = {
      offset: BigInt(offset),
      seasonId: seasonId,
      limit: BigInt(limit),
      searchTerm: searchTerm,
      month: month,
      clubId: clubId,
    };
    let result = await actor.getMonthlyLeaderboards(dto);

    if (isError(result)) {
      let emptyLeaderboard = {
        month: 0,
        clubId: 0,
        totalEntries: 0n,
        seasonId: 0,
        entries: [],
      };
      localStorage.setItem(
        category,
        JSON.stringify(emptyLeaderboard, replacer),
      );
      return {
        entries: [],
        clubId: 0,
        month: 0,
        seasonId: 0,
        totalEntries: 0n,
      };
    }

    localStorage.setItem(category, JSON.stringify(result.ok, replacer));

    return result;
  }

  return {
    subscribe,
    sync,
    getMonthlyLeaderboard,
  };
}

export const monthlyLeaderboardStore = createMonthlyLeaderboardStore();
