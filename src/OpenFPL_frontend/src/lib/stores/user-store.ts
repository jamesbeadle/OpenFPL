import { authStore } from "$lib/stores/auth.store";
import { isError, replacer } from "$lib/utils/Helpers";
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
        profileData.profilePicture = base64ToUint8Array(
          profileData.profilePicture
        );
      }
      return profileData;
    }
    return null;
  }

  async function sync() {
    const localProfile = localStorage.getItem("user_profile_data");
    if (localProfile) {
      let localStorageProfile = getProfileFromLocalStorage();
      set(localStorageProfile);
      return;
    }

    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let getProfileResponse = await identityActor.getProfile();
      let error = isError(getProfileResponse);
      if (error) {
        if (getProfileResponse.err.NotFound !== undefined) {
          return;
        } else {
          console.error("Error syncing user store");
        }
        return;
      }

      let profileData = getProfileResponse.ok;

      if (profileData && profileData.profilePicture instanceof Uint8Array) {
        const base64Picture = uint8ArrayToBase64(profileData.profilePicture);
        localStorage.setItem(
          "user_profile_data",
          JSON.stringify(
            {
              ...profileData,
              profilePicture: base64Picture,
            },
            replacer
          )
        );
      } else {
        localStorage.setItem(
          "user_profile_data",
          JSON.stringify(profileData, replacer)
        );
      }

      set(profileData);
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
      if (isError(result)) {
        console.error("Error creating profile");
        return;
      }
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
      const result = await identityActor.updateUsername(username);
      if (isError(result)) {
        console.error("Error updating username");
        return;
      }
      await cacheProfile();
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
      const result = await identityActor.updateFavouriteTeam(favouriteTeamId);
      if (isError(result)) {
        console.error("Error updating favourite team");
        return;
      }
      await cacheProfile();
      return result;
    } catch (error) {
      console.error("Error updating favourite team:", error);
      throw error;
    }
  }

  async function getProfile(): Promise<any> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.getProfile();
      if (isError(result)) {
        console.error("Error fetching profile");
        return;
      }
      let profile = result.ok;
      set(profile);
      return profile;
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

          if (isError(result)) {
            console.error("Error updating profile picture");
            return;
          }

          await cacheProfile();
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

  async function isUsernameAvailable(username: string): Promise<boolean> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    return await identityActor.isUsernameValid(username);
  }

  async function cacheProfile() {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );

    let getProfileResponse = await identityActor.getProfile();
    let error = isError(getProfileResponse);
    if (error) {
      console.error("Error fetching user profile");
      return;
    }

    let profileData = getProfileResponse.ok;

    if (profileData && profileData.profilePicture instanceof Uint8Array) {
      const base64Picture = uint8ArrayToBase64(profileData.profilePicture);
      localStorage.setItem(
        "user_profile_data",
        JSON.stringify(
          {
            ...profileData,
            profilePicture: base64Picture,
          },
          replacer
        )
      );
    } else {
      localStorage.setItem(
        "user_profile_data",
        JSON.stringify(profileData, replacer)
      );
    }

    set(profileData);
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
    isUsernameAvailable,
  };
}

export const userStore = createUserStore();
