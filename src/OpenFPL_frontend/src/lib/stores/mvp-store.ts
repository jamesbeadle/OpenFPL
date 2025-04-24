import { MVPService } from "$lib/services/mvp-service";
import type {
  GetMostValuableGameweekPlayers,
  MostValuableGameweekPlayers,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createMVPStore() {
  async function getMostValuableGameweekPlayers(
    dto: GetMostValuableGameweekPlayers,
  ): Promise<MostValuableGameweekPlayers | undefined> {
    return new MVPService().getMostValuableGameweekPlayers(dto);
  }

  return {
    getMostValuableGameweekPlayers,
  };
}

export const mvpStore = createMVPStore();
