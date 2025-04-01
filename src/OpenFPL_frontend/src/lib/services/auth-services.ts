import { authStore, type AuthSignInParams } from "../stores/auth-store";
import { replaceHistory } from "../utils/route.utils";
import { isNullish } from "@dfinity/utils";
import { busy } from "$lib/stores/busy-store";
import { toasts, type Toast } from "$lib/stores/toasts-store";

export const signIn = async (
  params: AuthSignInParams,
): Promise<{ success: "ok" | "cancelled" | "error"; err?: unknown }> => {
  busy.show();
  try {
    await authStore.signIn(params);
    return { success: "ok" };
  } catch (err: unknown) {
    if (err === "UserInterrupt") {
      return { success: "cancelled" };
    }

    toasts.addToast({
      message: "Error Signing In",
      type: "error",
    });

    return { success: "error", err };
  } finally {
    busy.stop();
  }
};

export const signOut = (): Promise<void> => logout({});

export const initErrorSignOut = async () =>
  await logout({
    msg: {
      message:
        "You have been signed out because there was an error initalizing your profile.",
      type: "error",
    },
  });

export const idleSignOut = async () =>
  await logout({
    msg: {
      message: "You have been logged out because your session has expired.",
      type: "info",
    },
    clearStorages: false,
  });

const logout = async ({
  msg = undefined,
  clearStorages = true,
}: {
  msg?: Omit<Toast, "id">;
  clearStorages?: boolean;
}) => {
  busy.start();

  if (clearStorages) {
    await Promise.all([
      //TODO: clear storages
    ]);
  }

  await authStore.signOut();

  if (msg) {
    toasts.addToast(msg);
  }

  // Auth: Delegation and identity are cleared from indexedDB by agent-js so, we do not need to clear these

  // Preferences: We do not clear local storage as well. It contains anonymous information such as the selected theme.
  // Information the user want to preserve across sign-in. e.g. if I select the light theme, logout and sign-in again, I am happy if the dapp still uses the light theme.

  // We reload the page to make sure all the states are cleared
  window.location.reload();
};

const PARAM_MSG = "msg";
const PARAM_LEVEL = "level";

/**
 * If the url contains a msg that has been provided on logout, display it as a toast message. Cleanup url afterwards - we don't want the user to see the message again if reloads the browser
 */
export const displayAndCleanLogoutMsg = () => {
  const urlParams: URLSearchParams = new URLSearchParams(
    window.location.search,
  );

  const msg: string | null = urlParams.get(PARAM_MSG);

  if (isNullish(msg)) {
    return;
  }
  const level: Toast["type"] =
    (urlParams.get(PARAM_LEVEL) as Toast["type"] | null) ?? "info";

  toasts.addToast({
    message: msg,
    type: level,
  });

  cleanUpMsgUrl();
};

const cleanUpMsgUrl = () => {
  const url: URL = new URL(window.location.href);

  url.searchParams.delete(PARAM_MSG);
  url.searchParams.delete(PARAM_LEVEL);

  replaceHistory(url);
};
