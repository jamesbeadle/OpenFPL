import type { OptionIdentity } from "$lib/types/Identity";
import { idlFactory } from "../../../../declarations/OpenFPL_backend";
import { ActorFactory } from "../../utils/ActorFactory";
import { authStore } from "$lib/stores/auth";
import type { Unsubscriber } from 'svelte/store';

export class UserService {
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
        unsubscribe  = authStore.subscribe(store => {
            console.log("store")
            console.log(store)
        if (store.identity) {
          resolve(store.identity);
        }
      });
    }).then((identity) => {
      unsubscribe();
      console.log("identity")
      console.log(identity)
      return ActorFactory.createActor(
        idlFactory,
        process.env.OPENFPL_BACKEND_CANISTER_ID,
        identity
      );
    });
  }
  
  
  async updateUsername(username: string): Promise<any> {
    try {
      const identityActor = await this.actorFromIdentity();
      const result = await identityActor.updateDisplayName(username);
      console.log("result")
      console.log(result)
      return result;
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }
}
