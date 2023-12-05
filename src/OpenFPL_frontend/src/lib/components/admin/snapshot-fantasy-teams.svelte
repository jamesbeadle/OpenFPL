<script lang="ts">
  import { authIsAdmin } from "$lib/derived/auth.derived";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { Modal } from "@dfinity/gix-components";

  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;

  let isLoading = true;

  async function snapshotFantasyTeams() {
    isLoading = true;
    try {
      await managerStore.snapshotFantasyTeams();
      await closeModal();
      toastsShow({
        text: "Snapshot Complete.",
        level: "success",
        duration: 2000,
      });
    } catch (error) {
      toastsError({
        msg: { text: "Error snapshotting fantasy teams." },
        err: error,
      });
      console.error("Error snapshotting fantasy teams:", error);
      cancelModal();
    } finally {
      isLoading = false;
    }
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="text-xl font-semibold text-white">Snapshot Fantasy Teams</h3>
      <button class="text-white text-3xl" on:click={cancelModal}
        >&times;</button
      >
    </div>

    <p>Are you sure you want to snapshot the fantasy teams?</p>

    <button
      class={`px-4 py-2 ${!$authIsAdmin ? "bg-gray-500" : "fpl-purple-btn"} 
      text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
      on:click={snapshotFantasyTeams}
      disabled={!$authIsAdmin}
    >
      Update
    </button>
  </div>
</Modal>
