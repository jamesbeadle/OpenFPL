import { ActorFactory } from "../utils/actor.factory";
import { toasts } from "$lib/stores/toasts-store";
import { authStore } from "$lib/stores/auth-store";
import type {
  GetAllTimeHighScores,
  AllTimeHighScores,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { isError } from "$lib/utils/Helpers";

export class AllTimeHighScoreService {
  constructor() {}

  async getAllTimeHighScores(
    dto: GetAllTimeHighScores,
  ): Promise<AllTimeHighScores | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.getAllTimeHighScores(dto);
      if (isError(result))
        throw new Error("Failed to fetch all time high scores");
      return result.ok;
    } catch (error) {
      console.error("Error fetching fixtures: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching all time high scores.",
      });
    }
  }
}
