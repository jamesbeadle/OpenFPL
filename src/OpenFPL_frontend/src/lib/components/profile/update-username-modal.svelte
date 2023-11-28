<script lang="ts">
  export let showModal: boolean;
  export let closeModal: () => void;
  export let newUsername: string;
  import { UserService } from "$lib/services/UserService";
  import { toastStore } from "$lib/stores/toast";
  import { isLoading } from '$lib/stores/global-stores';


  async function updateUsername() {
    isLoading.set(true);
    try{      
      let userService = new UserService();
      await userService.updateUsername(newUsername);
    }
    catch(error){
      toastStore.show("Error updating username." ,"error");
      console.error("Error updating username:" ,error);
    }
    isLoading.set(true);
    closeModal();
  }

  function handleKeydown(event: KeyboardEvent): void {
    if (!(event.target instanceof HTMLInputElement) && event.key === "Escape") {
      closeModal();
    }
  }
</script>

{#if showModal}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={closeModal}
    on:keydown={handleKeydown}>
    <div
      class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
      on:click|stopPropagation
      on:keydown={handleKeydown}>
      <div class="mt-3 text-center">
        <h3 class="text-lg leading-6 font-medium">Update Username</h3>
        <form on:submit|preventDefault={updateUsername}>
          <div class="mt-4">
            <input
              type="text"
              class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
              placeholder="New Username"
              bind:value={newUsername}
            />
          </div>
          <div class="mt-4">
            <button
              type="submit"
              class="px-4 py-2 bg-blue-500 hover:bg-blue-700 rounded-md text-white"
              >Update</button
            >
          </div>
        </form>
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-backdrop {
    z-index: 1000;
  }
</style>
