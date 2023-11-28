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

  async function actorFromIdentity() {
    let unsubscribe: Unsubscriber;
    return new Promise<OptionIdentity>((resolve, reject) => {
      unsubscribe = authStore.subscribe((store) => {
        if (store.identity) {
          resolve(store.identity);
        }
      });
    }).then((identity) => {
      unsubscribe();
      return ActorFactory.createActor(
        idlFactory,
        process.env.OPENFPL_BACKEND_CANISTER_ID,
        identity
      );
    });
  }

  async function getValidatableFixtures(): Promise<any[]> {
    const identityActor = await actorFromIdentity();
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
      const identityActor = await actorFromIdentity();
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
