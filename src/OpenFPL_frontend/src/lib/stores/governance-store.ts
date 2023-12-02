import { authStore } from "$lib/stores/auth";
import { writable } from "svelte/store";
import type {
  Fixture,
  PlayerEventData,
} from "../../../../declarations/player_canister/player_canister.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createGovernanceStore() {
  const { subscribe, set } = writable<Fixture[]>([]);

  async function submitFixtureData(
    fixtureId: number,
    allPlayerEvents: PlayerEventData[]
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      await identityActor.savePlayerEvents(fixtureId, allPlayerEvents);
      // Additional logic if needed after submission
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  return {
    subscribe,
    submitFixtureData,
  };
}

export const governanceStore = createGovernanceStore();
