import { authStore } from "$lib/stores/auth.store";
import { derived, type Readable } from "svelte/store";

const adminPrincipal =
  "nn75s-ayupf-j6mj3-kluyb-wjj7y-eang2-dwzzr-cfdxk-etbw7-cgwnb-lqe";
/*LOCALDEVONLY
const adminPrincipal =
  "opyzn-r7zln-jwgvb-tx75c-ncekh-xhvje-epcj7-saonq-z732m-zi4mm-qae";
*/

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
