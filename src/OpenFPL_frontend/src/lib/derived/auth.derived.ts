import { authStore } from "$lib/stores/auth-store";
import { derived, type Readable } from "svelte/store";
export const authSignedInStore: Readable<boolean> = derived(
  authStore,
  ({ identity }) => identity !== null && identity !== undefined,
);
export const authNotSignedInStore: Readable<boolean> = derived(
  authSignedInStore,
  ($authSignedInStore) => !$authSignedInStore,
);
