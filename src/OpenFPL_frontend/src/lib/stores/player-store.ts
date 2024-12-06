import { writable } from "svelte/store";
import { PlayerService } from "$lib/services/player-service";
import type { PlayerDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createPlayerStore() {
  const { subscribe, set } = writable<PlayerDTO[]>([]);

  async function getLoanedPlayers(clubId: number): Promise<PlayerDTO[]> {
    return new PlayerService().getLoanedPlayers(clubId);
  }

  async function getRetiredPlayers(clubId: number): Promise<PlayerDTO[]> {
    return new PlayerService().getRetiredPlayers(clubId);
  }

  return {
    subscribe,
    setPlayers: (players: PlayerDTO[]) => set(players),
    getLoanedPlayers,
    getRetiredPlayers,
  };
}

export const playerStore = createPlayerStore();
