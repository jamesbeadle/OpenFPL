import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  PlayerPointsDTO,
  AppStatusDTO,
  GameweekFiltersDTO,
  GetPlayerDetailsDTO,
  PlayerDetailDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { leagueStore } from "$lib/stores/league-store";

export class PlayerEventsService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getPlayerDetailsForGameweek(
    seasonId: number,
    gameweek: number,
  ): Promise<PlayerPointsDTO[]> {
    let dto: GameweekFiltersDTO = {
      seasonId,
      gameweek,
    };
    console.log("Service: get player details for gameweek");
    const result = await this.actor.getPlayerDetailsForGameweek(dto);
    if (isError(result))
      throw new Error(
        "Failed to fetch player details for gameweek in player events service",
      );
    return result.ok;
  }

  async getPlayerDetails(
    playerId: number,
    seasonId: number,
  ): Promise<PlayerDetailDTO> {
    try {
      let dto: GetPlayerDetailsDTO = {
        playerId: playerId,
        seasonId: seasonId,
      };
      console.log("Service: get player details");
      let result = await this.actor.getPlayerDetails(dto);

      if (isError(result)) {
        console.error("Error fetching player details");
      }

      return result.ok;
    } catch (error) {
      console.error("Error fetching player data:", error);
      throw error;
    }
  }

  async getPlayerEvents(
    seasonId: number,
    gameweek: number,
  ): Promise<PlayerPointsDTO[]> {
    try {
      let dto: GameweekFiltersDTO = {
        seasonId,
        gameweek,
      };
      let result = await this.actor.getPlayerDetailsForGameweek(dto);

      if (isError(result)) {
        console.error("Error fetching player details for gameweek");
      }

      return result.ok;
    } catch (error) {
      console.error("Error fetching player details for gameweek:", error);
      throw error;
    }
  }
}
