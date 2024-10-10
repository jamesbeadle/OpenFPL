import { writable } from "svelte/store";
import type { SeasonDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";

function createSeasonStore() {
  const { subscribe, set } = writable<SeasonDTO[]>([]);

  async function getSeasonName(seasonId: number): Promise<string | undefined> {
    let seasons: SeasonDTO[] = [];
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
    setSeasons: (seasons: SeasonDTO[]) => set(seasons),
    getSeasonName,
  };
}

export const seasonStore = createSeasonStore();
