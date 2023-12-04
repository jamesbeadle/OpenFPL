import { userStore } from "$lib/stores/user-store";
import { derived, type Readable } from "svelte/store";

export const userGetProfilePicture: Readable<string> = derived(
  userStore,
  (user) =>
    user !== null && user !== undefined && user.profilePicture.length > 0
      ? URL.createObjectURL(new Blob([new Uint8Array(user.profilePicture)]))
      : "profile_placeholder.png"
);

export const userGetFavouriteTeam: Readable<number> = derived(
  userStore,
  (user) => (user !== null && user !== undefined ? user.favouriteTeamId : 0)
);
