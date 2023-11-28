import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { DataCache, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../utils/Helpers";

function createTeamStore() {
  const { subscribe, set } = writable<Team[]>([]);

  const actor = ActorFactory.createActor(
    idlFactory,
    process.env.OPENFPL_BACKEND_CANISTER_ID
  );

  async function sync() {
    const category = "teams";
    const newHashValues: DataCache[] =
      (await actor.getDataHashes()) as DataCache[];
    const liveTeamsHash =
      newHashValues.find((x) => x.category === category) ?? null;
    const localHash = localStorage.getItem(category);

    if (liveTeamsHash?.hash != localHash) {
      const updatedTeamsData = (await actor.getTeams()) as Team[];
      localStorage.setItem(
        "teams_data",
        JSON.stringify(updatedTeamsData, replacer)
      );
      localStorage.setItem(category, liveTeamsHash?.hash ?? "");
      set(updatedTeamsData);
    } else {
      const cachedTeamsData = localStorage.getItem("teams_data");
      let cachedTeams: Team[] = [];
      try {
        cachedTeams = JSON.parse(cachedTeamsData || "[]");
      } catch (e) {
        cachedTeams = [];
      }
      set(cachedTeams);
    }
  }

  async function getTeamById(id: number): Promise<Team | undefined> {
    let teams: Team[] = [];
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
