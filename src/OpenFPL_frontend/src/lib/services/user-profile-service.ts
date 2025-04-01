import { UserService } from "$lib/services/user-service";
import { toasts } from "$lib/stores/toasts-store";
import { userIdCreatedStore } from "$lib/stores/user-control-store";
import { initErrorSignOut } from "./auth-services";
import type { OptionIdentity } from "$lib/types/identity";
import type { Profile } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export type InitUserProfileResult = { result: "skip" | "success" | "error" };

export const initUserProfile = async ({
  identity,
}: {
  identity: OptionIdentity;
}): Promise<InitUserProfileResult> => {
  if (!identity) return { result: "skip" };

  try {
    const profile = await new UserService().getUser();
    if (profile) {
      userIdCreatedStore.set({ data: profile.principalId, certified: true });
      return { result: "success" };
    }
    return { result: "skip" };
  } catch (err) {
    toasts.addToast({
      message: "Error initializing user profile",
      type: "error",
    });
    console.error("initUserProfile error", err);
    await initErrorSignOut();
    return { result: "error" };
  }
};
