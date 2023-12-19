import { fixtureStore } from "$lib/stores/fixture-store";
import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import type {
  DataCache,
  Fixture,
  SystemState,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { idlFactory } from "../../../../declarations/player_canister";
import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createPlayerStore() {
  const { subscribe, set } = writable<PlayerDTO[]>([]);

  let systemState: SystemState;
  systemStore.subscribe((value) => {
    systemState = value as SystemState;
  });

  let allFixtures: Fixture[];
  fixtureStore.subscribe((value) => (allFixtures = value));

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.PLAYER_CANISTER_CANISTER_ID
  );

  async function sync() {
    let category = "players";
    const newHashValues: DataCache[] = await actor.getDataHashes();
    let livePlayersHash =
      newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);

    if (livePlayersHash?.hash != localHash) {
      let updatedPlayersData = await actor.getPlayers();
      localStorage.setItem(
        "players_data",
        JSON.stringify(updatedPlayersData, replacer)
      );
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
      set(updatedPlayersData);
    } else {
      const cachedPlayersData = localStorage.getItem("players_data");
      let cachedPlayers: PlayerDTO[] = [];
      try {
        cachedPlayers = JSON.parse(cachedPlayersData || "[]");
      } catch (e) {
        cachedPlayers = [];
      }
      set(cachedPlayers);
    }
  }

  return {
    subscribe,
    sync,
  };
}

export const playerStore = createPlayerStore();
