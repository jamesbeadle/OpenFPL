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
        msg: { text: "Error updating system state." },
        err: error,
      });
      console.error("Error updating system state:", error);
      cancelModal();
    } finally {
      isLoading = false;
    }
  }
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="bg-gray-900 p-4">
    <div class="mt-3">
      <h3 class="text-lg leading-6 font-medium mb-2">Snapshot Fantasy Teams</h3>

      <p>Are you sure you want to snapshot the fantasy teams?</p>

      <button class={`px-4 py-2 ${ !$authIsAdmin ? "bg-gray-500" : "fpl-purple-btn" } 
        text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
        on:click={snapshotFantasyTeams} disabled={!$authIsAdmin}>
        Update
      </button>
    </div>
  </div>
</Modal>
