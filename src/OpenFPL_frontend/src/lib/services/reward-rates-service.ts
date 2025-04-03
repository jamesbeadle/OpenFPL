import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { toasts } from "$lib/stores/toasts-store";
import type { RewardRates } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { authStore } from "$lib/stores/auth-store";

export class RewardRatesService {
  async getRewardRates(): Promise<RewardRates | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.getActiveRewardRates();
      if (isError(result))
        throw new Error("Failed to fetch active reward rates");
      return result.ok;
    } catch (error) {
      console.error("Error fetching reward rates: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching reward rates.",
      });
    }
  }
}
