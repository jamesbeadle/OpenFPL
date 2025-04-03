import { writable } from "svelte/store";
import type {
  Club,
  Clubs,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ClubService } from "../services/club-service";

function createClubStore() {
  const { subscribe, set } = writable<Club[]>([]);

  async function getClubs(): Promise<Clubs | undefined> {
    return new ClubService().getClubs();
  }

  return {
    subscribe,
    setClubs: (clubs: Club[]) =>
      set(clubs.sort((a, b) => a.friendlyName.localeCompare(b.friendlyName))),
  };
}

export const clubStore = createClubStore();
