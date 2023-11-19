import { onMount } from 'svelte';
import { AuthClient } from "@dfinity/auth-client";
import { derived, writable } from "svelte/store";

interface AuthState {
  identity: any;
}

const { subscribe, set } = writable<AuthState>({ identity: null });

async function initializeAuth() {
  const authClient = await AuthClient.create();
  const identity = await authClient.getIdentity();

  if (identity) {
    set({ identity });
  }
}

const authStore = {
  subscribe,
  set,
  initialize: initializeAuth,
  login: async () => {
    const authClient = await AuthClient.create();
    const identityProviderUrl = import.meta.env.VITE_AUTH_PROVIDER_URL;

    await authClient.login({
      maxTimeToLive: BigInt(7 * 24 * 60 * 60 * 1000 * 1000 * 1000),
      onSuccess: async () => {
        const identity = await authClient.getIdentity();
        set({ identity });
      },
      identityProvider: identityProviderUrl,
    });
  },
  logout: async () => {
    set({ identity: null });
  },
};

const isAuthenticated = derived(
  authStore,
  ($authStore) => $authStore.identity !== null
);

const principalId = derived(authStore, ($authStore) =>
  $authStore.identity?.getPrincipal().toString()
);

export { authStore, isAuthenticated, principalId };
