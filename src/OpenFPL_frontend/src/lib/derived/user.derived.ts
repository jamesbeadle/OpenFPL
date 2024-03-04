import { userStore } from "$lib/stores/user-store";
import { uint8ArrayToBase64 } from "$lib/utils/Helpers";
import { derived, type Readable } from "svelte/store";

export const userGetProfilePicture: Readable<string> = derived(
  userStore,
  ($user) => {
    try {
      let byteArray;
      if ($user && $user.profilePicture) {
        if (
          Array.isArray($user.profilePicture) &&
          $user.profilePicture[0] instanceof Uint8Array
        ) {
          byteArray = $user.profilePicture[0];
          return `data:image/${
            $user.profilePictureType
          };base64,${uint8ArrayToBase64(byteArray)}`;
        } else if ($user.profilePicture instanceof Uint8Array) {
          return `data:${$user.profilePictureType};base64,${uint8ArrayToBase64(
            $user.profilePicture
          )}`;
        } else {
          if (typeof $user.profilePicture === "string") {
            if ($user.profilePicture.startsWith("data:image")) {
              return $user.profilePicture;
            } else {
              return `data:${$user.profilePictureType};base64,${$user.profilePicture}`;
            }
          }
        }
      }
      return "/profile_placeholder.png";
    } catch (error) {
      console.error(error);
      return "/profile_placeholder.png";
    }
  }
);

export const userGetFavouriteTeam: Readable<number> = derived(
  userStore,
  (user) => (user !== null && user !== undefined ? user.favouriteTeamId : 0)
);
