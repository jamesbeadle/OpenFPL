<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import { toastsError, toastsShow } from "$lib/stores/toasts-store";
    import { Modal, busyStore } from "@dfinity/gix-components";
    import type { FootballLeagueId } from "../../../../../../declarations/data_canister/data_canister.did";
  
    export let visible: boolean;
    export let closeModal: () => void;
    export let cancelModal: () => void;
    export let newAbbreviatedName: string;
    export let leagueId: FootballLeagueId;
  
    async function updateAbbreviatedName() {
      busyStore.startBusy({
        initiator: "update-name",
        text: "Updating league name...",
      });
      try {
        await leagueStore.updateAbbreviatedName(leagueId, newAbbreviatedName);
        await closeModal();
        toastsShow({
          text: "Abbreviated league name updated.",
          level: "success",
          duration: 2000,
        });
      } catch (error) {
        toastsError({
          msg: { text: "Error updating abbreviated league name." },
          err: error,
        });
        console.error("Error updating abbreviated league name:", error);
        cancelModal();
      } finally {
        busyStore.stopBusy("update-abbreviated-name");
      }
    }
  </script>
  
  <Modal {visible} on:nnsClose={cancelModal}>
    <div class="mx-4 p-4">
      <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Update Abbreviated League Name</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
      </div>
      <form on:submit|preventDefault={updateAbbreviatedName}>
        <div class="mt-4">
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="New Abbreviated League Name"
            bind:value={newAbbreviatedName}
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
  