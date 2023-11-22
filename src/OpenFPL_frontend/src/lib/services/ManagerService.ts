import { authStore } from "$lib/stores/auth";
import type { OptionIdentity } from "$lib/types/Identity";
import type { Unsubscriber } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  FantasyTeam,
  FantasyTeamSnapshot,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
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

  async actorFromIdentity() {
    let unsubscribe: Unsubscriber;
    return new Promise<OptionIdentity>((resolve, reject) => {
      unsubscribe = authStore.subscribe((store) => {
        if (store.identity) {
          resolve(store.identity);
        }
      });
    }).then((identity) => {
      unsubscribe();
      return ActorFactory.createActor(
        idlFactory,
        process.env.OPENFPL_BACKEND_CANISTER_ID,
        identity
      );
    });
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

  async getFantasyTeamForGameweek(
    managerId: string,
    gameweek: number
  ): Promise<FantasyTeamSnapshot> {
    try {
      let systemService = new SystemService();
      await systemService.updateSystemStateData();
      let systemState = await systemService.getSystemState();
      const fantasyTeamData = await this.actor.getFantasyTeamForGameweek(
        managerId,
        systemState?.activeSeason.id,
        gameweek
      );
      return fantasyTeamData;
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }

  async getFantasyTeam(): Promise<any> {
    try {
      const identityActor = await this.actorFromIdentity();
      const fantasyTeam = await identityActor.getFantasyTeam();
      console.log(fantasyTeam);
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching fantasy team:", error);
      throw error;
    }
  }

  async saveFantasyTeam(userFantasyTeam: FantasyTeam): Promise<any> {
    try {
      const identityActor = await this.actorFromIdentity();
      const fantasyTeam = await identityActor.saveFantasyTeam(userFantasyTeam);
      return fantasyTeam;
    } catch (error) {
      console.error("Error saving fantasy team:", error);
      throw error;
    }
  }
}
