import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  SeasonId,
  GetRewardPoolDTO,
  RewardPool,
  RewardPoolDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { toasts } from "$lib/stores/toasts-store";

export class RewardPoolService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getRewardPool(seasonId: SeasonId): Promise<RewardPool | undefined> {
    try {
      let dto: GetRewardPoolDTO = {
        seasonId,
      };
      const result = await this.actor.getRewardPool(dto);
      if (isError(result)) throw new Error("Failed to fetch reward pool");
      let rewardPoolResult: RewardPoolDTO = result.ok;
      return rewardPoolResult.rewardPool;
    } catch (error) {
      console.error("Error fetching reward pool: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching reward pool.",
      });
    }
  }
}
