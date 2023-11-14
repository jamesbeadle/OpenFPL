import { Actor, HttpAgent } from "@dfinity/agent";
import { idlFactory } from "../../../declarations/OpenFPL_backend";

export class ActorFactory {
  static createActor(options: any = null) {
    const hostOptions = {
      host:
        process.env.DFX_NETWORK === "ic"
          ? `https://${process.env.BACKEND_CANISTER_ID}.ic0.app`
          : "http://127.0.0.1:8080/?canisterId=bw4dl-smaaa-aaaaa-qaacq-cai&id=bkyz2-fmaaa-aaaaa-qaaaq-cai",
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
        console.warn("Unable to fetch root key. Ensure your local replica is running");
        console.error(err);
      });
    }

    return Actor.createActor(idlFactory, {
      agent,
      canisterId: process.env.OPENFPL_BACKEND_CANISTER_ID,
      ...options?.actorOptions,
    });
  }
}
