import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  SeasonLeaderboardDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/Helpers";

function createSeasonLeaderboardStore() {
  const { subscribe, set } = writable<SeasonLeaderboardDTO | null>(null);
  const itemsPerPage = 25;
  const category = "season_leaderboard";

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    let category = "season_leaderboard";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing season leaderboard store");
      return;
    }

    let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataCacheDTO) => x.category === category) ??
      null;

    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash?.hash != localHash) {
      let result = await actor.getSeasonLeaderboard(
        systemState?.calculationSeasonId
      );

      if (isError(result)) {
        console.error("Error syncing season leaderboard.");
        return;
      }

      let updatedLeaderboardData = result.ok;

      localStorage.setItem(
        category,
        JSON.stringify(updatedLeaderboardData, replacer)
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
            "{entries: [], gameweek: 0, seasonId: 0, totalEntries: 0n }"
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
    currentPage: number
  ): Promise<SeasonLeaderboardDTO> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;

    if (currentPage <= 4 && seasonId == systemState?.calculationSeasonId) {
      const cachedData = localStorage.getItem(category);

      if (cachedData) {
        let cachedSeasonLeaderboard: SeasonLeaderboardDTO;
        cachedSeasonLeaderboard = JSON.parse(
          cachedData || "{entries: [], seasonId: 0, totalEntries: 0n }"
        );

        if (cachedSeasonLeaderboard) {
          return {
            ...cachedSeasonLeaderboard,
            entries: cachedSeasonLeaderboard.entries.slice(
              offset,
              offset + limit
            ),
          };
        }
      }
    }

    let result = await actor.getSeasonLeaderboard(seasonId, limit, offset);

    if (isError(result)) {
      console.error("Error fetching season leaderboard");
    }

    let leaderboardData = result.ok;

    localStorage.setItem(category, JSON.stringify(leaderboardData, replacer));

    return leaderboardData;
  }

  return {
    subscribe,
    sync,
    getSeasonLeaderboard,
  };
}

export const seasonLeaderboardStore = createSeasonLeaderboardStore();
