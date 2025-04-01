import { writable } from "svelte/store";
import { PlayerService } from "$lib/services/player-service";
import type {
  GetPlayers,
  GetPlayersSnapshot,
  Player,
  PlayersSnapshot,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createPlayerStore() {
  const { subscribe, set } = writable<Player[]>([]);

  async function getSnapshotPlayers(
    dto: GetPlayersSnapshot,
  ): Promise<PlayersSnapshot | undefined> {
    return new PlayerService().getSnapshotPlayers(dto);
  }

  return {
    subscribe,
    setPlayers: (players: Player[]) => set(players),
    getSnapshotPlayers,
  };
}

export const playerStore = createPlayerStore();
