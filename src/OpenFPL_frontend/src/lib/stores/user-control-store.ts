import type { CreateProfile } from "../../../../declarations/backend/backend.did";
import type { UserId } from "$lib/types/user";
import { initCreatedStore } from "$lib/stores/user-created-store";
import { initUncreatedStore } from "$lib/stores/user-notcreated-store";

export const userIdCreatedStore = initCreatedStore<UserId | string>();

export const userIdUncreatedStore = initUncreatedStore<CreateProfile>();
