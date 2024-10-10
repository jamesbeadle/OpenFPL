import { writable } from "svelte/store";
import type { SystemStateDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createSystemStore() {
  const { subscribe, set } = writable<SystemStateDTO | null>(null);

  return {
    subscribe,
    setSystemState: (systemState: SystemStateDTO) => set(systemState),
  };
}

export const systemStore = createSystemStore();
