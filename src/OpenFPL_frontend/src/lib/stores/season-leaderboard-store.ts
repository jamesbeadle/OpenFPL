import { leagueStore } from "$lib/stores/league-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataHashDTO,
  GetSeasonLeaderboardDTO,
  SeasonLeaderboardDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../utils/actor.factory";
import { isError, replacer } from "../utils/helpers";
import { storeManager } from "$lib/managers/store-manager";

function createSeasonLeaderboardStore() {
  const { subscribe, set } = writable<SeasonLeaderboardDTO | null>(null);
  const itemsPerPage = 25;
  const category = "season_leaderboard";

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  async function sync(seasonId: number) {
    let category = "season_leaderboard";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error fetching leaderboard store.");
      return;
    }

    let dataCacheValues: DataHashDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataHashDTO) => x.category === category) ?? null;

    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash?.hash != localHash) {
      const limit = itemsPerPage;
      const offset = 0;

      let dto: GetSeasonLeaderboardDTO = {
        offset: BigInt(offset),
        seasonId: seasonId,
        limit: BigInt(limit),
        searchTerm: "",
      };
      let result = await actor.getSeasonLeaderboard(dto);
      if (isError(result)) {
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
      const cachedLeaderboardData = localStorage.getItem(category);
      let cachedSeasonLeaderboard: SeasonLeaderboardDTO = {
        entries: [],
        seasonId: 0,
        totalEntries: 0n,
      };
      try {
        cachedSeasonLeaderboard = JSON.parse(
          cachedLeaderboardData ||
            "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }",
        );
      } catch (e) {
        cachedSeasonLeaderboard = {
          entries: [],
          seasonId: 0,
          totalEntries: 0n,
        };
      }
      set(cachedSeasonLeaderboard);
    }
  }

  async function getSeasonLeaderboard(
    seasonId: number,
    currentPage: number,
    searchTerm: string,
  ): Promise<SeasonLeaderboardDTO | null> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    await storeManager.syncStores();

    let dto: SeasonLeaderboardDTO | null = null;
    leagueStore.subscribe(async (value) => {
      if (!value) {
        return;
      }
      if (currentPage <= 4 && seasonId == value.activeSeasonId) {
        const cachedData = localStorage.getItem(category);

        if (cachedData && cachedData != "undefined") {
          let cachedSeasonLeaderboard: SeasonLeaderboardDTO;
          cachedSeasonLeaderboard = JSON.parse(
            cachedData || "{entries: [], seasonId: 0, totalEntries: 0n }",
          );

          if (cachedSeasonLeaderboard) {
            return {
              ...cachedSeasonLeaderboard,
              entries: cachedSeasonLeaderboard.entries.slice(
                offset,
                offset + limit,
              ),
            };
          }
        }
      }

      let dto: GetSeasonLeaderboardDTO = {
        offset: BigInt(offset),
        seasonId: seasonId,
        limit: BigInt(limit),
        searchTerm: "",
      };
      let result = await actor.getSeasonLeaderboard(dto);

      if (isError(result)) {
        return {
          totalEntries: 0n,
          seasonId: 1,
          entries: [],
        };
      }

      dto = result.ok;

      localStorage.setItem(category, JSON.stringify(dto, replacer));
    });

    return dto;
  }

  return {
    subscribe,
    sync,
    getSeasonLeaderboard,
  };
}

export const seasonLeaderboardStore = createSeasonLeaderboardStore();
