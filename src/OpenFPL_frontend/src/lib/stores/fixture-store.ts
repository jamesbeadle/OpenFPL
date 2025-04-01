import { writable } from "svelte/store";
import { FixtureService } from "$lib/services/fixture-service";
import type { Fixture } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createFixtureStore() {
  const { subscribe, set } = writable<Fixture[]>([]);

  async function getPostponedFixtures(): Promise<Fixture[] | undefined> {
    return new FixtureService().getPostponedFixtures();
  }

  async function getNextFixture(): Promise<Fixture | undefined> {
    let fixtures: Fixture[] = [];
    await subscribe((value) => {
      fixtures = value;
    })();

    if (fixtures.length == 0) {
      return;
    }

    fixtures.sort((a, b) => {
      return (
        new Date(Number(a.kickOff) / 1000000).getTime() -
        new Date(Number(b.kickOff) / 1000000).getTime()
      );
    });

    const now = new Date();
    return fixtures.find(
      (fixture) => new Date(Number(fixture.kickOff) / 1000000) > now,
    );
  }

  return {
    subscribe,
    setFixtures: (fixtures: Fixture[]) => set(fixtures),
    getNextFixture,
    getPostponedFixtures,
  };
}

export const fixtureStore = createFixtureStore();
