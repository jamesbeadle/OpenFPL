import { authStore } from "$lib/stores/auth.store";
import { derived, type Readable } from "svelte/store";

/*LOCALDEVONLY
const adminPrincipal =
  "opyzn-r7zln-jwgvb-tx75c-ncekh-xhvje-epcj7-saonq-z732m-zi4mm-qae";
*/

const adminPrincipal =
  "4khjk-mso55-d5gd6-pudbp-627pj-ztvnn-ntn3p-vvujc-2x5dr-kv32c-2ae";
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
