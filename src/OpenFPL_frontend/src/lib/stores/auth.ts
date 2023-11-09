import { writable } from 'svelte/store';
import { AuthClient } from "@dfinity/auth-client";

interface AuthState {
  isAuthenticated: boolean;
  identity: any;
  principalId: string;
}

const createAuthStore = () => {
  const { subscribe, set } = writable<AuthState>({ isAuthenticated: false, identity: null, principalId: '' });

  return {
    subscribe,
    set,
    login: async () => {
        const authClient = await AuthClient.create();
        await authClient.login({
            maxTimeToLive: BigInt(7 * 24 * 60 * 60 * 1000 * 1000 * 1000),
            onSuccess: async () => {
            const identity = await authClient.getIdentity();
            const principalId = identity.getPrincipal().toString();
            set({ isAuthenticated: true, identity, principalId  });
            },
        });
    },
    logout: async () => {
        set({ isAuthenticated: false, identity: null, principalId: ''});
    }
  };
};

export const authStore = createAuthStore();
