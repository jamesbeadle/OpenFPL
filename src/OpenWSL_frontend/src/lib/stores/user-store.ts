import { authStore } from "$lib/stores/auth.store";
import { isError } from "$lib/utils/helpers";
import { writable } from "svelte/store";
import { Text } from "@dfinity/candid/lib/cjs/idl";
import { ActorFactory } from "../../utils/ActorFactory";
import { createAgent } from "@dfinity/utils";
import { IcrcLedgerCanister } from "@dfinity/ledger-icrc";
import { Principal } from "@dfinity/principal";
import type { OptionIdentity } from "$lib/types/identity";
import type {
  UpdateFavouriteClubDTO,
  UpdateProfilePictureDTO,
  UsernameFilterDTO,
} from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";

function createUserStore() {
  const { subscribe, set } = writable<any>(null);

  async function sync() {
    let localStorageString = localStorage.getItem("user_profile_data");
    if (localStorageString) {
      const localProfile = JSON.parse(localStorageString);
      set(localProfile);
      return;
    }
    try {
      await cacheProfile();
    } catch (error) {
      console.error("Error fetching user profile:", error);
      throw error;
    }
  }

  async function updateUsername(username: string): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENWSL_BACKEND_CANISTER_ID ?? "",
      );

      let dto: UsernameFilterDTO = {
        username: username,
      };
      const result = await identityActor.updateUsername(dto);
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
        process.env.OPENWSL_BACKEND_CANISTER_ID ?? "",
      );
      let dto: UpdateFavouriteClubDTO = {
        favouriteClubId: favouriteTeamId,
      };
      const result = await identityActor.updateFavouriteClub(dto);
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

  async function updateProfilePicture(picture: File): Promise<any> {
    try {
      const maxPictureSize = 1000;
      const extension = getFileExtensionFromFile(picture);

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
            process.env.OPENWSL_BACKEND_CANISTER_ID ?? "",
          );

          let dto: UpdateProfilePictureDTO = {
            profilePicture: uint8Array,
            extension: extension,
          };
          const result = await identityActor.updateProfilePicture(dto);
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

  function getFileExtensionFromFile(file: File): string {
    // Use the name property of the File object to get the filename
    const filename = file.name;

    // Extract the extension
    const lastIndex = filename.lastIndexOf(".");

    // Return the extension, ensuring it doesn't return -1 for files without an extension
    return lastIndex !== -1 ? filename.substring(lastIndex + 1) : "";
  }

  async function isUsernameAvailable(username: string): Promise<boolean> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENWSL_BACKEND_CANISTER_ID ?? "",
    );
    let dto: UsernameFilterDTO = {
      username: username,
    };
    return await identityActor.isUsernameValid(dto);
  }

  async function cacheProfile() {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENWSL_BACKEND_CANISTER_ID ?? "",
    );
    let getProfileResponse = await identityActor.getProfile();
    let error = isError(getProfileResponse);
    if (error) {
      console.error("Error fetching user profile");
      return;
    }

    let profileData = getProfileResponse.ok;

    set(profileData);
  }

  async function withdrawFPL(
    withdrawalAddress: string,
    withdrawalAmount: bigint,
  ): Promise<any> {
    try {
      let identity: OptionIdentity;

      authStore.subscribe(async (auth) => {
        identity = auth.identity;
      });

      if (!identity) {
        return;
      }

      let principalId = identity.getPrincipal();

      const agent = await createAgent({
        identity: identity,
        host: import.meta.env.VITE_AUTH_PROVIDER_URL,
        fetchRootKey: process.env.DFX_NETWORK === "local",
      });

      const { transfer } = IcrcLedgerCanister.create({
        agent,
        canisterId:
          process.env.DFX_NETWORK === "ic"
            ? Principal.fromText("ddsp7-7iaaa-aaaaq-aacqq-cai")
            : Principal.fromText("avqkn-guaaa-aaaaa-qaaea-cai"),
      });

      if (principalId) {
        try {
          let transfer_result = await transfer({
            to: {
              owner: Principal.fromText(withdrawalAddress),
              subaccount: [],
            },
            fee: 100_000n,
            memo: new Uint8Array(Text.encodeValue("0")),
            from_subaccount: undefined,
            created_at_time: BigInt(Date.now()) * BigInt(1_000_000),
            amount: withdrawalAmount - 100_000n,
          });
        } catch (err: any) {
          console.error(err.errorType);
        }
      }
    } catch (error) {
      console.error("Error withdrawing FPL.", error);
      throw error;
    }
  }

  async function getFPLBalance(): Promise<bigint> {
    let identity: OptionIdentity;

    authStore.subscribe(async (auth) => {
      identity = auth.identity;
    });

    if (!identity) {
      return 0n;
    }

    let principalId = identity.getPrincipal();

    const agent = await createAgent({
      identity: identity,
      host: import.meta.env.VITE_AUTH_PROVIDER_URL,
      fetchRootKey: process.env.DFX_NETWORK === "local",
    });

    const { balance } = IcrcLedgerCanister.create({
      agent,
      canisterId:
        process.env.DFX_NETWORK === "ic"
          ? Principal.fromText("ddsp7-7iaaa-aaaaq-aacqq-cai")
          : Principal.fromText("avqkn-guaaa-aaaaa-qaaea-cai"),
    });

    if (principalId) {
      try {
        let result = await balance({
          owner: principalId,
          certified: false,
        });
        return result;
      } catch (err: any) {
        console.error(err);
      }
    }

    return 0n;
  }

  return {
    subscribe,
    sync,
    updateUsername,
    updateFavouriteTeam,
    updateProfilePicture,
    isUsernameAvailable,
    cacheProfile,
    withdrawFPL,
    getFPLBalance,
  };
}

export const userStore = createUserStore();
