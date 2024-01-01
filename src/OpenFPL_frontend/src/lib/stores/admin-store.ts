import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/Helpers";

function createAdminStore() {

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function getCanisters(page: number): Promise<CanisterDTO[] | undefined> {
    let canisterDTOs: CanisterDTO[] = [];
    subscribe((value) => {
      canisterDTOs = value;
    })();
    return canisterDTOs;
  }

  async function getTimers(page: number): Promise<TimerDTO[] | undefined> {
    let timerDTOs: TimerDTO[] = [];
    subscribe((value) => {
      timerDTOs = value;
    })();
    return timerDTOs;
  }

  async function getFixtures(page: number): Promise<FixtureDTO[] | undefined> {
    let fixtureDTOs: FixtureDTO[] = [];
    subscribe((value) => {
      fixtureDTOs = value;
    })();
    return fixtureDTOs;
  }

  async function getClubs(page: number): Promise<ClubDTO[] | undefined> {
    let clubDTOs: ClubDTO[] = [];
    subscribe((value) => {
      clubDTOs = value;
    })();
    return clubDTOs;
  }

  async function getPlayers(page: number): Promise<PlayerDTO[] | undefined> {
    let playerDTOs: PlayerDTO[] = [];
    subscribe((value) => {
      playerDTOs = value;
    })();
    return playerDTOs;
  }

  async function getManagers(page: number): Promise<ManagerDTO[] | undefined> {
    let managerDTOs: ManagerDTO[] = [];
    subscribe((value) => {
      managerDTOs = value;
    })();
    return managerDTOs;
  }

  return {
    getCanisters,
    getTimers,
    getFixtures,
    getClubs,
    getPlayers,
    getManagers
  };
}

export const adminStore = createAdminStore();
