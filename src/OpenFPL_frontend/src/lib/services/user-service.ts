import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { authStore } from "$lib/stores/auth-store";
import { toasts } from "$lib/stores/toasts-store";
import type {
  CombinedProfile,
  GetICFCLinkStatus,
  GetProfile,
  ICFCLinkStatus,
  Result,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class UserService {
  async getUser(principalId: string): Promise<CombinedProfile | undefined> {
    try {
      // Dummy profile for testing
      const dummyProfile: CombinedProfile = {
        username: "test_user",
        displayName: "Test User",
        termsAccepted: true,
        createdOn: BigInt(Date.now()),
        createDate: BigInt(Date.now()),
        favouriteClubId: [],
        membershipClaims: [],
        profilePicture: [],
        membershipType: { Founding: null },  // or any other type you want to test
        termsAgreed: true,
        membershipExpiryTime: BigInt(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days from now
        favouriteLeagueId: [],
        nationalityId: [],
        profilePictureType: "image/jpeg",
        principalId: principalId
      };

      return dummyProfile;

      // Comment out original implementation
      /*
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const getProfile: GetProfile = { principalId };
      const result: any = await identityActor.getProfile(getProfile);
      if (isError(result)) return undefined;
      return result.ok;
      */
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
      const result: any = await identityActor.getICFCLinkStatus(getICFCLinkStatus);
      console.log(result);
      if (isError(result)) return undefined;
      return result.ok;
    } catch (error) {
      console.error("Error checking ICFC link status:", error);
      return undefined;
    }
  }

  async linkICFCProfile(): Promise<{ success: boolean; alreadyExists?: boolean }> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result: Result = await identityActor.linkICFCProfile();
      console.log('Link ICFC result:', result);
      
      if ('err' in result) {
        if ('AlreadyExists' in result.err) {
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
