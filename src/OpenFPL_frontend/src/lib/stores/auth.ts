import { writable, derived } from 'svelte/store';
import { AuthClient } from "@dfinity/auth-client";

interface AuthState {
  identity: any;
}

const { subscribe, set } = writable<AuthState>({ identity: null });
  
const authStore = {
    subscribe,
    set,
    login: async () => {
      const authClient = await AuthClient.create();
      const identityProviderUrl = import.meta.env.VITE_AUTH_PROVIDER_URL;

      await authClient.login({
            maxTimeToLive: BigInt(7 * 24 * 60 * 60 * 1000 * 1000 * 1000),
            onSuccess: async () => {
                const identity = await authClient.getIdentity();
                set({ identity  });
            },
            identityProvider: identityProviderUrl, // Pass the URL here
        });
    },
    logout: async () => {
        set({ identity: null});
    }
};

const isAuthenticated = derived(
  authStore, 
  $authStore => $authStore.identity !== null
);

const principalId = derived(
  authStore, 
  $authStore => $authStore.identity?.getPrincipal().toString()
);

export { authStore, isAuthenticated, principalId };
