import { writable } from "svelte/store";
import type { RewardRates } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createRewardRatesStore() {
  const { subscribe, set } = writable<RewardRates | undefined>(undefined);

  return {
    subscribe,
    setRewardRates: (rewardRates: RewardRates) => set(rewardRates),
  };
}

export const rewardRatesStore = createRewardRatesStore();
