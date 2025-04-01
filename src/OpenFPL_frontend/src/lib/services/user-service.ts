import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import { toasts } from "$lib/stores/toasts-store";
import type { CombinedProfile, GetProfile } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class UserService {
  async getUser(principalId: string): Promise<CombinedProfile | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const getProfile: GetProfile = { principalId };
      const result: any = await identityActor.getProfile(getProfile);
      if (isError(result)) throw new Error("Failed to get profile.");
      return result.ok;
    } catch (error) {
      console.error("Error fetching user profile: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching user profile.",
      });
      throw error;
    }
  }

  /* // TODO
  async getUserIFCFMembership(): Promise<ICFCMembershipDTO | undefined> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
    );
    return await identityActor.getUserIFCFMembership();
  }
    */
}
