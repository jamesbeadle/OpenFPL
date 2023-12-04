import { authStore } from "$lib/stores/auth.store";
import { replacer } from "$lib/utils/Helpers";
import { writable } from "svelte/store";
import type { ProfileDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createUserStore() {
  const { subscribe, set } = writable<any>(null);

  function uint8ArrayToBase64(bytes: Uint8Array): string {
    const binary = Array.from(bytes)
      .map((byte) => String.fromCharCode(byte))
      .join("");
    return btoa(binary);
  }

  function base64ToUint8Array(base64: string): Uint8Array {
    const binary_string = atob(base64);
    const len = binary_string.length;
    const bytes = new Uint8Array(len);
    for (let i = 0; i < len; i++) {
      bytes[i] = binary_string.charCodeAt(i);
    }
    return bytes;
  }

  function getProfileFromLocalStorage(): ProfileDTO | null {
    const storedData = localStorage.getItem("user_profile_data");
    if (storedData) {
      const profileData: ProfileDTO = JSON.parse(storedData);
      if (profileData && typeof profileData.profilePicture === "string") {
        // Decode the Base64 string back to a Uint8Array
        profileData.profilePicture = base64ToUint8Array(
          profileData.profilePicture
        );
      }
      return profileData;
    }
    return null;
  }

  async function sync() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let updatedProfileDataObj = (await identityActor.getProfileDTO()) as any;

      if (!updatedProfileDataObj) {
        await identityActor.createProfile();
        updatedProfileDataObj = (await identityActor.getProfileDTO()) as any;
      }
      let updatedProfileData = updatedProfileDataObj[0];
      if (
        updatedProfileData &&
        updatedProfileData.profilePicture instanceof Uint8Array
      ) {
        const base64Picture = uint8ArrayToBase64(
          updatedProfileData.profilePicture
        );
        localStorage.setItem(
          "user_profile_data",
          JSON.stringify(
            {
              ...updatedProfileData,
              profilePicture: base64Picture,
            },
            replacer
          )
        );
      } else {
        localStorage.setItem(
          "user_profile_data",
          JSON.stringify(updatedProfileData, replacer)
        );
      }
      set(updatedProfileData);
    } catch (error) {
      console.error("Error fetching user profile:", error);
      throw error;
    }
  }

  async function createProfile(): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.createProfile();
      return result;
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }

  async function updateUsername(username: string): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.updateDisplayName(username);
      sync();
      return result;
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }

  async function updateFavouriteTeam(favouriteTeamId: number): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      sync();
      const result = await identityActor.updateFavouriteTeam(favouriteTeamId);
      return result;
    } catch (error) {
      console.error("Error updating favourite team:", error);
      throw error;
    }
  }

  async function getProfile(): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.getProfileDTO();
      set(result);
      return result;
    } catch (error) {
      console.error("Error getting profile:", error);
      throw error;
    }
  }

  async function updateProfilePicture(picture: File): Promise<any> {
    try {
      const maxPictureSize = 1000;

      if (picture.size > maxPictureSize * 1024) {
        return null;
      }
      const reader = new FileReader();
      reader.readAsArrayBuffer(picture);
      reader.onloadend = async () => {
        const arrayBuffer = reader.result as ArrayBuffer;
        const uint8Array = new Uint8Array(arrayBuffer);
        try {
          const identityActor = await ActorFactory.createIdentityActor(
            authStore,
            process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
          );
          const result = await identityActor.updateProfilePicture(uint8Array);
          sync();
          return result;
        } catch (error) {
          console.error(error);
        }
      };
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }

  return {
    subscribe,
    sync,
    updateUsername,
    updateFavouriteTeam,
    getProfile,
    updateProfilePicture,
    createProfile,
    getProfileFromLocalStorage,
  };
}

export const userStore = createUserStore();
