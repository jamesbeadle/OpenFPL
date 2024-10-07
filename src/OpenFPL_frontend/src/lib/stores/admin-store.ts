import { isError } from "$lib/utils/helpers";
import { 
    type FantasyTeamSnapshotDTO,
    type CanisterDTO,
    type CanisterInfoDTO,
    type CanisterType,
    type UpdateRewardPoolsDTO,
    type UpdateSystemStatusDTO,
    type StaticCanistersDTO
 } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
 import { idlFactory } from "../../../../declarations/OpenFPL_backend";
 import { ActorFactory } from "../../utils/ActorFactory";

// function createAdminStore(){

//     async function sync(){

//     }

// }
// export const adminStore = createAdminStore();

import {derived, writable, type Readable } from 'svelte/store';

// Writable store for managing an array of canisters
export const adminStore = writable<CanisterDTO[] | undefined>(undefined);

// Derived store for a specific canister, such as the first canister in the list
export const firstCanisterStore: Readable<CanisterDTO | undefined> = derived(
  adminStore,
  ($adminStore) => $adminStore?.[0]  // Derive the first canister from the list
);
