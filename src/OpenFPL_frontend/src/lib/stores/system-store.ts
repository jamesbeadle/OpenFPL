import { writable } from 'svelte/store';
import type { SystemState, DataCache } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createSystemStore() {
  const { subscribe, set } = writable<SystemState | null>(null);

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    let category = "system_state";
    const newHashValues: DataCache[] = await actor.getDataHashes();
    let liveHash = newHashValues.find(x => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);

    if (liveHash?.hash != localHash) {
      let updatedSystemStateData = await actor.getSystemState();
      localStorage.setItem("system_state_data", JSON.stringify(updatedSystemStateData, replacer));
      localStorage.setItem(category, liveHash?.hash ?? "");
      set(updatedSystemStateData);
    } else {
      const cachedSystemStateData = localStorage.getItem("system_state_data");
      let cachedSystemState: SystemState | null = null;
      try {
        cachedSystemState = JSON.parse(cachedSystemStateData || "{}");
      } catch (e) {
        cachedSystemState = null;
      }
      set(cachedSystemState);
    }
  }

  async function getSystemState(): Promise<SystemState | undefined> {
    let systemState;
    subscribe(value => { systemState = value! })();
    return systemState;
  }

  return {
    subscribe,
    sync,
    getSystemState
  };
}

export const systemStore = createSystemStore();
