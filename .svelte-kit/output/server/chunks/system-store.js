import { w as writable } from "./index.js";
import "@dfinity/agent";
import { A as ActorFactory, i as idlFactory, r as replacer } from "./team-store.js";
function createSystemStore() {
  const { subscribe, set } = writable(null);
  let actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "system_state";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedSystemStateData = await actor.getSystemState();
      localStorage.setItem(
        "system_state_data",
        JSON.stringify(updatedSystemStateData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
      set(updatedSystemStateData);
    } else {
      const cachedSystemStateData = localStorage.getItem("system_state_data");
      let cachedSystemState = null;
      try {
        cachedSystemState = JSON.parse(cachedSystemStateData || "{}");
      } catch (e) {
        cachedSystemState = null;
      }
      set(cachedSystemState);
    }
  }
  async function getSystemState() {
    let systemState;
    subscribe((value) => {
      systemState = value;
    })();
    return systemState;
  }
  return {
    subscribe,
    sync,
    getSystemState
  };
}
const systemStore = createSystemStore();
export {
  systemStore as s
};
