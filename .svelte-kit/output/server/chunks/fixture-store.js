import { w as writable } from "./index.js";
import "@dfinity/agent";
import { A as ActorFactory, i as idlFactory, r as replacer } from "./team-store.js";
function createFixtureStore() {
  const { subscribe, set } = writable([]);
  const actor = ActorFactory.createActor(
    idlFactory,
    { "OPENFPL_BACKEND_CANISTER_ID": "bkyz2-fmaaa-aaaaa-qaaaq-cai", "OPENFPL_FRONTEND_CANISTER_ID": "bd3sg-teaaa-aaaaa-qaaba-cai", "__CANDID_UI_CANISTER_ID": "bw4dl-smaaa-aaaaa-qaacq-cai", "PLAYER_CANISTER_CANISTER_ID": "be2us-64aaa-aaaaa-qaabq-cai", "TOKEN_CANISTER_CANISTER_ID": "br5f7-7uaaa-aaaaa-qaaca-cai", "DFX_NETWORK": "local" }.OPENFPL_BACKEND_CANISTER_ID
  );
  async function sync() {
    let category = "fixtures";
    const newHashValues = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedFixturesData = await actor.getFixtures();
      localStorage.setItem(
        "fixtures_data",
        JSON.stringify(updatedFixturesData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
      set(updatedFixturesData);
    } else {
      const cachedFixturesData = localStorage.getItem("fixtures_data");
      let cachedFixtures = [];
      try {
        cachedFixtures = JSON.parse(cachedFixturesData || "[]");
      } catch (e) {
        cachedFixtures = [];
      }
      set(cachedFixtures);
    }
  }
  async function getNextFixture() {
    let fixtures = [];
    await sync();
    await subscribe((value) => {
      fixtures = value;
    })();
    const now = /* @__PURE__ */ new Date();
    return fixtures.find(
      (fixture) => new Date(Number(fixture.kickOff) / 1e6) > now
    );
  }
  return {
    subscribe,
    sync,
    getNextFixture
  };
}
const fixtureStore = createFixtureStore();
export {
  fixtureStore as f
};
