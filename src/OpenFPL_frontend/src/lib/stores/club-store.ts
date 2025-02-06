import { writable } from "svelte/store";
import type { ClubDTO } from "../../../../external_declarations/data_canister/data_canister.did";

function createClubStore() {
  const { subscribe, set } = writable<ClubDTO[]>([]);

  return {
    subscribe,
    setClubs: (clubs: ClubDTO[]) =>
      set(clubs.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))),
  };
}

export const clubStore = createClubStore();
