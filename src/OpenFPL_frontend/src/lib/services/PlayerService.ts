
import { ActorFactory } from "../../utils/ActorFactory";
import { idlFactory } from "../../../../declarations/player_canister";

export class PlayerService {
    private actor: any;

    constructor() {
        this.actor = ActorFactory.createActor(idlFactory, process.env.PLAYER_CANISTER_CANISTER_ID);
    }

    async getPlayerData(playerCanisterHash: string) {
      const cachedHash = localStorage.getItem('players_hash');
      const cachedPlayersData = localStorage.getItem('players_data');
      const cachedPlayers = JSON.parse(cachedPlayersData || '[]');
  
      if (!playerCanisterHash || cachedPlayers.length === 0 || cachedHash !== playerCanisterHash) {
        return this.fetchAllPlayers(playerCanisterHash);
      } else {
        return cachedPlayers;
      }
    }
  
    private async fetchAllPlayers(playersHash: string) {
      try {
        const allPlayersData = await this.actor.getAllPlayers();
        localStorage.setItem('players_hash', playersHash);
        localStorage.setItem('players_data', JSON.stringify(allPlayersData));
        return allPlayersData;
      } catch (error) {
        console.error("Error fetching all players:", error);
        throw error;
      }
    }
  }
  