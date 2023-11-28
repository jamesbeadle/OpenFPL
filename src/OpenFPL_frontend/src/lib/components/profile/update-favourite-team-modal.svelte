<script lang="ts">
  import { onMount } from "svelte";
  import { UserService } from "$lib/services/UserService";
  import type { Team } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { TeamService } from "$lib/services/TeamService";
    import { toastStore } from "$lib/stores/toast";

  export let showModal: boolean;
  export let closeModal: () => void;
  export let newFavouriteTeam: number;

  let teams: Team[];


  onMount(async () => {
    try {
      let teamService = new TeamService();
      teams = await teamService.getTeams();
    } catch (error) {
      toastStore.show("Error fetching teams.", "error");
      console.error("Error fetching data:", error);
    }
  });

  async function updateFavouriteTeam() {
    let userService = new UserService();
    await userService.updateFavouriteTeam(newFavouriteTeam);
    closeModal();
  }

  function handleKeydown(event: KeyboardEvent): void {
    if (!(event.target instanceof HTMLInputElement) && event.key === "Escape") {
      closeModal();
    }
  }
</script>

<style>
  .modal-backdrop {
    z-index: 1000;
  }
</style>

{#if showModal}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={closeModal}
    on:keydown={handleKeydown}>
    <div class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white" 
      on:click|stopPropagation
      on:keydown={handleKeydown}>
      <div class="mt-3 text-center">
        <h3 class="text-lg leading-6 font-medium mb-2">Update Favourite Team</h3>
        <div class="w-full border border-gray-500 mt-4 mb-2">
          <select bind:value={newFavouriteTeam} class="w-full p-2 rounded-md fpl-dropdown">
            <option value={0}>Select Team</option>
            {#each teams as team}
              <option value={team.id}>{team.friendlyName}</option>
            {/each}
          </select>
        </div>
      </div>

      <div
        class="bg-orange-100 border-l-4 border-orange-500 text-orange-700 p-4 mb-1 mt-4"
        role="alert">
        <p class="font-bold text-sm">Warning</p>
        <p class="font-bold text-xs">
          You can only set your favourite team once per season.
        </p>
      </div>

      <div class="items-center py-3 flex space-x-4">
        <button
          class="px-4 py-2 fpl-cancel-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300"
          on:click={closeModal}>
          Cancel
        </button>
        <button
          class={`px-4 py-2 fpl-purple-btn text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
          on:click={updateFavouriteTeam}>
          Use
        </button>
      </div>
    </div>
  </div>
{/if}
 