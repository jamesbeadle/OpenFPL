import {
  AUTH_MAX_TIME_TO_LIVE,
  AUTH_POPUP_HEIGHT,
  AUTH_POPUP_WIDTH,
  DEV,
  INTERNET_IDENTITY_CANISTER_ID,
} from "../constants/app.constants";
import {
  SignInError,
  SignInInitError,
  SignInUserInterruptError,
} from "$lib/types/errors";
import type { OptionIdentity } from "../types/identity";
import { createAuthClient } from "../utils/auth.utils";
import { popupCenter } from "../utils/window.utils";
import { type AuthClient, ERROR_USER_INTERRUPT } from "@dfinity/auth-client";
import { isNullish } from "@dfinity/utils";
import { writable, type Readable } from "svelte/store";

export interface AuthStoreData {
  identity: OptionIdentity;
}

let authClient: AuthClient | undefined | null;

const NNS_IC_ORG_ALTERNATIVE_ORIGIN = "https://openfpl.xyz";
const NNS_IC_APP_DERIVATION_ORIGIN =
  "https://5gbds-naaaa-aaaal-qmzqa-cai.icp0.io";

const isNnsAlternativeOrigin = () => {
  return window.location.origin === NNS_IC_ORG_ALTERNATIVE_ORIGIN;
};

export interface AuthSignInParams {
  domain?: "ic0.app" | "internetcomputer.org";
}

export interface AuthStore extends Readable<AuthStoreData> {
  sync: () => Promise<void>;
  signIn: (params: AuthSignInParams) => Promise<void>;
  signOut: () => Promise<void>;
}

const initAuthStore = (): AuthStore => {
  const { subscribe, set, update } = writable<AuthStoreData>({
    identity: undefined,
  });

  return {
    subscribe,

    sync: async () => {
      authClient = authClient ?? (await createAuthClient());
      const isAuthenticated: boolean = await authClient.isAuthenticated();

      set({
        identity: isAuthenticated ? authClient.getIdentity() : null,
      });
    },

    signIn: ({ domain }: AuthSignInParams) =>
      // eslint-disable-next-line no-async-promise-executor
      new Promise<void>(async (resolve, reject) => {
        if (isNullish(authClient)) {
          reject(new SignInInitError());
          return;
        }
        //authClient = authClient ?? (await createAuthClient());
        //const identityProvider = domain;
        const identityProvider = DEV
          ? INTERNET_IDENTITY_CANISTER_ID
          : `https://identity.${domain ?? "internetcomputer.org"}`;
        await authClient?.login({
          maxTimeToLive: AUTH_MAX_TIME_TO_LIVE,
          onSuccess: () => {
            set({ identity: authClient?.getIdentity() });
            resolve();
          },
          onError: (error?: string) => {
            if (error === ERROR_USER_INTERRUPT) {
              reject(new SignInUserInterruptError(error));
              return;
            }

            reject(new SignInError(error));
          },
          identityProvider,
          windowOpenerFeatures: popupCenter({
            width: AUTH_POPUP_WIDTH,
            height: AUTH_POPUP_HEIGHT,
          }),
        });
      }),

    signOut: async () => {
      const client: AuthClient = authClient ?? (await createAuthClient());
      await client.logout();
      authClient = null;
      set({ identity: null });
      localStorage.removeItem("user_profile_data");
      authClient = await createAuthClient();
    },
  };
};

export const authStore = initAuthStore();

export const authRemainingTimeStore = writable<number | undefined>(undefined);
