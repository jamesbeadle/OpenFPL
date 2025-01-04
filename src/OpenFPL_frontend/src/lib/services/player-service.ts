import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  DataHashDTO,
  PlayerDTO,
  ClubFilterDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { toasts } from "$lib/stores/toasts-store";

export class PlayerService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getPlayers(): Promise<PlayerDTO[] | undefined> {
    try {
      const result = await this.actor.getPlayers();
      if (isError(result)) throw new Error("Failed to fetch league players");
      return result.ok;
    } catch (error) {
      console.error("Error fetching league players: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching league players.",
      });
    }
  }

  async getLoanedPlayers(clubId: number): Promise<PlayerDTO[] | undefined> {
    try {
      const dto: ClubFilterDTO = { leagueId: 1, clubId: clubId };
      const result = await this.actor.getLoanedPlayers(dto);
      if (isError(result)) throw new Error("Failed to fetch loaned players");
      return result.ok;
    } catch (error) {
      console.error("Error fetching loaned players: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching loaned players.",
      });
    }
  }

  async getRetiredPlayers(clubId: number): Promise<PlayerDTO[] | undefined> {
    try {
      const dto: ClubFilterDTO = { leagueId: 1, clubId: clubId };
      const result = await this.actor.getRetiredPlayers(dto);
      if (isError(result)) throw new Error("Failed to fetch retired players");
      return result.ok;
    } catch (error) {
      console.error("Error fetching retired players: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching retired players.",
      });
    }
  }
}
