import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { toasts } from "$lib/stores/toasts-store";
import type { RewardRates } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class RewardRatesService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getRewardRates(): Promise<RewardRates | undefined> {
    try {
      const result = await this.actor.getActiveRewardRates();
      if (isError(result))
        throw new Error("Failed to fetch active reward rates");
      let rewardRatesResult: RewardRates = result.ok;
      return rewardRatesResult;
    } catch (error) {
      console.error("Error fetching reward rates: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching reward rates.",
      });
    }
  }
}
