import { writable } from 'svelte/store';
import type { PlayerDTO, PlayerPointsDTO, PlayerDetailDTO } from 'path-to-your-types';
import { idlFactory } from "../../../../declarations/player_canister";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";
import type { GameweekData, FantasyTeam, Fixture } from 'path-to-your-types';
import { SystemService } from './SystemService'; // Adjust the import path as necessary
import { FixtureService } from './FixtureService'; // Adjust the import path as necessary

function createPlayerStore() {
  const { subscribe, set } = writable<PlayerDTO[]>([]);

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.PLAYER_CANISTER_CANISTER_ID
  );

  async function updatePlayersData() {
    let category = "players";
    const newHashValues: DataCache[] = await actor.getDataHashes();
    let livePlayersHash = newHashValues.find(x => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);

    if (livePlayersHash?.hash != localHash) {
      let updatedPlayersData = await actor.getAllPlayers();
      localStorage.setItem("players_data", JSON.stringify(updatedPlayersData, replacer));
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
      set(updatedPlayersData);
    } else {
      const cachedPlayersData = localStorage.getItem("players_data");
      let cachedPlayers: PlayerDTO[] = [];
      try {
        cachedPlayers = JSON.parse(cachedPlayersData || "[]");
      } catch (e) {
        cachedPlayers = [];
      }
      set(cachedPlayers);
    }
  }

  async function getPlayerDetails(playerId: number, seasonId: number): Promise<PlayerDetailDTO> {
    try {
      const playerDetailData = await actor.getPlayerDetails(playerId, seasonId);
      return playerDetailData;
    } catch (error) {
      console.error("Error fetching player data:", error);
      throw error;
    }
  }

  // ... (Include other methods like getGameweekPlayers, extractPlayerData, calculatePlayerScore, calculateBonusPoints, etc.)

  return {
    subscribe,
    updatePlayersData,
    getPlayerDetails,
    // ... (Expose other methods)
  };
}

export const playerStore = createPlayerStore();
