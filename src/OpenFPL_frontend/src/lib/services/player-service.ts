import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  DataHashDTO,
  PlayerDTO,
  ClubFilterDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class PlayerService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getPlayers(): Promise<PlayerDTO[]> {
    console.log("Service: get players");
    const result = await this.actor.getPlayers();
    if (isError(result)) throw new Error("Failed to fetch players");
    return result.ok;
  }

  async getLoanedPlayers(clubId: number): Promise<PlayerDTO[]> {
    console.log("Service: get loaned players");
    const dto: ClubFilterDTO = { leagueId: 1, clubId: clubId };
    const result = await this.actor.getLoanedPlayers(dto);
    if (isError(result)) throw new Error("Failed to fetch loaned players");
    return result.ok;
  }

  async getRetiredPlayers(clubId: number): Promise<PlayerDTO[]> {
    console.log("Service: get retired players");
    const dto: ClubFilterDTO = { leagueId: 1, clubId: clubId };
    const result = await this.actor.getRetiredPlayers(dto);
    if (isError(result)) throw new Error("Failed to fetch retired players");
    return result.ok;
  }
}
