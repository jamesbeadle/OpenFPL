import { idlFactory } from "../../../../declarations/OpenWSL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError } from "../utils/helpers";
import type {
  DataHashDTO,
  PlayerDTO,
  ClubFilterDTO,
} from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";

export class PlayerService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENWSL_BACKEND_CANISTER_ID,
    );
  }

  async getPlayers(): Promise<PlayerDTO[]> {
    const result = await this.actor.getPlayers();
    if (isError(result)) throw new Error("Failed to fetch players");
    return result.ok;
  }

  async getLoanedPlayers(clubId: number): Promise<PlayerDTO[]> {
    const dto: ClubFilterDTO = { leagueId: 2, clubId: clubId };
    const result = await this.actor.getLoanedPlayers(dto);
    if (isError(result)) throw new Error("Failed to fetch loaned players");
    return result.ok;
  }

  async getRetiredPlayers(clubId: number): Promise<PlayerDTO[]> {
    const dto: ClubFilterDTO = { leagueId: 2, clubId: clubId };
    const result = await this.actor.getRetiredPlayers(dto);
    if (isError(result)) throw new Error("Failed to fetch retired players");
    return result.ok;
  }
}
