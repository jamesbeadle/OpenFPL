import { authStore } from "$lib/stores/auth.store";
import { derived, type Readable } from "svelte/store";

/*LOCALDEVONLY
const adminPrincipal =
  "opyzn-r7zln-jwgvb-tx75c-ncekh-xhvje-epcj7-saonq-z732m-zi4mm-qae";
*/

const adminPrincipal =
  "vwign-z3gbe-23ozx-3lejk-kseg2-rr5h7-vdkyx-oorzu-mgmrg-yjhir-kqe";
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
