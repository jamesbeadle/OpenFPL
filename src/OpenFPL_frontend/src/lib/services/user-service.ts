import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { authStore } from "$lib/stores/auth.store";
import { toasts } from "$lib/stores/toasts-store";
import type { Profile } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class UserService {
  async getUser(): Promise<Profile | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let getProfileResponse = await identityActor.getProfile();
      if (isError(getProfileResponse)) {
        return undefined;
      }
      return getProfileResponse.ok;
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
