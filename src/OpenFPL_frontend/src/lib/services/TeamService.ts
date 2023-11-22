import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCache,
  Team,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../../utils/Helpers";

export class TeamService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  async updateTeamsData() {
    let category = "teams";
    const newHashValues: DataCache[] = await this.actor.getDataHashes();
    let liveTeamsHash =
      newHashValues.find((x) => x.category == category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveTeamsHash?.hash != localHash) {
      let updatedTeamsData = await this.actor.getTeams();
      localStorage.setItem(
        "teams_data",
        JSON.stringify(updatedTeamsData, replacer)
      );
      localStorage.setItem(category, liveTeamsHash?.hash ?? "");
    }
  }

  async getTeams(): Promise<Team[]> {
    const cachedTeamsData = localStorage.getItem("teams_data");

    let cachedTeams: Team[];
    try {
      cachedTeams = JSON.parse(cachedTeamsData || "[]");
    } catch (e) {
      cachedTeams = [];
    }

    return cachedTeams;
  }

  async getTeamById(id: number): Promise<Team | undefined> {
    const teams = await this.getTeams();
    return teams.find((team) => team.id === id);
  }
}
