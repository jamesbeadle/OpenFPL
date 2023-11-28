import { authStore } from "$lib/stores/auth";
import type { OptionIdentity } from "$lib/types/Identity";
import type { Unsubscriber } from "svelte/store";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import type { PlayerEventData } from "../../../../declarations/player_canister/player_canister.did";
import { ActorFactory } from "../../utils/ActorFactory";

export class GovernanceService {
  private actor: any;

  constructor() {
    this.actor = ActorFactory.createActor(
      idlFactory,
      process.env.OPENFPL_BACKEND_CANISTER_ID
    );
  }

  async actorFromIdentity() {
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

  async getValidatableFixtures(): Promise<any> {
    const identityActor = await this.actorFromIdentity();
    const fixtures = await identityActor.getValidatableFixtures();
    return fixtures;
  }

  async submitFixtureData(
    fixtureId: number,
    allPlayerEvents: PlayerEventData[]
  ): Promise<any> {
    try {
      const identityActor = await this.actorFromIdentity();
      await identityActor.submitFixtureData(fixtureId, allPlayerEvents);
      return;
    } catch (error) {
      console.error("Error submitting fixture data:", error);
      throw error;
    }
  }
}
