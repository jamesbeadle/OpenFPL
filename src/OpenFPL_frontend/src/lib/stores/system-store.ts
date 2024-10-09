import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  CanisterType,
  DataHashDTO,
  GetCanistersDTO,
  GetRewardPoolDTO,
  GetTopupsDTO,
  SeasonDTO,
  SeasonId,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/helpers";
import { authStore } from "./auth.store";

function createSystemStore() {
  const { subscribe, set } = writable<SystemStateDTO | null>(null);
  console.log('Create actor in createSystemStore line 19');
  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  async function sync() {
    console.log('Syncing system and auth store');
    await authStore.sync();

    let category = "system_state";
    console.log('Actor getting data hashes in system store sync line 30');
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing system store");
      return;
    }

    let dataCacheValues: DataHashDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataHashDTO) => x.category === category) ?? null;

    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash != localHash) {
      console.log('Actor getting system state line 47');
      let result = await actor.getSystemState();
      if (isError(result)) {
        console.error("Error syncing system store");
        return;
      }

      let updatedSystemStateData = result.ok;

      localStorage.setItem(
        category,
        JSON.stringify(updatedSystemStateData, replacer),
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedSystemStateData);
    } else {
      const cachedSystemStateData = localStorage.getItem(category);
      let cachedSystemState: SystemStateDTO | null = null;
      try {
        cachedSystemState = JSON.parse(cachedSystemStateData || "{}");
      } catch (e) {
        cachedSystemState = null;
      }
      set(cachedSystemState);
    }
  }

  async function getSystemState(): Promise<SystemStateDTO | undefined> {
    let systemState;
    subscribe((value) => {
      systemState = value!;
    })();
    return systemState;
  }

  async function getSeasons(): Promise<SeasonDTO[]> {
    try {
      console.log('Actor getting seasons line 84');
      let result = await actor.getSeasons();

      if (isError(result)) {
        console.error("Error fetching seasons:");
        return [];
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching seasons:", error);
      throw error;
    }
  }

  async function getCanisters(
    currentPage: number,
    itemsPerPage: number,
    filter: CanisterType,
  ): Promise<GetCanistersDTO | undefined> {
    try {
      console.log('Creating actor in getCanisters line 104');
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );

      const limit = itemsPerPage;
      const offset = (currentPage - 1) * limit;

      let dto: GetCanistersDTO = {
        totalEntries: 0n,
        offset: BigInt(offset),
        limit: BigInt(limit),
        entries: [],
        canisterTypeFilter: filter,
      };
      console.log('Actor getting canisters line 120');
      let result = await identityActor.getCanisters(dto);

      if (isError(result)) {
        console.error("Error getting canisters:", result);
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Error getting canisters:", error);
      throw error;
    }
  }

  async function getRewardPool(
    seasonId: SeasonId,
  ): Promise<GetRewardPoolDTO | undefined> {
    try {
      console.log('Creating actor in getRewardPool line 138');
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );

      let dto: GetRewardPoolDTO = {
        seasonId: seasonId,
        rewardPool: {
          monthlyLeaderboardPool: 0n,
          allTimeSeasonHighScorePool: 0n,
          mostValuableTeamPool: 0n,
          highestScoringMatchPlayerPool: 0n,
          seasonId: seasonId,
          seasonLeaderboardPool: 0n,
          allTimeWeeklyHighScorePool: 0n,
          allTimeMonthlyHighScorePool: 0n,
          weeklyLeaderboardPool: 0n,
        },
      };
      console.log('Actor getting reward pool line 159');
      let result = await identityActor.getRewardPool(dto);

      if (isError(result)) {
        console.error("Error getting reward pools:", result);
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Error getting reward pools:", error);
      throw error;
    }
  }

  async function getTopups(
    currentPage: number,
    itemsPerPage: number,
  ): Promise<GetTopupsDTO | undefined> {
    try {
      console.log('Creating actor in getTopups line 15');
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );

      const limit = itemsPerPage;
      const offset = (currentPage - 1) * limit;

      let dto: GetTopupsDTO = {
        totalEntries: 0n,
        entries: [],
        offset: BigInt(offset),
        limit: BigInt(limit),
      };
      console.log('Actor getting topups line 193');
      let result = await identityActor.getTopups(dto);

      if (isError(result)) {
        console.error("Error getting topups:", result);
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Error getting topups:", error);
      throw error;
    }
  }

  async function getBackendCanisterBalance(): Promise<bigint | undefined> {
    try {
      console.log('Creating actor in getBackendCanisterBalance line 209');
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      console.log('Actor getting backend canister balance line 214');
      let result = await identityActor.getBackendCanisterBalance();

      if (isError(result)) {
        console.error("Error getting backend FPL balance:", result);
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Error getting backend FPL balance:", error);
      throw error;
    }
  }

  async function getBackendCanisterCyclesAvailable(): Promise<
    bigint | undefined
  > {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      console.log('Actor getting canister cycles balance line 236');
      let result = await identityActor.getCanisterCyclesBalance();

      if (isError(result)) {
        console.error("Error getting backend cycles:", result);
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Error getting backend cycles:", error);
      throw error;
    }
  }

  return {
    subscribe,
    sync,
    getSystemState,
    getSeasons,
    getCanisters,
    getRewardPool,
    getTopups,
    getBackendCanisterBalance,
    getBackendCanisterCyclesAvailable,
  };
}

export const systemStore = createSystemStore();
