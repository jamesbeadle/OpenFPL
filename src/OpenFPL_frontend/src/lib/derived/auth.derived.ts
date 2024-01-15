import { authStore } from "$lib/stores/auth.store";
import { derived, type Readable } from "svelte/store";

/*LOCALDEVONLY
const adminPrincipal =
  "opyzn-r7zln-jwgvb-tx75c-ncekh-xhvje-epcj7-saonq-z732m-zi4mm-qae";
*/

const adminPrincipal =
  "mb4l5-fry7f-anf7l-2jike-yd7r6-3qf3q-jorvy-o2yfj-x4s3f-xrvfr-eae";
export const authSignedInStore: Readable<boolean> = derived(
  authStore,
  ({ identity }) => identity !== null && identity !== undefined
);

export const authIsAdmin: Readable<boolean> = derived(
  authStore,
  ({ identity }) =>
    identity !== null &&
    identity !== undefined &&
    identity.getPrincipal().toString() === adminPrincipal
);
