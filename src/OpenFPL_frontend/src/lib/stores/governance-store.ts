import { authStore } from "$lib/stores/auth.store";
import type { PlayerEventData } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createGovernanceStore() {
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
      //TODO: Add in admin fixture submission logic
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  return {
    submitFixtureData,
  };
}

export const governanceStore = createGovernanceStore();
