import { writable } from "svelte/store";
import type { FixtureDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { FixtureService } from "$lib/services/fixture-service";

function createFixtureStore() {
  const { subscribe, set } = writable<FixtureDTO[]>([]);

  async function getPostponedFixtures(): Promise<FixtureDTO[]> {
    return new FixtureService().getPostponedFixtures();
  }

  async function getNextFixture(): Promise<FixtureDTO | undefined> {
    let fixtures: FixtureDTO[] = [];
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
    setFixtures: (fixtures: FixtureDTO[]) => set(fixtures),
    getNextFixture,
    getPostponedFixtures,
  };
}

export const fixtureStore = createFixtureStore();
