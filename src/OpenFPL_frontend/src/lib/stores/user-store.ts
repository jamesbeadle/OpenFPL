import { authStore } from "$lib/stores/auth-store";
import { isError } from "$lib/utils/helpers";
import { getProfileFromDB, setProfileToDB } from "$lib/utils/db.utils";
import { writable } from "svelte/store";
import { Text } from "@dfinity/candid/lib/cjs/idl";
import { ActorFactory } from "../utils/actor.factory";
import { createAgent } from "@dfinity/utils";
import { IcrcLedgerCanister } from "@dfinity/ledger-icrc";
import { Principal } from "@dfinity/principal";
import type { OptionIdentity } from "$lib/types/identity";
import { UserService } from "$lib/services/user-service";
import type { SetFavouriteClub } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createUserStore() {
  const { subscribe, set } = writable<any>(null);

  async function sync(): Promise<void> {
    try {
      const localProfile = await getProfileFromDB();
      if (localProfile) {
        set(localProfile);
        return;
      }
      await cacheProfile();
    } catch (error) {
      console.error("Error fetching user profile:", error);
      throw error;
    }
  }

  async function updateFavouriteTeam(
    favouriteTeamId: number,
    principalId: string,
  ): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let dto: SetFavouriteClub = {
        principalId,
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

  async function cacheProfile() {
    let profile = await new UserService().getUser();
    set(profile);
    if (profile) {
      await setProfileToDB(profile);
    }
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

  /*
  async function getUserIFCFMembership(): Promise<
    ICFCMembershipDTO | undefined
  > {
    return await new UserService().getUserIFCFMembership();
  }
  */
  return {
    subscribe,
    set,
    sync,
    cacheProfile,
    updateFavouriteTeam,
    withdrawFPL,
    getFPLBalance,
    /* //TODO getUserIFCFMembership, */
  };
}

export const userStore = createUserStore();
