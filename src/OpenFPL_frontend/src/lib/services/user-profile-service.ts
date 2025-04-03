import { userStore } from "$lib/stores/user-store";
import { toasts } from "$lib/stores/toasts-store";
import { userIdCreatedStore } from "$lib/stores/user-control-store";
import { initErrorSignOut } from "./auth-services";
import { authStore } from "$lib/stores/auth-store";
import type { OptionIdentity } from "$lib/types/identity";
import type { CombinedProfile } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { get } from "svelte/store";

export type InitUserProfileResult = { result: "skip" | "success" | "error" };

export const initUserProfile = async ({
  identity,
}: {
  identity: OptionIdentity;
}): Promise<InitUserProfileResult> => {
  if (!identity) return { result: "skip" };

  try {
    const principalId = get(authStore).identity?.getPrincipal().toString();
    if (!principalId) return { result: "skip" };

    const profile = await userStore.getUser(principalId);
    console.log("profile in initUserProfile", profile);
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
