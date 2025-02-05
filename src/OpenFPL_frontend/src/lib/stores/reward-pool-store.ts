import { writable } from "svelte/store";
import type { RewardRatesDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createRewardRatesStore() {
  const { subscribe, set } = writable<RewardRatesDTO | undefined>(undefined);

  return {
    subscribe,
    setRewardRates: (rewardRates: RewardRatesDTO) => set(rewardRates),
  };
}

export const rewardRatesStore = createRewardRatesStore();
