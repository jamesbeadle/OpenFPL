// src/utils/ActorFactory.ts
import type { AuthStore } from "$lib/stores/auth.store";
import type { OptionIdentity } from "$lib/types/identity";
import { Actor, HttpAgent } from "@dfinity/agent";
import type { Unsubscriber } from "svelte/store";
import { idlFactory as canister } from "../../../declarations/OpenFPL_backend";

export class ActorFactory {
  static createActor(
    idlFactory: any,
    canisterId: string = "",
    identity: OptionIdentity = null,
    options: any = null
  ) {
    const hostOptions = {
      host:
        process.env.DFX_NETWORK === "ic"
          ? `https://${canisterId}.icp-api.io`
          : "http://127.0.0.1:8080",
      identity: identity,
    };

    if (!options) {
      options = {
        agentOptions: hostOptions,
      };
    } else if (!options.agentOptions) {
      options.agentOptions = hostOptions;
    } else {
      options.agentOptions.host = hostOptions.host;
    }

    const agent = new HttpAgent({ ...options.agentOptions });

    if (process.env.NODE_ENV !== "production") {
      agent.fetchRootKey().catch((err) => {
        console.warn(
          "Unable to fetch root key. Ensure your local replica is running"
        );
        console.error(err);
      });
    }

    return Actor.createActor(idlFactory, {
      agent,
      canisterId: canisterId,
      ...options?.actorOptions,
    });
  }

  static createIdentityActor(authStore: AuthStore, canisterId: string) {
    let unsubscribe: Unsubscriber;
    return new Promise<OptionIdentity>((resolve, reject) => {
      unsubscribe = authStore.subscribe((store) => {
        if (store.identity) {
          resolve(store.identity);
        }
      });
    }).then((identity) => {
      unsubscribe();
      return ActorFactory.createActor(
        canister,
        canisterId,
        identity
      );
    });
  }
}
