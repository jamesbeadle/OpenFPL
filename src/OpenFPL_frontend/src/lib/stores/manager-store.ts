import { writable, type Unsubscriber } from 'svelte/store';
import { authStore } from '$lib/stores/auth';
import { systemStore } from '$lib/stores/system-store';
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import type { FantasyTeam, FantasyTeamSnapshot, ManagerDTO, SystemState } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import type { OptionIdentity } from '$lib/types/Identity';

function createManagerStore() {
  const { subscribe, set } = writable<ManagerDTO | null>(null);

  let systemState: SystemState;
  systemStore.subscribe(value => { systemState = value as SystemState });
  
  const actor = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function actorFromIdentity() {
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

  async function getManager(managerId: string, seasonId: number, gameweek: number): Promise<ManagerDTO> {
    try {
      return await actor.getManager(managerId, seasonId, gameweek) as ManagerDTO;
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }

  async function getTotalManagers(): Promise<number> {
    try {
      const managerCountData = await actor.getTotalManagers();
      return Number(managerCountData);
    } catch (error) {
      console.error("Error fetching total managers:", error);
      throw error;
    }
  }

  async function getFantasyTeamForGameweek(managerId: string, gameweek: number): Promise<FantasyTeamSnapshot> {
    try {
      const fantasyTeamData = await actor.getFantasyTeamForGameweek(
        managerId,
        systemState?.activeSeason.id,
        gameweek
      ) as FantasyTeamSnapshot;
      return fantasyTeamData;
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }

  async function getFantasyTeam(): Promise<any> {
    try {
      const identityActor = await actorFromIdentity();
      const fantasyTeam = await identityActor.getFantasyTeam();
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching fantasy team:", error);
      throw error;
    }
  }

  async function saveFantasyTeam(userFantasyTeam: FantasyTeam, activeGameweek: number): Promise<any> {
    try {
      let bonusPlayed = getBonusPlayed(userFantasyTeam, activeGameweek);
      let bonusPlayerId = getBonusPlayerId(
        userFantasyTeam,
        activeGameweek
      );
      let bonusTeamId = getBonusTeamId(userFantasyTeam, activeGameweek);
      const identityActor = await actorFromIdentity();
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
  
  function getBonusPlayed(userFantasyTeam: FantasyTeam, activeGameweek: number): number {
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

  function getBonusPlayerId(
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

  function getBonusTeamId(userFantasyTeam: FantasyTeam, activeGameweek: number): number {
    let bonusTeamId = 0;

    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusTeamId = userFantasyTeam.teamBoostTeamId;
    }

    return bonusTeamId;
  }

  return {
    subscribe,
    getManager,
    getTotalManagers,
    getFantasyTeamForGameweek,
    getFantasyTeam,
    saveFantasyTeam
    // Add any other methods as needed
  };
}

export const managerStore = createManagerStore();
