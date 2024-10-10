import { writable } from "svelte/store";
import type { ClubDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createClubStore() {
  const { subscribe, set } = writable<ClubDTO[]>([]);

  return {
    subscribe,
    setClubs: (clubs: ClubDTO[]) => set(clubs),
  };
}

export const clubStore = createClubStore();
