import { userStore } from "$lib/stores/user-store";
import { uint8ArrayToBase64 } from "$lib/utils/helpers";
import { derived, type Readable } from "svelte/store";

export const userGetProfilePicture: Readable<string> = derived(
  userStore,
  ($user) => {
    return getProfilePictureString($user.profilePicture);
  },
);

export function getProfilePictureString(profilePicture: any): string {
  try {
    let byteArray;
    if (profilePicture) {
      if (
        Array.isArray(profilePicture) &&
        profilePicture[0] instanceof Uint8Array
      ) {
        byteArray = profilePicture[0];
        return `data:image/${profilePicture};base64,${uint8ArrayToBase64(byteArray)}`;
      } else if (profilePicture instanceof Uint8Array) {
        return `data:${profilePicture};base64,${uint8ArrayToBase64(
          profilePicture,
        )}`;
      } else {
        if (typeof profilePicture === "string") {
          return `data:${profilePicture};base64,${profilePicture}`;
        }
      }
    }
    return "/profile_placeholder.png";
  } catch (error) {
    console.error(error);
    return "/profile_placeholder.png";
  }
}

export const userGetFavouriteTeam: Readable<number> = derived(
  userStore,
  (user) => (user !== null && user !== undefined ? user.favouriteTeamId : 0),
);
