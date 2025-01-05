import { writable } from "svelte/store";
import type { RewardPool } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createRewardPoolStore() {
  const { subscribe, set } = writable<RewardPool | undefined>(undefined);

  return {
    subscribe,
    setRewardPool: (rewardPool: RewardPool) => set(rewardPool),
  };
}

export const rewardPoolStore = createRewardPoolStore();
