
import { ActorFactory } from "../../utils/ActorFactory";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { Fixture } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

export class FixtureService {
    private actor: any;

    constructor() {
        this.actor = ActorFactory.createActor(idlFactory, process.env.OPENFPL_BACKEND_CANISTER_ID);
    }

    async getFixturesData(fixturesHash: string) : Promise<[Fixture]> {
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

    async getNextFixture(): Promise<any> {
      try {
          const fixturesHash = localStorage.getItem('fixtures_hash') ?? '';
          const allFixtures = await this.getFixturesData(fixturesHash);

          const now = new Date();
          const nextFixture = allFixtures.find(fixture => new Date(Number(fixture.kickOff)) > now);

          return nextFixture;
      } catch (error) {
          console.error("Error fetching next fixture:", error);
          throw error;
      }
    }
  }
  