import { userStore } from "$lib/stores/user-store";
import { uint8ArrayToBase64 } from "$lib/utils/Helpers";
import { derived, type Readable } from "svelte/store";

export const userGetProfilePicture: Readable<string> = derived(
  userStore,
  ($user) => {

    let byteArray;
    if ($user && $user.profilePicture) {
      let base64Picture = "/profile_placeholder.png";
      if (
        Array.isArray($user.profilePicture) &&
        $user.profilePicture[0] instanceof Uint8Array
      ) {
        byteArray = $user.profilePicture[0];
        base64Picture = `data:[<mediatype>];base64, ${uint8ArrayToBase64(byteArray)}`;
   
      } else if ($user.profilePicture instanceof Uint8Array) {
        base64Picture = uint8ArrayToBase64($user.profilePicture);
      } else {
        if (typeof $user.profilePicture === "string") {
          if ($user.profilePicture.startsWith("data:image")) {
            base64Picture = $user.profilePicture;
          }
          else{
            base64Picture = `data:[<mediatype>];base64, ${$user.profilePicture}`;
          }
        }
      }
      
      return base64Picture;
    } 
    return "/profile_placeholder.png";
  }
);

export const userGetFavouriteTeam: Readable<number> = derived(
  userStore,
  (user) => (user !== null && user !== undefined ? user.favouriteTeamId : 0)
);
