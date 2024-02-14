import { userStore } from "$lib/stores/user-store";
import { derived, type Readable } from "svelte/store";

export const userGetProfilePicture: Readable<string> = derived(
  userStore,
  ($user) => {
    if (
      $user &&
      $user.profilePicture &&
      typeof $user.profilePicture === "string"
    ) {
      if ($user.profilePicture.startsWith("data:image")) {
        return $user.profilePicture;
      } else {
        return `data:image/jpeg;base64,${$user.profilePicture}`;
      }
    } else {
      return "/profile_placeholder.png";
    }
  }
);

export const userGetFavouriteTeam: Readable<number> = derived(
  userStore,
  (user) => (user !== null && user !== undefined ? user.favouriteTeamId : 0)
);
