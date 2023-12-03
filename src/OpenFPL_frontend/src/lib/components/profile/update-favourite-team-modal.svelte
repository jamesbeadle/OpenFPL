<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { teamStore } from "$lib/stores/team-store";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import type { Team } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { loadingText } from "$lib/stores/global-stores";
  import { Modal } from "@dfinity/gix-components";

  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  export let newFavouriteTeam: number = 0;
  export let isLoading: boolean;

  let isSubmitDisabled: boolean = true;
  $: isSubmitDisabled = newFavouriteTeam <= 0;

  let teams: Team[];

  let unsubscribeTeams: () => void;

  onMount(async () => {
    await userStore.sync();
    await teamStore.sync();
    unsubscribeTeams = teamStore.subscribe((value) => {
      teams = value;
    });
  });

  onDestroy(() => {
    unsubscribeTeams?.();
  });

  async function updateFavouriteTeam() {
    isLoading = true;
    loadingText.set("Updating Favourite Club");

    try {
      await userStore.updateFavouriteTeam(newFavouriteTeam);
      userStore.sync();
      await closeModal();
      toastsShow({
        text: "Favourite team updated.",
        level: "success",
        duration: 2000,
      });
    } catch (error) {
      toastsError({
        msg: { text: "Error updating favourite team." },
        err: error,
      });
      console.error("Error updating favourite team:", error);
      cancelModal();
    } finally {
      isLoading = false;
      loadingText.set("Loading");
    }
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="bg-gray-900 p-4">
    <h3 class="text-lg leading-6 font-medium mb-2">Update Favourite Team</h3>
    <div class="w-full border border-gray-500 mt-4 mb-2">
      <select
        bind:value={newFavouriteTeam}
        class="w-full p-2 rounded-md fpl-dropdown"
      >
        <option value={0}>Select Team</option>
        {#each teams as team}
          <option value={team.id}>{team.friendlyName}</option>
        {/each}
      </select>
    </div>

    <div
      class="bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-1 mt-4"
      role="alert"
    >
      <p class="font-bold text-sm">Warning</p>
      <p class="font-bold text-xs">
        You can only set your favourite team once per season.
      </p>
    </div>

    <div class="items-center py-3 flex space-x-4">
      <button
        class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
        on:click={cancelModal}
      >
        Cancel
      </button>
      <button
        class={`px-4 py-2 ${
          isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"
        } 
        text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
        on:click={updateFavouriteTeam}
        disabled={isSubmitDisabled}>Update</button
      >
    </div>
  </div>
</Modal>
