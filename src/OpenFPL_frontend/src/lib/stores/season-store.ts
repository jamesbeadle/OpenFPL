import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { Season } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createSeasonStore() {
  const { subscribe, set } = writable<Season[]>([]);

  const actor = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    const updatedSeasonsData = await actor.getSeasons() as Season[];
    set(updatedSeasonsData);
  }

  return {
    subscribe,
    sync
  };
}

export const seasonStore = createSeasonStore();
