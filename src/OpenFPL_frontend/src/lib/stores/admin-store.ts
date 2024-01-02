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

  async function getMainCanisterInfo(): Promise<AdminMainCanisterInfo> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    let canisterDTOs: AdminMainCanisterInfo =
      await identityActor.adminGetMainCanisterInfo() as AdminMainCanisterInfo;
    console.log(canisterDTOs);
    return canisterDTOs;
  }
  async function getWeeklyCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminWeeklyCanisterList> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let canisterDTOs: AdminWeeklyCanisterList =
      await identityActor.adminGetWeeklyCanisters(limit, offset) as AdminWeeklyCanisterList;
    return canisterDTOs;
  }

  async function getMonthlyCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminMonthlyCanisterList> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let canisterDTOs: AdminMonthlyCanisterList =
      await identityActor.adminGetMonthlyCanisters(limit, offset) as AdminMonthlyCanisterList;
    return canisterDTOs;
  }

  async function getSeasonCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminSeasonCanisterList> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let canisterDTOs: AdminSeasonCanisterList =
      await identityActor.adminGetSeasonCanisters(limit, offset) as AdminSeasonCanisterList;
    return canisterDTOs;
  }

  async function getProfilePictureCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminProfilePictureCanisterList> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let canisterDTOs: AdminProfilePictureCanisterList =
      await identityActor.adminGetProfileCanisters(limit, offset) as AdminProfilePictureCanisterList;
    return canisterDTOs;
  }

  async function getTimers(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminTimerList | undefined> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let timerDTOs: AdminTimerList = await identityActor.adminGetTimers(limit, offset) as AdminTimerList;
    return timerDTOs;
  }

  async function getFixtures(
    seasonId: number
  ): Promise<AdminFixtureList | undefined> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    let fixtureDTOs: AdminFixtureList = await identityActor.adminGetFixtures(seasonId) as AdminFixtureList;
    return fixtureDTOs;
  }

  async function getClubs(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminClubList> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let clubDTOs: AdminClubList = await identityActor.adminGetClubs(limit, offset) as AdminClubList;
    return clubDTOs;
  }

  async function getPlayers(
    playerStatus: PlayerStatus
  ): Promise<AdminPlayerList> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    let playerDTOs: AdminPlayerList = await identityActor.adminGetPlayers(playerStatus) as AdminPlayerList;
    return playerDTOs;
  }

  async function getManagers(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminProfileList> {
    const identityActor = await ActorFactory.createIdentityActor(
      authStore,
      process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
    );
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let managerDTOs: AdminProfileList = await identityActor.adminGetManagers(limit, offset) as AdminProfileList;
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
