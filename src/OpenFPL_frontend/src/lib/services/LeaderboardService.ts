
import { ActorFactory } from "../../utils/ActorFactory";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { FantasyTeamSnapshot } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class LeaderboardService {
    private actor: any;

    constructor() {
        this.actor = ActorFactory.createActor(idlFactory, process.env.OPENFPL_BACKEND_CANISTER_ID);
    }

    async getWeeklyLeaderboardData(weeklyLeaderboardHash: string) {
      const cachedHash = localStorage.getItem('weekly_leaderboard_hash');
      const cachedLeaderboardData = localStorage.getItem('weekly_leaderboard_data');
      const cachedLeaderboard = JSON.parse(cachedLeaderboardData || '[]');
  
      if (!weeklyLeaderboardHash || weeklyLeaderboardHash.length === 0 || cachedHash !== weeklyLeaderboardHash) {
        return this.fetchWeeklyLeaderboard(weeklyLeaderboardHash);
      } else {
        return cachedLeaderboard;
      }
    }

    async getLeadingWeeklyTeam() : Promise<FantasyTeamSnapshot> {
      let weeklyLeaderboard = await this.getWeeklyLeaderboardData(localStorage.getItem('weekly_leaderboard_hash') ?? '');
      return weeklyLeaderboard[0];
    }
  
    private async fetchWeeklyLeaderboard(weeklyLeaderboardHash: string) {
      try {
        const weeklyLeaderboardData = await this.actor.getWeeklyLeaderboard();
        localStorage.setItem('weekly_leaderboard_hash', weeklyLeaderboardHash);
        localStorage.setItem('weekly_leaderboard_data', JSON.stringify(weeklyLeaderboardData));
        return weeklyLeaderboardData;
      } catch (error) {
        console.error("Error fetching weekly leaderboard:", error);
        throw error;
      }
    }
  }
  