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
    limit: number,
    offset: number
  ): Promise<AdminWeeklyCanisterList> {
    let canisterDTOs: AdminWeeklyCanisterList =
      await actor.adminGetWeeklyCanisters(limit, offset);
    return canisterDTOs;
  }

  async function getMonthlyCanisters(
    limit: number,
    offset: number
  ): Promise<AdminMonthlyCanisterList> {
    let canisterDTOs: AdminMonthlyCanisterList =
      await actor.adminGetMonthlyCanisters(limit, offset);
    return canisterDTOs;
  }

  async function getSeasonCanisters(
    limit: number,
    offset: number
  ): Promise<AdminSeasonCanisterList> {
    let canisterDTOs: AdminSeasonCanisterList =
      await actor.adminGetSeasonCanisters(limit, offset);
    return canisterDTOs;
  }

  async function getProfilePictureCanisters(
    limit: number,
    offset: number
  ): Promise<AdminProfilePictureCanisterList> {
    let canisterDTOs: AdminProfilePictureCanisterList =
      await actor.adminGetProfileCanisters(limit, offset);
    return canisterDTOs;
  }

  async function getTimers(
    limit: number,
    offset: number
  ): Promise<AdminTimerList | undefined> {
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
    limit: number,
    offset: number
  ): Promise<AdminClubList> {
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
    limit: number,
    offset: number
  ): Promise<AdminProfileList> {
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
