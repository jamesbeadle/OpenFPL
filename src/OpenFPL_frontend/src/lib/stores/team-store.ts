import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  ClubDTO,
  DataCacheDTO,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createTeamStore() {
  const { subscribe, set } = writable<ClubDTO[]>([]);

  let actor: any = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    const category = "teams";
    const newHashValues: DataCacheDTO[] =
      (await actor.getDataHashes()) as DataCacheDTO[];
    const liveTeamsHash =
      newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);

    if (liveTeamsHash?.hash != localHash) {
      const updatedTeamsData = (await actor.getTeams()) as ClubDTO[];
      localStorage.setItem(
        "teams_data",
        JSON.stringify(updatedTeamsData, replacer)
      );
      localStorage.setItem(category, liveTeamsHash?.hash ?? "");
      set(updatedTeamsData);
    } else {
      const cachedTeamsData = localStorage.getItem("teams_data");
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

  return {
    subscribe,
    sync,
    getTeamById,
  };
}

export const teamStore = createTeamStore();
