import { ActorFactory } from "../utils/actor.factory";
import { storeManager } from "$lib/managers/store-manager";
import { authStore } from "$lib/stores/auth.store";
import { leagueStore } from "$lib/stores/league-store";

import { isError } from "$lib/utils/helpers";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { toasts } from "./toasts-store";
import type {
  GetManagerDTO,
  GetManagerGameweekDTO,
  ManagerDTO,
  ManagerGameweekDTO,
  SaveTeamDTO,
  TeamSelectionDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import type { LeagueStatus } from "../../../../external_declarations/data_canister/data_canister.did";

function createManagerStore() {
  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID,
  );

  let newManager = {
    playerIds: [],
    oneNationCountryId: 0,
    username: "",
    goalGetterPlayerId: 0,
    hatTrickHeroGameweek: 0,
    transfersAvailable: 0,
    termsAccepted: false,
    teamBoostGameweek: 0,
    captainFantasticGameweek: 0,
    createDate: 0n,
    oneNationGameweek: 0,
    bankQuarterMillions: 1200,
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
    canisterId: "",
    firstGameweek: true,
  };

  async function getPublicProfile(
    principalId: string,
  ): Promise<ManagerDTO | null> {
    await storeManager.syncStores();
    try {
      let leagueStatus: LeagueStatus | null = null;
      leagueStore.subscribe((result) => {
        if (result == null) {
          throw new Error("Failed to subscribe to league store");
        }
        leagueStatus = result;
      });
      let dto: GetManagerDTO = {
        principalId,
        month: 0,
        seasonId: leagueStatus!.activeSeasonId,
        gameweek: leagueStatus!.completedGameweek,
      };

      let result = await actor.getManager(dto);

      if (isError(result)) {
        console.error("Error getting public profile");
        return null;
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
        console.error("Error getting total managers");
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
    gameweek: number,
    seasonId: number,
  ): Promise<ManagerGameweekDTO | null> {
    try {
      let dto: GetManagerGameweekDTO = {
        principalId: managerId,
        gameweek,
        seasonId,
      };
      let result = await actor.getFantasyTeamSnapshot(dto);
      if (isError(result)) {
        console.error("Error fetching fantasy team for gameweek:");
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      throw error;
    }
  }

  async function getCurrentTeam(): Promise<TeamSelectionDTO> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.getCurrentTeam();

      if (isError(result)) {
        return newManager;
      }

      let fantasyTeam = result.ok;
      return fantasyTeam;
    } catch (error) {
      console.error("Error fetching fantasy team:", error);
      throw error;
    }
  }

  async function saveFantasyTeam(
    userFantasyTeam: TeamSelectionDTO,
    activeGameweek: number,
    bonusUsedInSession: boolean,
    transferWindowPlayedInSession: boolean,
  ): Promise<any> {
    try {
      let bonusPlayed = 0;
      let bonusPlayerId = 0;
      let bonusTeamId = 0;
      let bonusCountryId = 0;

      if (bonusUsedInSession) {
        bonusPlayerId = getBonusPlayerId(userFantasyTeam, activeGameweek);
        bonusTeamId = getBonusTeamId(userFantasyTeam, activeGameweek);
        bonusPlayed = getBonusPlayed(userFantasyTeam, activeGameweek);
        bonusCountryId = getBonusCountryId(userFantasyTeam, activeGameweek);
      }
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );

      let dto: SaveTeamDTO = {
        playerIds: userFantasyTeam.playerIds,
        captainId: userFantasyTeam.captainId,
        transferWindowGameweek: transferWindowPlayedInSession
          ? [activeGameweek]
          : [userFantasyTeam.transferWindowGameweek],
        teamName: [userFantasyTeam.username],
      };

      let result = await identityActor.saveFantasyTeam(dto);

      if (isError(result)) {
        console.error("Error saving fantasy team", result);
        return;
      }

      const fantasyTeam = result.ok;
      toasts.addToast({
        message: "Team saved successully!",
        type: "success",
        duration: 2000,
      });
      return fantasyTeam;
    } catch (error) {
      console.error("Error saving fantasy team:", error);
      toasts.addToast({
        message: "Error saving team.",
        type: "error",
      });
    }
  }

  function getBonusPlayed(
    userFantasyTeam: TeamSelectionDTO,
    activeGameweek: number,
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

    if (userFantasyTeam.oneNationGameweek === activeGameweek) {
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
    userFantasyTeam: TeamSelectionDTO,
    activeGameweek: number,
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
    userFantasyTeam: TeamSelectionDTO,
    activeGameweek: number,
  ): number {
    let bonusTeamId = 0;

    if (userFantasyTeam.teamBoostGameweek === activeGameweek) {
      bonusTeamId = userFantasyTeam.teamBoostClubId;
    }

    return bonusTeamId;
  }

  function getBonusCountryId(
    userFantasyTeam: TeamSelectionDTO,
    activeGameweek: number,
  ): number {
    let bonusCountryId = 0;

    if (userFantasyTeam.oneNationGameweek === activeGameweek) {
      bonusCountryId = userFantasyTeam.oneNationCountryId;
    }

    return bonusCountryId;
  }

  return {
    getTotalManagers,
    getFantasyTeamForGameweek,
    getCurrentTeam,
    saveFantasyTeam,
    getPublicProfile,
  };
}

export const managerStore = createManagerStore();
