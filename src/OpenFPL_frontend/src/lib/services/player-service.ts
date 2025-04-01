import { authStore } from "$lib/stores/auth-store";
import { ActorFactory } from "../utils/actor.factory";
import { isError } from "../utils/helpers";
import { toasts } from "$lib/stores/toasts-store";
import type {
  LeagueId,
  Player,
} from "../../../../declarations/data_canister/data_canister.did";
import type { GetPlayersSnapshot, PlayersSnapshot } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class PlayerService {
  private actor: any;

  constructor() {}

  async getPlayers(): Promise<Player[] | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const leagueId: LeagueId = 1;
      const result = await identityActor.getPlayers(leagueId);
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

  async getSnapshotPlayers(dto: GetPlayersSnapshot): Promise<PlayersSnapshot | undefined> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.getPlayersSnapshot(dto);
      if (isError(result)) throw new Error("Failed to fetch gameweek players");
      return result.ok;
    } catch (error) {
      console.error("Error fetching gameweek players: ", error);
      toasts.addToast({
        type: "error",
        message: "Error fetching gameweek players.",
      });
    }
  }
}
