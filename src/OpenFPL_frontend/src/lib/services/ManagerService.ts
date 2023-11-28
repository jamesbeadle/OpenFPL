import { authStore } from "$lib/stores/auth";
import type { OptionIdentity } from "$lib/types/Identity";
import type { Unsubscriber } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  FantasyTeam,
  FantasyTeamSnapshot,
  ManagerDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

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

  async getManager(
    managerId: string,
    seasonId: number,
    gameweek: number
  ): Promise<ManagerDTO> {
    try {
      return await this.actor.getManager(managerId, seasonId, gameweek);
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
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
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching fantasy team:", error);
      throw error;
    }
  }

  async saveFantasyTeam(
    userFantasyTeam: FantasyTeam,
    activeGameweek: number
  ): Promise<any> {
    try {
      let bonusPlayed = this.getBonusPlayed(userFantasyTeam, activeGameweek);
      let bonusPlayerId = this.getBonusPlayerId(
        userFantasyTeam,
        activeGameweek
      );
      let bonusTeamId = this.getBonusTeamId(userFantasyTeam, activeGameweek);
      const identityActor = await this.actorFromIdentity();
      const fantasyTeam = await identityActor.saveFantasyTeam(
        userFantasyTeam.playerIds,
        userFantasyTeam.captainId,
        bonusPlayed,
        bonusPlayerId,
        bonusTeamId
      );
      return fantasyTeam;
    } catch (error) {
      console.error("Error saving fantasy team:", error);
      throw error;
    }
  }

  getBonusPlayed(userFantasyTeam: FantasyTeam, activeGameweek: number): number {
    let bonusPlayed = 0;

    if (userFantasyTeam.goalGetterGameweek === activeGameweek) {
      bonusPlayed = 1;
    }

    if (userFantasyTeam.passMasterGameweek === activeGameweek) {
      bonusPlayed = 2;
    }

    if (userFantasyTeam.noEntryGameweek === activeGameweek) {
      bonusPlayed = 3;
    }

    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusPlayed = 4;
    }

    if (userFantasyTeam.safeHandsGameweek === activeGameweek) {
      bonusPlayed = 5;
    }

    if (userFantasyTeam.captainFantasticGameweek === activeGameweek) {
      bonusPlayed = 6;
    }

    /* Coming soon
    if(userFantasyTeam.prospectsGameweek === activeGameweek){
      bonusPlayed = 7;
    }

    if(userFantasyTeam.countrymenGameweek === activeGameweek){
      bonusPlayed = 8;
    }
    */

    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 7;
    }

    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 8;
    }

    return bonusPlayed;
  }

  getBonusPlayerId(
    userFantasyTeam: FantasyTeam,
    activeGameweek: number
  ): number {
    let bonusPlayerId = 0;

    if (userFantasyTeam.goalGetterGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.goalGetterPlayerId;
    }

    if (userFantasyTeam.passMasterGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.passMasterPlayerId;
    }

    if (userFantasyTeam.noEntryGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.noEntryPlayerId;
    }

    if (userFantasyTeam.safeHandsGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.safeHandsPlayerId;
    }

    if (userFantasyTeam.captainFantasticGameweek === activeGameweek) {
      bonusPlayerId = userFantasyTeam.captainId;
    }

    return bonusPlayerId;
  }

  getBonusTeamId(userFantasyTeam: FantasyTeam, activeGameweek: number): number {
    let bonusTeamId = 0;

    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusTeamId = userFantasyTeam.teamBoostTeamId;
    }

    return bonusTeamId;
  }
}
