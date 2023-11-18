import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

export class TeamService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  public getEmpty(): Team {
    return {
      id: 0,
      name: "-",
      primaryColourHex: "#FFFFFF",
      secondaryColourHex: "#FFFFFF",
      thirdColourHex: "#FFFFFF",
      friendlyName: "",
      abbreviatedName: "-",
      shirtType: 0,
    };
  }

  async getTeamsData(teamsHash: string): Promise<Team[]> {
    const cachedHash = localStorage.getItem("teams_hash");
    const cachedTeamsData = localStorage.getItem("teams_data");
    const cachedTeams = JSON.parse(cachedTeamsData || "[]") as Team[];
    if (!teamsHash || teamsHash.length === 0 || cachedHash !== teamsHash) {
      return this.fetchAllTeams(teamsHash);
    } else {
      return cachedTeams;
    }
  }

  private async fetchAllTeams(teamsHash: string): Promise<Team[]> {
    try {
      const allTeamsData: Team[] = await this.actor.getTeams();
      localStorage.setItem("teams_hash", teamsHash);
      localStorage.setItem("teams_data", JSON.stringify(allTeamsData));
      return allTeamsData;
    } catch (error) {
      console.error("Error fetching all teams:", error);
      throw error;
    }
  }

  async getTeamById(id: number): Promise<Team | undefined> {
    const teamsHash = localStorage.getItem("teams_hash") ?? "";
    const teams = await this.getTeamsData(teamsHash);
    return teams.find((team) => team.id === id);
  }
}
