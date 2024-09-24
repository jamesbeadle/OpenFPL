import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  GetWeeklyLeaderboardDTO,
  LeaderboardEntry,
  WeeklyLeaderboardDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/helpers";

function createWeeklyLeaderboardStore() {
  const { subscribe, set } = writable<WeeklyLeaderboardDTO | null>(null);
  const itemsPerPage = 25;
  const category = "weekly_leaderboard";

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  async function sync(seasonId: number, gameweek: number) {
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

    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      const limit = itemsPerPage;
      const offset = 0;

      let dto: GetWeeklyLeaderboardDTO = {
        offset: BigInt(offset),
        seasonId: seasonId,
        limit: BigInt(limit),
        searchTerm: "",
        gameweek: gameweek,
      };

      let result = await actor.getWeeklyLeaderboard(dto);
      if (isError(result)) {
        let emptyLeaderboard = {
          entries: [],
          gameweek: 0,
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

  async function getWeeklyLeaderboard(
    seasonId: number,
    gameweek: number,
    currentPage: number,
    calculationGameweek: number,
    searchTerm: string,
  ): Promise<WeeklyLeaderboardDTO> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
 
    if (currentPage <= 4 && gameweek == calculationGameweek) {
      const cachedData = localStorage.getItem(category);
      if (cachedData && cachedData != "undefined") {
        let cachedWeeklyLeaderboard: WeeklyLeaderboardDTO;
        cachedWeeklyLeaderboard = JSON.parse(cachedData, replacer);

        if (cachedWeeklyLeaderboard) {
          return {
            ...cachedWeeklyLeaderboard,
            entries: cachedWeeklyLeaderboard.entries.slice(
              offset,
              offset + limit,
            ),
          };
        }
      } 
    }
    let dto: GetWeeklyLeaderboardDTO = {
      offset: BigInt(offset),
      seasonId: seasonId,
      limit: BigInt(limit),
      searchTerm: searchTerm,
      gameweek: gameweek,
    };
    let leaderboardData = await actor.getWeeklyLeaderboard(dto);
    if (isError(leaderboardData)) { 
      let emptyLeaderboard = {
        entries: [],
        gameweek: 0,
        seasonId: 0,
        totalEntries: 0n,
      };
      localStorage.setItem(
        category,
        JSON.stringify(emptyLeaderboard, replacer),
      );
      return { entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }; 
    }
    localStorage.setItem(
      category,
      JSON.stringify(leaderboardData.ok, replacer),
    );
    return leaderboardData;
  }

  async function getLeadingWeeklyTeam(
    seasonId: number,
    gameweek: number,
  ): Promise<LeaderboardEntry> {
    const limit = itemsPerPage;
    const offset = 0;

    let dto: GetWeeklyLeaderboardDTO = {
      offset: BigInt(offset),
      seasonId: seasonId,
      limit: BigInt(limit),
      searchTerm: "",
      gameweek: gameweek,
    };

    let leaderboardData = await actor.getWeeklyLeaderboard(dto);

    if (isError(leaderboardData)) {
      return {
        username: "-",
        positionText: "-",
        position: 0n,
        principalId: "",
        points: 0,
      };
    }

    return leaderboardData.ok.entries[0];
  }

  return {
    subscribe,
    sync,
    getWeeklyLeaderboard,
    getLeadingWeeklyTeam,
  };
}

export const weeklyLeaderboardStore = createWeeklyLeaderboardStore();
