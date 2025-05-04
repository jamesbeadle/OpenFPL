import { ActorFactory } from "../utils/actor.factory";
import { storeManager } from "$lib/managers/store-manager";
import { authStore } from "$lib/stores/auth-store";
import { leagueStore } from "$lib/stores/league-store";

import { isError } from "$lib/utils/Helpers";
import { toasts } from "./toasts-store";
import type {
  BonusType,
  ClubId,
  CountryId,
  FantasyTeamSnapshot,
  GetFantasyTeamSnapshot,
  GetManager,
  LeagueStatus,
  Manager,
  PlayBonus,
  PlayerId,
  SaveFantasyTeam,
  TeamSetup,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

function createManagerStore() {
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
    bankQuarterMillions: 1400,
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
  ): Promise<Manager | null> {
    await storeManager.syncStores();
    try {
      let leagueStatus: LeagueStatus | null = null;
      leagueStore.subscribe((result) => {
        if (result == null) {
          throw new Error("Failed to subscribe to league store");
        }
        leagueStatus = result;
      });

      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let dto: GetManager = {
        principalId,
      };

      let result = await identityActor.getManager(dto);

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
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let result = await identityActor.getTotalManagers();

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
  ): Promise<FantasyTeamSnapshot | null> {
    try {
      let dto: GetFantasyTeamSnapshot = {
        principalId: managerId,
        gameweek,
        seasonId,
      };

      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      let result = await identityActor.getFantasyTeamSnapshot(dto);
      if (isError(result)) {
        console.error("Error fetching fantasy team for gameweek:");
        toasts.addToast({
          message: `Error Fetching Fantasy Team for Gameweek ${gameweek}`,
          type: "error",
        });
      }
      return result.ok;
    } catch (error) {
      console.error("Error fetching fantasy team for gameweek:", error);
      toasts.addToast({
        message: `Error Fetching Fantasy Team for Gameweek ${gameweek}`,
        type: "error",
      });
      throw error;
    }
  }

  async function getTeamSelection(): Promise<TeamSetup> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );
      const result = await identityActor.getTeamSelection();

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
    userFantasyTeam: TeamSetup,
    activeGameweek: number,
    transferWindowPlayedInSession: boolean,
  ): Promise<any> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );

      let dto: SaveFantasyTeam = {
        principalId: userFantasyTeam.principalId,
        playerIds: userFantasyTeam.playerIds,
        captainId: userFantasyTeam.captainId,
        playTransferWindowBonus: transferWindowPlayedInSession,
      };

      let result = await identityActor.saveTeamSelection(dto);

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

  async function saveBonus(
    principalId: string,
    bonusType: BonusType,
    bonusPlayerId: PlayerId,
    bonusTeamId: ClubId,
    bonusCountryId: CountryId,
  ): Promise<any> {
    try {
      const identityActor: any = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? "",
      );

      let bonusDto: PlayBonus = {
        clubId: bonusTeamId,
        playerId: bonusPlayerId,
        countryId: bonusCountryId,
        bonusType,
        principalId,
      };

      let result = await identityActor.saveBonusSelection(bonusDto);

      if (isError(result)) {
        console.error("Error saving bonus", result);
        return false;
      }

      toasts.addToast({
        message: "Bonus saved successully!",
        type: "success",
        duration: 2000,
      });
      return true;
    } catch (error) {
      console.error("Error saving bonus:", error);
      toasts.addToast({
        message: "Error saving bonus.",
        type: "error",
      });
      return false;
    }
  }

  return {
    getTotalManagers,
    getFantasyTeamForGameweek,
    getTeamSelection,
    saveFantasyTeam,
    getPublicProfile,
    saveBonus,
  };
}

export const managerStore = createManagerStore();
