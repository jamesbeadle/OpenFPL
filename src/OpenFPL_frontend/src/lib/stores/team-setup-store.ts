import { writable } from "svelte/store";
import type { TeamSetup } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export interface TeamSetupStore {
  set: (data: TeamSetup | undefined) => void;
  reset: () => void;
}

function createTeamSetupStore() {
  const { subscribe, set } = writable<TeamSetup | undefined>(undefined);

  return {
    subscribe,

    set(data: TeamSetup) {
      set(data);
    },

    reset: () => {
      set(undefined);
    },
  };
}

export const teamSetupStore = createTeamSetupStore();
