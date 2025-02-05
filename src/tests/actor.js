import { Actor, HttpAgent } from "@dfinity/agent";
import fetch from "isomorphic-fetch";
import canisterIds from ".dfx/local/canister_ids.json";
import { idlFactory } from "../declarations/OpenFPL_backend";

export const createActor = async (canisterId, options) => {
  const agent = new HttpAgent({ ...options?.agentOptions });
  if (process.env.DFX_NETWORK !== "ic") {
    agent.fetchRootKey().catch((err) => {
      console.warn(
        "Unable to fetch root key. Check to ensure that your local replica is running",
      );
      console.error(err);
    });
  }

  return Actor.createActor(idlFactory, {
    agent,
    canisterId,
    ...options?.actorOptions,
  });
};

export const OpenFPL_backendCanister = canisterIds.OpenFPL_backend.local;

export const OpenFPL_backend = await createActor(OpenFPL_backendCanister, {
  agentOptions: {
    host: "http://localhost:8080",
    fetch,
  },
});
