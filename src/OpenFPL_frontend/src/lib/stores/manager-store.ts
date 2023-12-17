import { authStore } from "$lib/stores/auth.store";
import { systemStore } from "$lib/stores/system-store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  FantasyTeam,
  FantasyTeamSnapshot,
  ManagerDTO,
  SystemState,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createManagerStore() {
  const { subscribe, set } = writable<ManagerDTO | null>(null);

  let systemState: SystemState;
  systemStore.subscribe((value) => {
    systemState = value as SystemState;
  });

  const actor = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function getManager(
    managerId: string,
    seasonId: number,
    gameweek: number
  ): Promise<ManagerDTO> {
    try {
      return (await actor.getManager(
        managerId,
        seasonId,
        gameweek
      )) as ManagerDTO;
    } catch (error) {
      console.error("Error fetching manager for gameweek:", error);
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

  async function getFantasyTeamForGameweek(
    managerId: string,
    gameweek: number
  ): Promise<FantasyTeamSnapshot> {
    try {
      const fantasyTeamData = (await actor.getFantasyTeamForGameweek(
        managerId,
        systemState?.activeSeason.id,
        gameweek
      )) as FantasyTeamSnapshot;
      return fantasyTeamData;
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }

  async function getFantasyTeam(): Promise<any> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const fantasyTeam = await identityActor.getFantasyTeam();
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching fantasy team:", error);
      throw error;
    }
  }

  async function saveFantasyTeam(
    userFantasyTeam: FantasyTeam,
    activeGameweek: number,
    bonusUsedInSession: boolean
  ): Promise<any> {
    try {
      let bonusPlayed = 0;
      let bonusPlayerId = 0;
      let bonusTeamId = 0;

      if (bonusUsedInSession) {
        bonusPlayed = getBonusPlayed(userFantasyTeam, activeGameweek);
        bonusPlayerId = getBonusPlayerId(userFantasyTeam, activeGameweek);
        bonusTeamId = getBonusTeamId(userFantasyTeam, activeGameweek);
      }

      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
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

  function getBonusPlayed(
    userFantasyTeam: FantasyTeam,
    activeGameweek: number
  ): number {
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

    if(userFantasyTeam.prospectsGameweek === activeGameweek){
      bonusPlayed = 7;
    }

    if(userFantasyTeam.countrymenGameweek === activeGameweek){
      bonusPlayed = 8;
    }

    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 9;
    }

    if (userFantasyTeam.hatTrickHeroGameweek === activeGameweek) {
      bonusPlayed = 10;
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

  function getBonusTeamId(
    userFantasyTeam: FantasyTeam,
    activeGameweek: number
  ): number {
    let bonusTeamId = 0;

    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusTeamId = userFantasyTeam.teamBoostTeamId;
    }

    return bonusTeamId;
  }

  async function snapshotFantasyTeams() {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      await identityActor.snapshotFantasyTeams();
    } catch (error) {
      console.error("Error snapshotting fantasy teams:", error);
      throw error;
    }
  }

  return {
    subscribe,
    getManager,
    getTotalManagers,
    getFantasyTeamForGameweek,
    getFantasyTeam,
    saveFantasyTeam,
    snapshotFantasyTeams,
  };
}

export const managerStore = createManagerStore();
