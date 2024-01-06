import { authStore } from "$lib/stores/auth.store";
import { systemStore } from "$lib/stores/system-store";
import { isError } from "$lib/utils/Helpers";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  FantasyTeamSnapshot,
  ProfileDTO,
  PublicProfileDTO,
  SystemStateDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createManagerStore() {
  const { subscribe, set } = writable<ProfileDTO | null>(null);

  let systemState: SystemStateDTO;
  systemStore.subscribe((value) => {
    systemState = value as SystemStateDTO;
  });

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function getManager(): Promise<ProfileDTO> {
    try {
      let newManager = {
        playerIds: [],
        countrymenCountryId: 0,
        username: "",
        goalGetterPlayerId: 0,
        hatTrickHeroGameweek: 0,
        transfersAvailable: 0,
        termsAccepted: false,
        teamBoostGameweek: 0,
        captainFantasticGameweek: 0,
        createDate: 0n,
        countrymenGameweek: 0,
        bankQuarterMillions: 0,
        noEntryPlayerId: 0,
        safeHandsPlayerId: 0,
        history: [],
        braceBonusGameweek: 0,
        favouriteClubId: 0,
        passMasterGameweek: 0,
        teamBoostClubId: 0,
        goalGetterGameweek: 0,
        captainFantasticPlayerId: 0,
        profilePicture: [],
        transferWindowGameweek: 0,
        noEntryGameweek: 0,
        prospectsGameweek: 0,
        safeHandsGameweek: 0,
        principalId: "",
        passMasterPlayerId: 0,
        captainId: 0,
        monthlyBonusesAvailable: 0,
      };

      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = await identityActor.getManager();

      if (isError(result)) {
        console.error("Error getting manager.");
        set(newManager);
      }

      let manager = result.ok;
      return manager;
    } catch (error) {
      console.error("Error fetching manager for gameweek:", error);
      throw error;
    }
  }

  async function getPublicProfile(
    principalId: string
  ): Promise<PublicProfileDTO> {
    try {
      let result = await actor.getPublicProfile(principalId);

      if (isError(result)) {
        console.error("Error getting public profile");
      }

      let profile = result.ok;
      return profile;
    } catch (error) {
      console.error("Error fetching manager profile for gameweek:", error);
      throw error;
    }
  }

  async function getTotalManagers(): Promise<number> {
    try {
      let result = await actor.getTotalManagers();

      if (isError(result)) {
        console.error("Error getting public profile");
      }

      const managerCountData = result.ok;
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
      let result = await actor.getManagerGameweek(
        managerId,
        systemState?.calculationGameweek,
        gameweek
      );

      if (isError(result)) {
        console.error("Error fetching fantasy team for gameweek:");
      }

      const fantasyTeamData = result.ok;
      return fantasyTeamData;
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }

  async function getFantasyTeam(): Promise<any> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      const result = await identityActor.getManager();

      if (isError(result)) {
        console.error("Error fetching fantasy team.");

        return;
      }

      let fantasyTeam = result.ok;
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching fantasy team:", error);
      throw error;
    }
  }

  async function saveFantasyTeam(
    userFantasyTeam: ProfileDTO,
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

      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );

      let result = await identityActor.saveFantasyTeam(
        userFantasyTeam.playerIds,
        userFantasyTeam.captainId,
        bonusPlayed,
        bonusPlayerId,
        bonusTeamId
      );

      if (isError(result)) {
        console.error("Error saving fantasy team");
        return;
      }

      const fantasyTeam = result.ok;
      return fantasyTeam;
    } catch (error) {
      console.error("Error saving fantasy team:", error);
      throw error;
    }
  }

  function getBonusPlayed(
    userFantasyTeam: ProfileDTO,
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

    if (userFantasyTeam.prospectsGameweek === activeGameweek) {
      bonusPlayed = 7;
    }

    if (userFantasyTeam.countrymenGameweek === activeGameweek) {
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
    userFantasyTeam: ProfileDTO,
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
    userFantasyTeam: ProfileDTO,
    activeGameweek: number
  ): number {
    let bonusTeamId = 0;

    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusTeamId = userFantasyTeam.teamBoostClubId;
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
    getPublicProfile,
  };
}

export const managerStore = createManagerStore();
