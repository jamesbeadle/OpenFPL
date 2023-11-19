import { idlFactory } from "../../../../declarations/player_canister";
import type { Player, PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../../utils/Helpers";

export class PlayerService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.PLAYER_CANISTER_CANISTER_ID
    );
  }

  async getPlayerData(playersHash: string): Promise<PlayerDTO[]> {
    const cachedHash = localStorage.getItem("players_hash");
    const cachedPlayersData = localStorage.getItem("players_data");

    let cachedPlayers: PlayerDTO[];
    try {
      cachedPlayers = JSON.parse(cachedPlayersData || "[]");
    } catch (e) {
      cachedPlayers = [];
    }

    if (
      !playersHash ||
      playersHash.length === 0 ||
      cachedHash !== playersHash
    ) {
      return this.fetchAllPlayers(playersHash);
    } else {
      return cachedPlayers;
    }
  }

  private async fetchAllPlayers(playersHash: string) {
    try {
      const allPlayersData = await this.actor.getAllPlayers();
      localStorage.setItem("players_hash", playersHash);
      localStorage.setItem("players_data",
        JSON.stringify(allPlayersData, replacer));
      return allPlayersData;
    } catch (error) {
      console.error("Error fetching all players:", error);
      throw error;
    }
  }
}
