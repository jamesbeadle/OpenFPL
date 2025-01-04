import { leagueStore } from "$lib/stores/league-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataHashDTO,
  GetMonthlyLeaderboardDTO,
  MonthlyLeaderboardDTO,
  AppStatusDTO,
  LeagueStatus,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../utils/actor.factory";
import { isError, replacer } from "../utils/helpers";

function createMonthlyLeaderboardStore() {
  const { subscribe, set } = writable<MonthlyLeaderboardDTO | null>(null);
  const itemsPerPage = 25;
  const category = "monthly_leaderboard_data";

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  async function sync(seasonId: number, month: number, clubId: number) {
    //TODO
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
    //TODO
    return {
      month: 0,
      clubId: 0,
      totalEntries: 0n,
      seasonId: 0,
      entries: [],
    };
  }

  return {
    subscribe,
    sync,
    getMonthlyLeaderboard,
  };
}

export const monthlyLeaderboardStore = createMonthlyLeaderboardStore();
