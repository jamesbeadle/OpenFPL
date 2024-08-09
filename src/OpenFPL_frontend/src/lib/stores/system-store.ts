import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  GetCanistersDTO,
  GetRewardPoolDTO,
  GetSystemLogDTO,
  GetTimersDTO,
  GetTopupsDTO,
  SeasonDTO,
  SystemStateDTO,
  TimerDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/helpers";
import { authStore } from "./auth.store";

function createSystemStore() {
  const { subscribe, set } = writable<SystemStateDTO | null>(null);
  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  async function sync() {
    await authStore.sync();

    let category = "system_state";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing system store");
      return;
    }

    let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataCacheDTO) => x.category === category) ??
      null;

    const localHash = localStorage.getItem(`${category}_hash`);

    if (categoryHash?.hash != localHash) {
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

  async function getCanisters(): Promise<GetCanistersDTO | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let result = await identityActor.getCanisters();
      console.log(result);

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

  async function getTimers(): Promise<GetTimersDTO | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let result = await identityActor.getTimers();
      console.log(result);

      if (isError(result)) {
        console.error("Error getting timers:", result);
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Error getting timers:", error);
      throw error;
    }
  }

  async function getLogs(
    dto: GetSystemLogDTO,
  ): Promise<GetSystemLogDTO | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let result = await identityActor.getSystemLog(dto);

      if (isError(result)) {
        console.error("Error getting system logs:", result);
        return;
      }
      return result.ok;
    } catch (error) {
      console.error("Error getting system logs:", error);
      throw error;
    }
  }

  async function getRewardPools(): Promise<GetRewardPoolDTO | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let result = await identityActor.getRewardPool();
      console.log(result);

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

  async function getTopups(): Promise<GetTopupsDTO | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let result = await identityActor.getTopups();
      console.log(result);

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

  return {
    subscribe,
    sync,
    getSystemState,
    getSeasons,
    getLogs,
    getTimers,
    getCanisters,
    getRewardPools,
    getTopups,
  };
}

export const systemStore = createSystemStore();
