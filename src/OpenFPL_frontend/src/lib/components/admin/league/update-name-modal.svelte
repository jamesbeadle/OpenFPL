<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import { toastsError, toastsShow } from "$lib/stores/toasts-store";
    import { Modal, busyStore } from "@dfinity/gix-components";
    import type { FootballLeagueId } from "../../../../../../declarations/data_canister/data_canister.did";
  
    export let visible: boolean;
    export let closeModal: () => void;
    export let cancelModal: () => void;
    export let newName: string;
    export let leagueId: FootballLeagueId;
  
    async function updateName() {
      busyStore.startBusy({
        initiator: "update-name",
        text: "Updating league name...",
      });
      try {
        await leagueStore.updateName(leagueId, newName);
        await closeModal();
        toastsShow({
          text: "League name updated.",
          level: "success",
          duration: 2000,
        });
      } catch (error) {
        toastsError({
          msg: { text: "Error updating league name." },
          err: error,
        });
        console.error("Error updating league name:", error);
        cancelModal();
      } finally {
        busyStore.stopBusy("update-name");
      }
    }
  </script>
  
  <Modal {visible} on:nnsClose={cancelModal}>
    <div class="mx-4 p-4">
      <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Update League Name</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
      </div>
      <form on:submit|preventDefault={updateName}>
        <div class="mt-4">
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="New League Name"
            bind:value={newName}
          />
        </div>
        <div class="items-center py-3 flex space-x-4 flex-row">
          <button
            class="px-4 py-2 default-button fpl-cancel-btn"
            type="button"
            on:click={cancelModal}
          >
            Cancel
          </button>
          <button
            class={`px-4 py-2 fpl-purple-btn`}
            type="submit"
          >
            Update
          </button>
        </div>
      </form>
    </div>
  </Modal>
  