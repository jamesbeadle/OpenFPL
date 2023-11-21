import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { FantasyTeamSnapshot } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { SystemService } from "./SystemService";

export class ManagerService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  async getTotalManagers(): Promise<number> {
    try {
      const managerCountData = await this.actor.getTotalManagers();
      return Number(managerCountData);
    } catch (error) {
      console.error("Error fetching total managers:", error);
      throw error;
    }
  }

  async getFantasyTeamForGameweek(managerId: string, gameweek: number): Promise<FantasyTeamSnapshot> {
    try {
      let systemService = new SystemService();
      let systemState = await systemService.getSystemState();
      const fantasyTeamData = await this.actor.getFantasyTeamForGameweek(managerId, systemState?.activeSeason.id, gameweek);
      return fantasyTeamData;
    } catch (error) {
      console.error("Error fetching total managers:", error);
      throw error;
    }
  }

  //Need a function to get the fantasy team of the logged in user but sending the principal
  

  //save fantasty team - use the same auth procedure as above
}
