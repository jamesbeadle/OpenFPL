<script lang="ts">
  import { onMount } from "svelte";
  import { adminStore } from "$lib/stores/admin-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import type { AdminProfileList } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { authStore } from "$lib/stores/auth.store";

  let managers: AdminProfileList | null;
  let currentPage = 1;
  let itemsPerPage = 25;
  let totalPages: number = 0;
  let isLoading = true;

  onMount(async () => {
    try {
      authStore.sync();
      await loadManagers();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching managers." },
        err: error,
      });
      console.error("Error fetching managers:", error);
    } finally {
      isLoading = false;
    }
  });

  async function changePage(delta: number) {
    currentPage = Math.max(1, Math.min(totalPages, currentPage + delta));
    await loadManagers();
  }

  async function loadManagers() {
    managers = await adminStore.getManagers(itemsPerPage, currentPage);
  }
</script>

{#if !isLoading}
  <div class="m-4">
    <div class="flex">
      <div class="w-1/4">
        <p>Principal Id</p>
      </div>
      <div class="w-1/4">
        <p>Username</p>
      </div>
      <div class="w-1/4">
        <p>Options</p>
      </div>
    </div>

    {#if managers}
      {#each managers.profiles as profile}
        <div class="flex">
          <div class="w-1/4">
            <p>{profile.principalId}</p>
          </div>
          <div class="w-1/4">
            <p>{profile.username}</p>
          </div>
          <div class="w-1/4">
            <p>...</p>
          </div>
        </div>
      {/each}
      {#if managers.profiles.length == 0}
        <p>No Managers Found</p>
      {/if}
    {/if}

    <div class="flex justify-center items-center mt-4 mb-4">
      <button
        on:click={() => changePage(-1)}
        disabled={currentPage === 1}
        class={`${currentPage === 1 ? "bg-gray-500" : "fpl-button"}
          disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
      >
        Previous
      </button>

      <span class="px-4">Page {currentPage}</span>

      <button
        on:click={() => changePage(1)}
        disabled={currentPage >= totalPages}
        class={`${currentPage >= totalPages ? "bg-gray-500" : "fpl-button"} 
            disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
      >
        Next
      </button>
    </div>
  </div>
{/if}
