<script lang="ts">
  import { onMount } from "svelte";
  import { UserService } from "$lib/services/UserService";
  import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { TeamService } from "$lib/services/TeamService";

  export let showModal: boolean;
  export let closeModal: () => void;
  export let newFavouriteTeam: number;

  let teams: Team[];


  onMount(async () => {
    try {
      let teamService = new TeamService();
      teams = await teamService.getTeams();
    } catch (error) {
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
        <h3 class="text-lg leading-6 font-medium">Update Favourite Team</h3>
        <form on:submit|preventDefault={updateFavouriteTeam}>
          <div class="mt-4">
            <select class="p-2 fpl-dropdown text-sm md:text-xl" bind:value={newFavouriteTeam}>
              <option value={0}>Select</option>
              {#each teams as team}
                <option value={team.id}>{team.name}</option>
              {/each}
            </select>
          </div>
          <div class="mt-4">
            <button type="submit" class="px-4 py-2 bg-blue-500 hover:bg-blue-700 rounded-md text-white">Update</button>
          </div>
        </form>
      </div>
    </div>
  </div>
{/if}
