import { writable } from "svelte/store";
import type { FootballLeagueDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createLeagueStore() {
  const { subscribe, set } = writable<FootballLeagueDTO[]>([]);

  return {
    subscribe,
    setLeagues: (leagues: FootballLeagueDTO[]) => set(leagues),
  };
}

export const leagueStore = createLeagueStore();
