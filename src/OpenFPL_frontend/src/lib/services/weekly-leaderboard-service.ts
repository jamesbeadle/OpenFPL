import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import type {
  GetWeeklyLeaderboardDTO,
  WeeklyLeaderboardDTO,
  WeeklyRewardsDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class WeeklyLeaderboardService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
    );
  }

  async getWeeklyLeaderboard(
    offset: number,
    seasonId: number,
    gameweek: number,
  ): Promise<WeeklyLeaderboardDTO> {
    let dto: GetWeeklyLeaderboardDTO = {
      offset: BigInt(offset),
      seasonId: seasonId,
      limit: BigInt(25),
      searchTerm: "",
      gameweek: gameweek,
    };
    const result = await this.actor.getWeeklyLeaderboard(dto);
    if (isError(result)) throw new Error("Failed to fetch weekly leaderboard");
    return result.ok;
  }

  async getWeeklyRewards(
    seasonId: number,
    gameweek: number,
  ): Promise<WeeklyRewardsDTO | null> {
    const result = await this.actor.getWeeklyRewards(seasonId, gameweek);
    if (isError(result)) {
      return null;
    }

    return result.ok;
  }
}
