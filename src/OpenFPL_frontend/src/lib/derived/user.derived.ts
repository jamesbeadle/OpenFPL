import { userStore } from "$lib/stores/user-store";
import { uint8ArrayToBase64 } from "$lib/utils/Helpers";
import { derived, type Readable } from "svelte/store";

export const userGetProfilePicture: Readable<string> = derived(
  userStore,
  ($user) => {
    console.log("getting derived profile picture")
    console.log($user)

    let byteArray;
    if ($user && $user.profilePicture) {
      console.log("Found user profile picture:")
      console.log($user.profilePicture)
      let base64Picture = "/profile_placeholder.png";
      if (
        Array.isArray($user.profilePicture) &&
        $user.profilePicture[0] instanceof Uint8Array
      ) {
        console.log("picture is array:")
        byteArray = $user.profilePicture[0];
        base64Picture = `data:[<mediatype>];base64, ${uint8ArrayToBase64(byteArray)}`;
   
        console.log(base64Picture)
      } else if ($user.profilePicture instanceof Uint8Array) {
        console.log("picture is of instance array:")
        base64Picture = uint8ArrayToBase64($user.profilePicture);
      } else {
        console.log("picture is not array:")
        if (typeof $user.profilePicture === "string") {
          if ($user.profilePicture.startsWith("data:image")) {
            console.log("picture is not string with data:")
            base64Picture = $user.profilePicture;
          }
          else{
            base64Picture = `data:[<mediatype>];base64, ${$user.profilePicture}`;
          }
        }
      }
      
      return base64Picture;
    } 
    console.log("default")
    console.log("/profile_placeholder.png")
    return "/profile_placeholder.png";
  }
);

export const userGetFavouriteTeam: Readable<number> = derived(
  userStore,
  (user) => (user !== null && user !== undefined ? user.favouriteTeamId : 0)
);
