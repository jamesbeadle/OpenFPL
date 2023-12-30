import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  SeasonLeaderboardDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

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
    const newHashValues: DataCacheDTO[] = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedLeaderboardData = await actor.getSeasonLeaderboard(
        systemState?.calculationSeasonId
      );
      set(updatedLeaderboardData);
      localStorage.setItem(
        category,
        JSON.stringify(updatedLeaderboardData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
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

    let leaderboardData = await actor.getSeasonLeaderboard(
      seasonId,
      limit,
      offset
    );

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
