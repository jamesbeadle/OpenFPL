import { writable } from 'svelte/store';
import type { Fixture, DataCache } from 'path-to-your-types';
import { authStore } from '$lib/stores/auth';
import type { OptionIdentity } from '$lib/types/Identity';
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createFixtureStore() {
  const { subscribe, set } = writable<Fixture[]>([]);

  let actor: any;

  async function actorFromIdentity() {
    const identity = await new Promise<OptionIdentity>((resolve, reject) => {
      const unsubscribe = authStore.subscribe((store) => {
        if (store.identity) {
          unsubscribe();
          resolve(store.identity);
        }
      });
    });

    return ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
      identity
    );
  }

  async function updateFixturesData() {
    if (!actor) actor = await actorFromIdentity();

    let category = "fixtures";
    const newHashValues: DataCache[] = await actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);

    if (liveHash?.hash != localHash) {
      let updatedFixturesData = await actor.getFixtures();
      localStorage.setItem("fixtures_data", JSON.stringify(updatedFixturesData, replacer));
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
    subscribe(value => { fixtures = value })();
    const now = new Date();
    return fixtures.find(
      (fixture) => new Date(Number(fixture.kickOff) / 1000000) > now
    );
  }

  return {
    subscribe,
    updateFixturesData,
    getNextFixture
  };
}

export const fixtureStore = createFixtureStore();
