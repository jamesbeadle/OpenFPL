// src/utils/ActorFactory.ts
import type { OptionIdentity } from "$lib/types/Identity";
import { Actor, HttpAgent } from "@dfinity/agent";

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
          ? `https://${canisterId}.ic0.app`
          : "http://127.0.0.1:8080",
      identity: identity,
    };

    console.log("hostOptions")
    console.log(hostOptions)

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
}
