import { f as fixtureStore } from "./fixture-store.js";
import { s as systemStore, A as ActorFactory, b as idlFactory, r as replacer } from "./team-store.js";
import { w as writable } from "./index.js";
import "@dfinity/agent";
function createPlayerStore() {
  const { subscribe, set } = writable([]);
  systemStore.subscribe((value) => {
  });
  fixtureStore.subscribe((value) => value);
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bboqb-jiaaa-aaaal-qb6ea-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bgpwv-eqaaa-aaaal-qb6eq-cai", "PLAYER_CANISTER_CANISTER_ID": "pec6o-uqaaa-aaaal-qb7eq-cai", "TOKEN_CANISTER_CANISTER_ID": "hwd4h-eyaaa-aaaal-qb6ra-cai", "DFX_NETWORK": "ic" }.PLAYER_CANISTER_CANISTER_ID
  );
  async function sync() {
    let category = "players";
    const newHashValues = await actor.getDataHashes();
    let livePlayersHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (livePlayersHash?.hash != localHash) {
      let updatedPlayersData = await actor.getAllPlayers();
      localStorage.setItem(
        "players_data",
        JSON.stringify(updatedPlayersData, replacer)
      );
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
      set(updatedPlayersData);
    } else {
      const cachedPlayersData = localStorage.getItem("players_data");
      let cachedPlayers = [];
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
    sync
  };
}
const playerStore = createPlayerStore();
export {
  playerStore as p
};
