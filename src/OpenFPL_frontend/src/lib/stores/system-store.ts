import { authStore } from "$lib/stores/auth.store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCacheDTO,
  SystemStateDTO,
  UpdateSystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isSuccess, replacer } from "../utils/Helpers";

function createSystemStore() {
  const { subscribe, set } = writable<SystemStateDTO | null>(null);

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    let category = "system_state";
    const newHashValues = await actor.getDataHashes();

    let error = isSuccess(newHashValues);
    if (error) {
      console.error("Error syncing system store");
      return;
    }

    let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataCacheDTO) => x.category === category) ??
      null;
    const localHash = localStorage.getItem(category);

    if (categoryHash?.hash != localHash) {
      let updatedSystemStateData = await actor.getSystemState();
      localStorage.setItem(
        "system_state_data",
        JSON.stringify(updatedSystemStateData, replacer)
      );
      localStorage.setItem(category, categoryHash?.hash ?? "");
      set(updatedSystemStateData);
    } else {
      const cachedSystemStateData = localStorage.getItem("system_state_data");
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

  async function updateSystemState(
    systemState: UpdateSystemStateDTO
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.updateSystemState(systemState);
      sync();
      return result;
    } catch (error) {
      console.error("Error updating system state:", error);
      throw error;
    }
  }

  return {
    subscribe,
    sync,
    getSystemState,
    updateSystemState,
  };
}

export const systemStore = createSystemStore();
