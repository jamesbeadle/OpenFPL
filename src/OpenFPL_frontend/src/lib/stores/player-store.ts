import { writable } from "svelte/store";
import { PlayerService } from "$lib/services/player-service";
import type {
  GetSnapshotPlayersDTO,
  PlayerDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createPlayerStore() {
  const { subscribe, set } = writable<PlayerDTO[]>([]);

  async function getSnapshotPlayers(
    dto: GetSnapshotPlayersDTO,
  ): Promise<PlayerDTO[]> {
    return new PlayerService().getSnapshotPlayers(dto);
  }

  return {
    subscribe,
    setPlayers: (players: PlayerDTO[]) => set(players),
    getSnapshotPlayers,
  };
}

export const playerStore = createPlayerStore();
