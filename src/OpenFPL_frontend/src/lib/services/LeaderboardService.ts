
import { ActorFactory } from "../../utils/ActorFactory";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";

export class LeaderboardService {
    private actor: any;

    constructor() {
        this.actor = ActorFactory.createActor(idlFactory, process.env.OPENFPL_BACKEND_CANISTER_ID);
    }

    async getFixturesData(fixturesHash: string) {
      const cachedHash = localStorage.getItem('fixtures_hash');
      const cachedFixturesData = localStorage.getItem('fixtures_data');
      const cachedFixtures = JSON.parse(cachedFixturesData || '[]');
  
      if (!fixturesHash || fixturesHash.length === 0 || cachedHash !== fixturesHash) {
        return this.fetchAllFixtures(fixturesHash);
      } else {
        return cachedFixtures;
      }
    }
  
    private async fetchAllFixtures(fixturesHash: string) {
      try {
        const allFixturesData = await this.actor.getAllFixtures();
        localStorage.setItem('fixtures_hash', fixturesHash);
        localStorage.setItem('fixtures_data', JSON.stringify(allFixturesData));
        return allFixturesData;
      } catch (error) {
        console.error("Error fetching all fixtures:", error);
        throw error;
      }
    }
  }
  