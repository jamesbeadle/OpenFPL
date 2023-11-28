import { writable } from 'svelte/store';
import { authStore } from '$lib/stores/auth';
import type { OptionIdentity } from '$lib/types/Identity';
import { idlFactory } from 'path-to-idlFactory';
import { ActorFactory } from 'path-to-ActorFactory';

function createUserStore() {
  const { subscribe, set, update } = writable<any>(null); // Replace 'any' with the actual user type

  async function actorFromIdentity() {
    let unsubscribe;
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

  async function updateUsername(username: string): Promise<any> {
    try {
      const identityActor = await actorFromIdentity();
      const result = await identityActor.updateDisplayName(username);
      // Update the user store if necessary
      return result;
    } catch (error) {
      console.error("Error updating username:", error);
      throw error;
    }
  }

  async function updateFavouriteTeam(favouriteTeamId: number): Promise<any> {
    try {
      const identityActor = await actorFromIdentity();
      const result = await identityActor.updateFavouriteTeam(favouriteTeamId);
      // Update the user store if necessary
      return result;
    } catch (error) {
      console.error("Error updating favourite team:", error);
      throw error;
    }
  }

  async function getProfile(): Promise<any> {
    try {
      const identityActor = await actorFromIdentity();
      const result = await identityActor.getProfileDTO();
      set(result); // Set the user's profile in the store
      return result;
    } catch (error) {
      console.error("Error getting profile:", error);
      throw error;
    }
  }

  async function updateProfilePicture(picture: File): Promise<any> {
    // Implementation of updateProfilePicture
    // ...
  }

  return {
    subscribe,
    updateUsername,
    updateFavouriteTeam,
    getProfile,
    updateProfilePicture
    // Add any other methods as needed
  };
}

export const userStore = createUserStore();
