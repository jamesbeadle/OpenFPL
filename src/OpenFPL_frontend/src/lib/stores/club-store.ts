import { writable } from "svelte/store";
import type { Club } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createClubStore() {
  const { subscribe, set } = writable<Club[]>([]);

  return {
    subscribe,
    setClubs: (clubs: Club[]) =>
      set(clubs.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))),
  };
}

export const clubStore = createClubStore();
