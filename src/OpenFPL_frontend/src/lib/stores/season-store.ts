import { writable } from "svelte/store";
import type { Season } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createSeasonStore() {
  const { subscribe, set } = writable<Season[]>([]);

  async function getSeasonName(seasonId: number): Promise<string | undefined> {
    let seasons: Season[] = [];
    await subscribe((value) => {
      seasons = value;
    })();

    if (seasons.length == 0) {
      return;
    }

    let season = seasons.find((x) => x.id == seasonId);
    if (season == null) {
      return;
    }

    return season.name;
  }

  return {
    subscribe,
    setSeasons: (seasons: Season[]) => set(seasons),
    getSeasonName,
  };
}

export const seasonStore = createSeasonStore();
