import { authStore } from "$lib/stores/auth";
import type { OptionIdentity } from "$lib/types/Identity";
import type { Unsubscriber } from "svelte/store";
import { writable } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type {
  Fixture,
  PlayerEventData,
} from "../../../../declarations/player_canister/player_canister.did";
import { ActorFactory } from "../../utils/ActorFactory";

function createGovernanceStore() {
  const { subscribe, set } = writable<Fixture[]>([]);

  async function getValidatableFixtures(): Promise<any[]> {
    const identityActor = await ActorFactory.createIdentityActor(authStore, process.env.OPENFPL_BACKEND_CANISTER_ID ?? "");
    const fixtures =
      (await identityActor.getValidatableFixtures()) as Fixture[];
    set(fixtures);
    return fixtures;
  }

  async function submitFixtureData(
    fixtureId: number,
    allPlayerEvents: PlayerEventData[]
  ): Promise<void> {
    try {
      const identityActor = await ActorFactory.createIdentityActor(authStore, process.env.OPENFPL_BACKEND_CANISTER_ID ?? "");
      await identityActor.submitFixtureData(fixtureId, allPlayerEvents);
      // Additional logic if needed after submission
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }

  return {
    subscribe,
    getValidatableFixtures,
    submitFixtureData,
  };
}

export const governanceStore = createGovernanceStore();
