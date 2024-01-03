import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  ClubDTO,
  DataCacheDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { isError, replacer } from "../utils/Helpers";

function createTeamStore() {
  const { subscribe, set } = writable<ClubDTO[]>([]);

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    const category = "teams";
    const newHashValues = await actor.getDataHashes();

    let error = isError(newHashValues);
    if (error) {
      console.error("Error syncing team store");
      return;
    }

    let dataCacheValues: DataCacheDTO[] = newHashValues.ok;

    let categoryHash =
      dataCacheValues.find((x: DataCacheDTO) => x.category === category) ??
      null;
    const localHash = localStorage.getItem(category);

    if (categoryHash?.hash != localHash) {
      const updatedTeamsData = await actor.getClubs();

      if (isError(updatedTeamsData)) {
        return [];
      }

      localStorage.setItem(
        category,
        JSON.stringify(updatedTeamsData.ok, replacer)
      );
      localStorage.setItem(`${category}_hash`, categoryHash?.hash ?? "");
      set(updatedTeamsData.ok);
    } else {
      const cachedTeamsData = localStorage.getItem(category);
      let cachedTeams: ClubDTO[] = [];
      try {
        cachedTeams = JSON.parse(cachedTeamsData || "[]");
      } catch (e) {
        cachedTeams = [];
      }
      set(cachedTeams);
    }
  }

  async function getTeamById(id: number): Promise<ClubDTO | undefined> {
    let teams: ClubDTO[] = [];
    subscribe((value) => {
      teams = value;
    })();
    return teams.find((team) => team.id === id);
  }

  async function getFormerClubs() : Promise<ClubDTO[]> {
    const formerClubsData = await actor.getFormerClubs();

    if (isError(formerClubsData)) {
      return [];
    }
    
   return formerClubsData.ok;
  }

  return {
    subscribe,
    sync,
    getTeamById,
    getFormerClubs
  };
}

export const teamStore = createTeamStore();
