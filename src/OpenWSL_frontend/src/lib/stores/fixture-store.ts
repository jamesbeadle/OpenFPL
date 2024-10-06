import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataHashDTO,
  FixtureDTO,
  RequestFixturesDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/helpers";

function createFixtureStore() {
  const { subscribe, set } = writable<FixtureDTO[]>([]);

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENWSL_BACKEND_CANISTER_ID ?? "",
  );

  async function sync(seasonId: number) {
    const category = "fixtures";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing fixture store");
      return;
    }

    let dataCacheValues: DataHashDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataHashDTO) => x.category === category) ?? null;

    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      let dto: RequestFixturesDTO = {
        seasonId: seasonId,
      };
      console.log("here");
      console.log(dto);
      const result = await actor.getFixtures(dto);
      console.log(result);

      if (isError(result)) {
        console.error("error syncing fixture store");
        return;
      }

      let updatedFixturesData = result.ok;
      localStorage.setItem(
        category,
        JSON.stringify(updatedFixturesData, replacer),
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedFixturesData);
    } else {
      const cachedFixturesData = localStorage.getItem(category);
      let cachedFixtures: FixtureDTO[] = [];
      try {
        cachedFixtures = JSON.parse(cachedFixturesData || "[]");
      } catch (e) {
        cachedFixtures = [];
      }
      set(cachedFixtures);
    }
  }

  async function getNextFixture(): Promise<FixtureDTO | undefined> {
    let fixtures: FixtureDTO[] = [];
    await subscribe((value) => {
      fixtures = value;
    })();

    if (fixtures.length == 0) {
      return;
    }
    const now = new Date();
    return fixtures.find(
      (fixture) => new Date(Number(fixture.kickOff) / 1000000) > now,
    );
  }

  async function getPostponedFixtures(): Promise<FixtureDTO[]> {
    try {
      let result = await actor.getPostponedFixtures();

      if (isError(result)) {
        console.error("Error getting postponed fixtures");
      }

      let fixtures = result.ok;
      return fixtures;
    } catch (error) {
      console.error("Error getting postponed fixtures:", error);
      throw error;
    }
  }

  return {
    subscribe,
    sync,
    getNextFixture,
    getPostponedFixtures,
  };
}

export const fixtureStore = createFixtureStore();
