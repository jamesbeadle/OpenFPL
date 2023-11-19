import type { TeamStats } from "$lib/types/TeamStats";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { Fixture, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../../utils/Helpers";

type FixtureWithTeams = {
  fixture: Fixture;
  homeTeam: Team | undefined;
  awayTeam: Team | undefined;
};

export class FixtureService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  async getFixturesData(fixturesHash: string): Promise<Fixture[]> {
    const cachedHash = localStorage.getItem("fixtures_hash");
    const cachedFixturesData = localStorage.getItem("fixtures_data");

    let cachedFixtures: Fixture[];
    try {
      cachedFixtures = JSON.parse(cachedFixturesData || "[]");
    } catch (e) {
      cachedFixtures = [];
    }

    if (
      !fixturesHash ||
      fixturesHash.length === 0 ||
      cachedHash !== fixturesHash
    ) {
      return this.fetchAllFixtures(fixturesHash);
    } else {
      return cachedFixtures;
    }
  }

  private async fetchAllFixtures(fixturesHash: string) {
    try {
      const allFixturesData: Fixture[] = await this.actor.getFixtures();
      localStorage.setItem("fixtures_hash", fixturesHash);
      localStorage.setItem(
        "fixtures_data",
        JSON.stringify(allFixturesData, replacer)
      );
      return allFixturesData.sort((a, b) => a.gameweek - b.gameweek);
    } catch (error) {
      console.error("Error fetching all fixtures:", error);
      throw error;
    }
  }

  async getNextFixture(): Promise<any> {
    try {
      const fixturesHash = localStorage.getItem("fixtures_hash") ?? "";
      const allFixtures = await this.getFixturesData(fixturesHash);
      const now = new Date();
      const nextFixture = allFixtures.find(
        (fixture) => new Date(Number(fixture.kickOff) / 1000000) > now
      );
      return nextFixture;
    } catch (error) {
      console.error("Error fetching next fixture:", error);
      throw error;
    }
  }

  initTeamData(teamId: number, table: Record<number, TeamStats>, teams: Team[]) {
    if (!table[teamId]) {
      const team = teams.find(t => t.id === teamId);
      if (team) {
        table[teamId] = {
          ...team,
          played: 0,
          wins: 0,
          draws: 0,
          losses: 0,
          goalsFor: 0,
          goalsAgainst: 0,
          points: 0
        };
      }
    }
  }

  updateTableData(fixtures: FixtureWithTeams[], teams: Team[], selectedGameweek: number): TeamStats[] {
      let tempTable: Record<number, TeamStats> = {};

      teams.forEach(team => this.initTeamData(team.id, tempTable, teams));

      const relevantFixtures = fixtures.filter(fixture => fixture.fixture.status === 3 && fixture.fixture.gameweek <= selectedGameweek);

      relevantFixtures.forEach(({ fixture, homeTeam, awayTeam }) => {
        if (!homeTeam || !awayTeam) return;
    
        this.initTeamData(homeTeam.id, tempTable, teams);
        this.initTeamData(awayTeam.id, tempTable, teams);
            
        const homeStats = tempTable[homeTeam.id];
        const awayStats = tempTable[awayTeam.id];
    
        homeStats.played++;
        awayStats.played++;
    
        homeStats.goalsFor += fixture.homeGoals;
        homeStats.goalsAgainst += fixture.awayGoals;
        awayStats.goalsFor += fixture.awayGoals;
        awayStats.goalsAgainst += fixture.homeGoals;
    
        if (fixture.homeGoals > fixture.awayGoals) {
          homeStats.wins++;
          homeStats.points += 3;
          awayStats.losses++;
        } else if (fixture.homeGoals === fixture.awayGoals) {
          homeStats.draws++;
          awayStats.draws++;
          homeStats.points += 1;
          awayStats.points += 1;
        } else {
          awayStats.wins++;
          awayStats.points += 3;
          homeStats.losses++;
        }
      });

      
      return Object.values(tempTable).sort((a, b) => {
      const goalDiffA = a.goalsFor - a.goalsAgainst;
      const goalDiffB = b.goalsFor - b.goalsAgainst;

      if (b.points !== a.points) return b.points - a.points;
      if (goalDiffB !== goalDiffA) return goalDiffB - goalDiffA;
      if (b.goalsFor !== a.goalsFor) return b.goalsFor - a.goalsFor;
      return a.goalsAgainst - b.goalsAgainst;
    });
  };
}
