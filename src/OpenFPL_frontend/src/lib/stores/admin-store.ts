import { isError } from "$lib/utils/Helpers";
import type {
  AdminClubList,
  AdminFixtureList,
  AdminMainCanisterInfo,
  AdminMonthlyCanisterList,
  AdminPlayerList,
  AdminProfileList,
  AdminProfilePictureCanisterList,
  AdminSeasonCanisterList,
  AdminTimerList,
  AdminWeeklyCanisterList,
  PlayerStatus,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { authStore } from "./auth.store";

function createAdminStore() {
  async function getMainCanisterInfo(): Promise<AdminMainCanisterInfo | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const result = await identityActor.adminGetMainCanisterInfo();

    if (isError(result)) {
      console.error("Error fetching main canister info");
      return null;
    }
    let mainCanisterInfo: AdminMainCanisterInfo = result.ok;
    return mainCanisterInfo;
  }
  async function getWeeklyCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminWeeklyCanisterList | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;

    const result = await identityActor.adminGetWeeklyCanisters(limit, offset);

    if (isError(result)) {
      console.error("Error fetching weekly canister info");
      return null;
    }

    let canisterDTOs: AdminWeeklyCanisterList = result.ok;
    return canisterDTOs;
  }

  async function getMonthlyCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminMonthlyCanisterList | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    const result = await identityActor.adminGetMonthlyCanisters(limit, offset);

    if (isError(result)) {
      console.error("Error fetching monthly canister info");
      return null;
    }

    let canisterDTOs: AdminMonthlyCanisterList = result.ok;
    return canisterDTOs;
  }

  async function getSeasonCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminSeasonCanisterList | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    const result = await identityActor.adminGetSeasonCanisters(limit, offset);

    if (isError(result)) {
      console.error("Error fetching season canister info");
      return null;
    }

    let canisterDTOs: AdminSeasonCanisterList = result.ok;
    return canisterDTOs;
  }

  async function getProfilePictureCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminProfilePictureCanisterList | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    const result = await identityActor.adminGetProfileCanisters(limit, offset);

    if (isError(result)) {
      console.error("Error fetching profile picture canister info");
      return null;
    }
    let canisterDTOs: AdminProfilePictureCanisterList = result.ok;
    return canisterDTOs;
  }

  async function getTimers(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminTimerList | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    const result = await identityActor.adminGetTimers(limit, offset);

    if (isError(result)) {
      console.error("Error fetching timer info");
      return null;
    }
    let timerDTOs: AdminTimerList = result.ok;
    return timerDTOs;
  }

  async function getFixtures(
    seasonId: number
  ): Promise<AdminFixtureList | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const result = await identityActor.adminGetFixtures(seasonId);

    if (isError(result)) {
      console.error("Error fetching fixture info");
      return null;
    }
    let fixtureDTOs: AdminFixtureList = result.ok;
    return fixtureDTOs;
  }

  async function getClubs(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminClubList | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    const result = await identityActor.adminGetClubs(limit, offset);

    if (isError(result)) {
      console.error("Error fetching club info");
      return null;
    }
    let clubDTOs: AdminClubList = result.ok;
    return clubDTOs;
  }

  async function getPlayers(
    playerStatus: PlayerStatus
  ): Promise<AdminPlayerList | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const result = await identityActor.adminGetPlayers(playerStatus);

    if (isError(result)) {
      console.error("Error fetching player info");
      return null;
    }
    let playerDTOs: AdminPlayerList = result.ok;
    return playerDTOs;
  }

  async function getManagers(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminProfileList | null> {
    const identityActor: any = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    const result = await identityActor.adminGetManagers(limit, offset);
    if (isError(result)) {
      console.error("Error fetching manager info");
      return null;
    }
    let managerDTOs: AdminProfileList = result.ok;
    return managerDTOs;
  }

  return {
    getMainCanisterInfo,
    getWeeklyCanisters,
    getMonthlyCanisters,
    getSeasonCanisters,
    getProfilePictureCanisters,
    getTimers,
    getFixtures,
    getClubs,
    getPlayers,
    getManagers,
  };
}

export const adminStore = createAdminStore();
