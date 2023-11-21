import type { OptionIdentity } from "$lib/types/Identity";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { FantasyTeam, FantasyTeamSnapshot } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { SystemService } from "./SystemService";
import { authStore } from "$lib/stores/auth";

export class ManagerService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  async actorFromIdentity() {
    const identity = await new Promise<OptionIdentity>((resolve, reject) => {
      const unsubscribe = authStore.subscribe(store => {
        if (store.identity) {
          unsubscribe();
          resolve(store.identity);
        }
      });
    });
    
    return ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
      identity
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
  
  async getFantasyTeam(): Promise<any> {
    try {
      const identityActor = await this.actorFromIdentity();
      const fantasyTeam = await identityActor.getFantasyTeam();
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching total managers:", error);
      throw error;
    }
  }
  
  async saveFantasyTeam(userFantasyTeam: FantasyTeam): Promise<any> {
    try {
      const identityActor = await this.actorFromIdentity();
      const fantasyTeam = await identityActor.saveFantasyTeam(userFantasyTeam);
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching total managers:", error);
      throw error;
    }
  }
}
