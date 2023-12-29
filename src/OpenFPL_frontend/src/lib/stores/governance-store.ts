import { authStore } from "$lib/stores/auth.store";
import { writable } from "svelte/store";
import type {
  FixtureDTO,
  PlayerEventData,
} from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createGovernanceStore() {
  const { subscribe, set } = writable<FixtureDTO[]>([]);

  async function submitFixtureData(
    fixtureId: number,
    allPlayerEvents: PlayerEventData[]
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(
        authStore,
        process.env.OPENFPL_BACKEND_CANISTER_ID ?? ""
      );
      let result = await identityActor.savePlayerEvents(
        fixtureId,
        allPlayerEvents
      );
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
