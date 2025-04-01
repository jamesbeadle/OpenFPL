import { writable } from "svelte/store";
import { PlayerService } from "$lib/services/player-service";
import type { GetPlayers, Player } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createPlayerStore() {
  const { subscribe, set } = writable<Player[]>([]);

  async function getSnapshotPlayers(
    dto: GetPlayers,
  ): Promise<Player[]> {
    return new PlayerService().getPlayers(dto);
  }

  return {
    subscribe,
    setPlayers: (players: Player[]) => set(players),
    getSnapshotPlayers,
  };
}

export const playerStore = createPlayerStore();
