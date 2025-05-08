import { authStore } from "$lib/stores/auth-store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "$lib/utils/Helpers";
import { toastsStore } from "$lib/stores/toasts-store";
import type {
  GetPlayerDetailsForGameweek,
  GetPlayersMap,
  PlayerDetailsForGameweek,
  PlayerDetails,
  GetPlayerDetails,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class PlayerEventsService {
  constructor() {}

  async getPlayerDetails(
    playerId: number,
    seasonId: number,
  ): Promise<PlayerDetails> {
    try {
      let dto: GetPlayerDetails = {
        leagueId: Number(process.env.LEAGUE_ID),
        playerId: playerId,
        seasonId: seasonId,
      };
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );

      let result = await identityActor.getPlayerDetails(dto);

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
  ): Promise<PlayerDetailsForGameweek | undefined> {
    try {
      let dto: GetPlayerDetailsForGameweek = {
        leagueId: Number(process.env.LEAGUE_ID),
        seasonId,
        gameweek,
      };
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let result = await identityActor.getPlayerEvents(dto);

      if (isError(result)) {
        console.error("Error fetching player details for gameweek");
      }

      return result.ok;
    } catch (error) {
      console.error("Error fetching player events: ", error);
      toastsStore.addToast({
        type: "error",
        message: "Error fetching player events.",
      });
    }
  }
}
