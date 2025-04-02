import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import { toasts } from "$lib/stores/toasts-store";
import type {
  CombinedProfile,
  GetICFCLinkStatus,
  GetProfile,
  ICFCLinkStatus,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class UserService {
  async getUser(principalId: string): Promise<CombinedProfile | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const getProfile: GetProfile = { principalId };
      const result: any = await identityActor.getProfile(getProfile);
      if (isError(result)) return undefined;
      return result.ok;
    } catch (error) {
      console.error("Error fetching user profile: ", error);
      toasts.addToast({
        type: "error",
        message: "User Profile Not Found.",
      });
      return undefined;
    }
  }

  async getICFCLinkStatus(
    principalId: string,
  ): Promise<ICFCLinkStatus | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const getICFCLinkStatus: GetICFCLinkStatus = { principalId };
      const result: any =
        await identityActor.getICFCLinkStatus(getICFCLinkStatus);
      console.log(result);
      if (isError(result)) return undefined;
      return result.ok;
    } catch (error) {
      console.error("Error checking ICFC link status:", error);
      return undefined;
    }
  }

  async linkICFCProfile(): Promise<boolean> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result: any = await identityActor.linkICFCProfile();
      console.log(result);
      if (isError(result)) return false;
      return true;
    } catch (error) {
      console.error("Error linking ICFC profile:", error);
      return false;
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
