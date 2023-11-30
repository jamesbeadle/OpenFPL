import { A as AUTH_MAX_TIME_TO_LIVE, a as AUTH_POPUP_WIDTH, b as AUTH_POPUP_HEIGHT } from "./app.constants.js";
import { AuthClient } from "@dfinity/auth-client";
import "@dfinity/utils";
import { w as writable } from "./index.js";
const createAuthClient = () => AuthClient.create({
  idleOptions: {
    disableIdle: true,
    disableDefaultIdleCallback: true
  }
});
const popupCenter = ({
  width,
  height
}) => {
  {
    return void 0;
  }
};
let authClient;
const initAuthStore = () => {
  const { subscribe, set, update } = writable({
    identity: void 0
  });
  return {
    subscribe,
    sync: async () => {
      authClient = authClient ?? await createAuthClient();
      const isAuthenticated = await authClient.isAuthenticated();
      set({
        identity: isAuthenticated ? authClient.getIdentity() : null
      });
    },
    signIn: ({ domain }) => new Promise(async (resolve, reject) => {
      authClient = authClient ?? await createAuthClient();
      const identityProvider = "https://identity.ic0.app";
      await authClient?.login({
        maxTimeToLive: AUTH_MAX_TIME_TO_LIVE,
        onSuccess: () => {
          update((state) => ({
            ...state,
            identity: authClient?.getIdentity()
          }));
          resolve();
        },
        onError: reject,
        identityProvider,
        windowOpenerFeatures: popupCenter({
          width: AUTH_POPUP_WIDTH,
          height: AUTH_POPUP_HEIGHT
        })
      });
    }),
    signOut: async () => {
      const client = authClient ?? await createAuthClient();
      await client.logout();
      authClient = null;
      update((state) => ({
        ...state,
        identity: null
      }));
    }
  };
};
const authStore = initAuthStore();
export {
  authStore as a
};
