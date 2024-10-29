import { idlFactory } from "../../../../declarations/OpenWSL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";
import type {
  PlayerPointsDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
import type {
  GameweekFiltersDTO,
  GetPlayerDetailsDTO,
  PlayerDetailDTO,
} from "../../../../declarations/data_canister/data_canister.did";
import { systemStore } from "$lib/stores/system-store";

export class PlayerEventsService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENWSL_BACKEND_CANISTER_ID,
    );
  }

  async getPlayerDetailsForGameweek(): Promise<PlayerPointsDTO[]> {
    let systemState: SystemStateDTO | null = null;
    systemStore.subscribe((value) => {
      systemState = value as SystemStateDTO;
    });

    if (systemState == null) {
      throw new Error("Failed to fetch system state in player events service");
    }

    let dto: GameweekFiltersDTO = {
      seasonId: (systemState as SystemStateDTO).calculationSeasonId,
      gameweek: (systemState as SystemStateDTO).calculationGameweek,
    };
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
