import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { DataCache,Fixture } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createFixtureStore() {
  const { subscribe, set } = writable<Fixture[]>([]);

  const actor = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    
    let category = "fixtures";
    const newHashValues: DataCache[] = await actor.getDataHashes() as DataCache[];
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);

    if (liveHash?.hash != localHash) {
      let updatedFixturesData = await actor.getFixtures() as Fixture[];
      localStorage.setItem(
        "fixtures_data",
        JSON.stringify(updatedFixturesData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
      set(updatedFixturesData);
    } else {
      const cachedFixturesData = localStorage.getItem("fixtures_data");
      let cachedFixtures: Fixture[] = [];
      try {
        cachedFixtures = JSON.parse(cachedFixturesData || "[]");
      } catch (e) {
        cachedFixtures = [];
      }
      set(cachedFixtures);
    }
  }

  async function getNextFixture(): Promise<Fixture | undefined> {
    let fixtures: Fixture[] = [];
    subscribe((value) => {
      fixtures = value;
    })();
    const now = new Date();
    return fixtures.find(
      (fixture) => new Date(Number(fixture.kickOff) / 1000000) > now
    );
  }

  return {
    subscribe,
    sync,
    getNextFixture,
  };
}

export const fixtureStore = createFixtureStore();
