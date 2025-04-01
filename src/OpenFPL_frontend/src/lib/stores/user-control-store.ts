import type { UserId } from "$lib/types/user";
import { initCreatedStore } from "./user-created-store";

export const userIdCreatedStore = initCreatedStore<UserId | string>();
