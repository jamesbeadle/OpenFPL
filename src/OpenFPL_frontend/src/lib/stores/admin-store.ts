import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  AdminClubList,
  AdminFixtureList,
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

function createAdminStore() {
  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function getWeeklyCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminWeeklyCanisterList> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let canisterDTOs: AdminWeeklyCanisterList =
    await actor.adminGetWeeklyCanisters(limit, offset);
    return canisterDTOs;
  }

  async function getMonthlyCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminMonthlyCanisterList> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let canisterDTOs: AdminMonthlyCanisterList =
    await actor.adminGetMonthlyCanisters(limit, offset);
    return canisterDTOs;
  }

  async function getSeasonCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminSeasonCanisterList> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let canisterDTOs: AdminSeasonCanisterList =
    await actor.adminGetSeasonCanisters(limit, offset);
    return canisterDTOs;
  }

  async function getProfilePictureCanisters(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminProfilePictureCanisterList> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let canisterDTOs: AdminProfilePictureCanisterList =
    await actor.adminGetProfileCanisters(limit, offset);
    return canisterDTOs;
  }

  async function getTimers(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminTimerList | undefined> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let timerDTOs: AdminTimerList = await actor.adminGetTimers(limit, offset);
    return timerDTOs;
  }

  async function getFixtures(
    seasonId: number
  ): Promise<AdminFixtureList | undefined> {
    let fixtureDTOs: AdminFixtureList = await actor.adminGetFixtures(seasonId);
    return fixtureDTOs;
  }

  async function getClubs(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminClubList> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let clubDTOs: AdminClubList = await actor.adminGetClubs(limit, offset);
    return clubDTOs;
  }

  async function getPlayers(
    playerStatus: PlayerStatus
  ): Promise<AdminPlayerList> {
    let playerDTOs: AdminPlayerList = await actor.adminGetPlayers(playerStatus);
    return playerDTOs;
  }

  async function getManagers(
    itemsPerPage: number,
    currentPage: number
  ): Promise<AdminProfileList> {
    const limit = itemsPerPage;
    const offset = (currentPage - 1) * limit;
    let managerDTOs: AdminProfileList = await actor.adminGetManagers(
      limit,
      offset
    );
    return managerDTOs;
  }

  return {
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
