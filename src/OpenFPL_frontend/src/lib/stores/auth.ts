import {
  AUTH_MAX_TIME_TO_LIVE,
  AUTH_POPUP_HEIGHT,
  AUTH_POPUP_WIDTH,
} from "$lib/constants/app.constants";
import type { OptionIdentity } from "$lib/types/Identity";
import { createAuthClient } from "$lib/utils/auth.utils";
import { popupCenter } from "$lib/utils/window.utils";
import type { AuthClient } from "@dfinity/auth-client";
import { writable, type Readable } from "svelte/store";

export interface AuthStoreData {
  identity: OptionIdentity;
}

let authClient: AuthClient | undefined | null;

export interface AuthSignInParams {
  domain?: "ic0.app" | "internetcomputer.org";
}

const NNS_IC_ORG_ALTERNATIVE_ORIGIN = "https://openfpl.xyz";
const NNS_IC_APP_DERIVATION_ORIGIN =
  "https://bgpwv-eqaaa-aaaal-qb6eq-cai.icp0.io";

export interface AuthStore extends Readable<AuthStoreData> {
  sync: () => Promise<void>;
  signIn: (params: AuthSignInParams) => Promise<void>;
  signOut: () => Promise<void>;
}

const isNnsAlternativeOrigin = () => {
  return window.location.origin === NNS_IC_ORG_ALTERNATIVE_ORIGIN;
};

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
      new Promise<void>(async (resolve, reject) => {
        authClient = authClient ?? (await createAuthClient());
        const identityProvider = import.meta.env.VITE_AUTH_PROVIDER_URL;

        await authClient?.login({
          maxTimeToLive: AUTH_MAX_TIME_TO_LIVE,
          onSuccess: () => {
            update((state: AuthStoreData) => ({
              ...state,
              identity: authClient?.getIdentity(),
            }));

            resolve();
          },
          onError: reject,
          identityProvider,
          ...(isNnsAlternativeOrigin() && {
            derivationOrigin: NNS_IC_APP_DERIVATION_ORIGIN,
          }),
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

      update((state: AuthStoreData) => ({
        ...state,
        identity: null,
      }));
    },
  };
};

export const authStore = initAuthStore();

export const authRemainingTimeStore = writable<number | undefined>(undefined);
