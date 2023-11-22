import type { DataCache } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { idlFactory } from "../../../../declarations/player_canister";
import type {
  PlayerDetailDTO,
  PlayerDTO,
  PlayerPointsDTO,
} from "../../../../declarations/player_canister/player_canister.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../../utils/Helpers";
import { SystemService } from "./SystemService";

export class PlayerService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.PLAYER_CANISTER_CANISTER_ID
    );
  }

  async updatePlayersData() {
    let category = "players";
    const newHashValues: DataCache[] = await this.actor.getDataHashes();
    let livePlayersHash =
      newHashValues.find((x) => x.category == category) ?? null;
    const localHash = localStorage.getItem(category);
    if (livePlayersHash?.hash != localHash) {
      let updatedPlayersData = await this.actor.getAllPlayers();
      localStorage.setItem(
        "players_data",
        JSON.stringify(updatedPlayersData, replacer)
      );
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
    }
  }

  async getPlayers(): Promise<PlayerDTO[]> {
    const cachedPlayersData = localStorage.getItem("players_data");

    let cachedPlayers: PlayerDTO[];
    try {
      cachedPlayers = JSON.parse(cachedPlayersData || "[]");
    } catch (e) {
      cachedPlayers = [];
    }

    return cachedPlayers;
  }

  async updatePlayerEventsData() {
    let category = "player_events";
    const newHashValues: DataCache[] = await this.actor.getDataHashes();
    let livePlayersHash =
      newHashValues.find((x) => x.category == category) ?? null;
    const localHash = localStorage.getItem(category);
    if (livePlayersHash?.hash != localHash) {
      let systemService = new SystemService();
      await systemService.updateSystemStateData();
      let systemState = await systemService.getSystemState();

      let updatedPlayersData = await this.actor.getAllPlayersMap(
        systemState?.activeSeason?.id,
        systemState?.activeGameweek
      );
      localStorage.setItem(
        "players_data",
        JSON.stringify(updatedPlayersData, replacer)
      );
      localStorage.setItem(category, livePlayersHash?.hash ?? "");
    }
  }

  async getPlayerEvents(): Promise<PlayerPointsDTO[]> {
    const cachedPlayerEventsData = localStorage.getItem("player_events_data");

    let cachedPlayerEvents: PlayerPointsDTO[];
    try {
      cachedPlayerEvents = JSON.parse(cachedPlayerEventsData || "[]");
    } catch (e) {
      cachedPlayerEvents = [];
    }

    return cachedPlayerEvents;
  }

  async getPlayerDetails(
    playerId: number,
    seasonId: number
  ): Promise<PlayerDetailDTO> {
    try {
      const playerDetailData = await this.actor.getPlayerDetails(
        playerId,
        seasonId
      );
      return playerDetailData;
    } catch (error) {
      console.error("Error fetching player data:", error);
      throw error;
    }
  }
}
