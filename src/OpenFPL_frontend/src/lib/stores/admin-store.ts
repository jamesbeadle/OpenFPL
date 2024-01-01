import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  CanisterDTO,
  ClubDTO,
  FixtureDTO,
  PlayerDTO,
  ProfileDTO,
  TimerDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createAdminStore() {
  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function getCanisters(
    page: number
  ): Promise<CanisterDTO[] | undefined> {
    let canisterDTOs: CanisterDTO[] = (await actor.getAdminCanisters(
      page
    )) as CanisterDTO[];
    return canisterDTOs;
  }

  async function getTimers(page: number): Promise<TimerDTO[] | undefined> {
    let timerDTOs: TimerDTO[] = (await actor.getAdminCanisters(
      page
    )) as CanisterDTO[];
    return timerDTOs;
  }

  async function getFixtures(page: number): Promise<FixtureDTO[] | undefined> {
    let fixtureDTOs: FixtureDTO[] = (await actor.getAdminCanisters(
      page
    )) as CanisterDTO[];
    return fixtureDTOs;
  }

  async function getClubs(page: number): Promise<ClubDTO[] | undefined> {
    let clubDTOs: ClubDTO[] = (await actor.getAdminCanisters(
      page
    )) as CanisterDTO[];
    return clubDTOs;
  }

  async function getPlayers(page: number): Promise<PlayerDTO[] | undefined> {
    let playerDTOs: PlayerDTO[] = (await actor.getAdminCanisters(
      page
    )) as CanisterDTO[];
    return playerDTOs;
  }

  async function getManagers(page: number): Promise<ProfileDTO[] | undefined> {
    let managerDTOs: ProfileDTO[] = (await actor.getAdminCanisters(
      page
    )) as CanisterDTO[];
    return managerDTOs;
  }

  return {
    getCanisters,
    getTimers,
    getFixtures,
    getClubs,
    getPlayers,
    getManagers,
  };
}

export const adminStore = createAdminStore();
