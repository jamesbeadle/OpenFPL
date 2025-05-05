import { ActorFactory } from "../utils/actor.factory";
import { isError } from "$lib/utils/Helpers";
import { authStore } from "$lib/stores/auth-store";
import type {
  CombinedProfile,
  ICFCLinkStatus,
  Result,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class UserService {
  async getUser(): Promise<CombinedProfile | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result: any = await identityActor.getProfile();
      if (isError(result)) {
        console.error("isError fetching user profile: ", result);
        return undefined;
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching user profile: ", error);
      return undefined;
    }
  }

  async getICFCLinkStatus(): Promise<ICFCLinkStatus | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result: any = await identityActor.getICFCLinkStatus();
      if (isError(result)) return undefined;
      return result.ok;
    } catch (error) {
      console.error("Error checking ICFC link status:", error);
      return undefined;
    }
  }

  async linkICFCProfile(): Promise<{
    success: boolean;
    alreadyExists?: boolean;
  }> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result: Result = await identityActor.linkICFCProfile();

      if ("err" in result) {
        if ("AlreadyExists" in result.err) {
          return { success: false, alreadyExists: true };
        }
        return { success: false, alreadyExists: false };
      }

      return { success: true, alreadyExists: false };
    } catch (error) {
      console.error("Error linking ICFC profile:", error);
      return { success: false, alreadyExists: false };
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
