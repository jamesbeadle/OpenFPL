import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataHashDTO,
  SeasonDTO,
  SeasonId,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/helpers";

function createSeasonStore() {
  const { subscribe, set } = writable<SeasonDTO[]>([]);
  console.log('Creating actor in season store line 14');
  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  async function sync() {
    const category = "seasons";
    console.log('Actor getting data hashes in season store sync line 21');
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing season store");
      return;
    }

    let dataCacheValues: DataHashDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataHashDTO) => x.category === category) ?? null;

    const localHash = localStorage.getItem(`${category}_hash`);
    if (categoryHash?.hash != localHash) {
      console.log('Actor getting season line 38');
      const result = await actor.getSeasons(1);

      if (isError(result)) {
        console.error("error syncing seasons store");
        return;
      }

      let updatedFSeasonsData = result.ok;
      localStorage.setItem(
        category,
        JSON.stringify(updatedFSeasonsData, replacer),
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedFSeasonsData);
    } else {
      const cachedSeasonsData = localStorage.getItem(category);
      let cachedSeasons: SeasonDTO[] = [];
      try {
        cachedSeasons = JSON.parse(cachedSeasonsData || "[]");
      } catch (e) {
        cachedSeasons = [];
      }
      set(cachedSeasons);
    }
  }

  async function getSeasonName(seasonId: SeasonId): Promise<string> {
    let seasonName = "";
    subscribe((seasons) => {
      let season = seasons.find((x) => x.id == seasonId);
      seasonName = season ? season.name : "";
    });
    return seasonName;
  }

  return {
    subscribe,
    sync,
    getSeasonName,
  };
}

export const seasonStore = createSeasonStore();
