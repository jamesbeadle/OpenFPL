import { authStore } from "$lib/stores/auth.store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  PlayerPointsDTO,
  GameweekFiltersDTO,
  GetPlayerDetailsDTO,
  PlayerDetailDTO,
  LeagueId,
  PlayerScoreDTO,
} from "../../../../external_declarations/data_canister/data_canister.did";
import { toasts } from "$lib/stores/toasts-store";

export class PlayerEventsService {
  private actor: any;

  constructor() {}

  async getPlayerPoints(
    seasonId: number,
    gameweek: number,
  ): Promise<PlayerPointsDTO[] | undefined> {
    try {
    } catch (error) {}
    let dto: GameweekFiltersDTO = {
      seasonId,
      gameweek,
    };
    const result = await this.actor.getPlayerPoints(dto);
    if (isError(result))
      throw new Error(
        "Failed to fetch player details for gameweek in player events service",
      );
    return result.ok;
  }

  async getPlayerDetails(
    playerId: number,
    seasonId: number,
  ): Promise<PlayerDetailDTO | undefined> {
    try {
      let dto: GetPlayerDetailsDTO = {
        playerId: playerId,
        seasonId: seasonId,
      };
      const identityActor: any =
        await ActorFactory.createDataCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_DATA ?? "",
        );
      const leagueId: LeagueId = 1;

      let result = await identityActor.getPlayerDetails(leagueId, dto);

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
  ): Promise<PlayerPointsDTO[] | undefined> {
    try {
      let dto: GameweekFiltersDTO = {
        seasonId,
        gameweek,
      };
      const identityActor: any =
        await ActorFactory.createDataCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_DATA ?? "",
        );
      const leagueId: LeagueId = 1;
      let result = await identityActor.getPlayerDetailsForGameweek(
        leagueId,
        dto,
      );

      if (isError(result)) {
        console.error("Error fetching player details for gameweek");
      }

      return result.ok;
    } catch (error) {
      console.error("Error fetching player events: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching player events.",
      });
    }
  }

  async getPlayerMap(
    seasonId: number,
    gameweek: number,
  ): Promise<PlayerScoreDTO[] | undefined> {
    try {
      const identityActor: any =
        await ActorFactory.createDataCanisterIdentityActor(
          authStore,
          process.env.CANISTER_ID_DATA ?? "",
        );
      let dto: GameweekFiltersDTO = {
        seasonId,
        gameweek,
      };
      const leagueId: LeagueId = 1;
      const result = await identityActor.getPlayersMap(leagueId, dto);
      if (isError(result)) throw new Error("Failed to fetch player map");
      return result.ok;
    } catch (error) {
      console.error("Error fetching player map: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching player map.",
      });
    }
  }
}
