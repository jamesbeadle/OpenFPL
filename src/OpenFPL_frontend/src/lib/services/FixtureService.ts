import { authStore } from "$lib/stores/auth";
import type { OptionIdentity } from "$lib/types/Identity";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  DataCache,
  Fixture,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";
import { replacer } from "../../utils/Helpers";
export class FixtureService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  async actorFromIdentity() {
    const identity = await new Promise<OptionIdentity>((resolve, reject) => {
      const unsubscribe = authStore.subscribe((store) => {
        if (store.identity) {
          unsubscribe();
          resolve(store.identity);
        }
      });
    });

    return ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID,
      identity
    );
  }

  async updateFixturesData() {
    let category = "fixtures";
    const newHashValues: DataCache[] = await this.actor.getDataHashes();
    let liveHash = newHashValues.find((x) => x.category == category) ?? null;
    const localHash = localStorage.getItem(category);
    if (liveHash?.hash != localHash) {
      let updatedFixturesData = await this.actor.getFixtures();
      localStorage.setItem(
        "fixtures_data",
        JSON.stringify(updatedFixturesData, replacer)
      );
      localStorage.setItem(category, liveHash?.hash ?? "");
    }
  }

  async getFixtures(): Promise<Fixture[]> {
    const cachedFixturesData = localStorage.getItem("fixtures_data");

    let cachedFixtures: Fixture[];
    try {
      cachedFixtures = JSON.parse(cachedFixturesData || "[]");
    } catch (e) {
      cachedFixtures = [];
    }

    return cachedFixtures;
  }

  async getNextFixture(): Promise<any> {
    try {
      const allFixtures = await this.getFixtures();
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

  async fetchValidatableFixtures(): Promise<any> {
    try {
      const identityActor = await this.actorFromIdentity();
      const validatableFixtures = await identityActor.getValidatableFixtures();
      return validatableFixtures;
    } catch (error) {
      console.error("Error fetching total managers:", error);
      throw error;
    }
  }
}
