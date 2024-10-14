<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import { toastsError, toastsShow } from "$lib/stores/toasts-store";
    import { Modal, busyStore } from "@dfinity/gix-components";
    import type { FootballLeagueId } from "../../../../../../declarations/data_canister/data_canister.did";
  
    export let visible: boolean;
    export let closeModal: () => void;
    export let cancelModal: () => void;
    export let newGender: number;
    export let leagueId: FootballLeagueId;
  
    async function updateGender() {
      busyStore.startBusy({
        initiator: "update-gender",
        text: "Updating league gender...",
      });
      try {
        await leagueStore.updateGender(leagueId, newGender == 1 ? { "Male" : null } : { "Female" : null});
        await closeModal();
        toastsShow({
          text: "League gender updated.",
          level: "success",
          duration: 2000,
        });
      } catch (error) {
        toastsError({
          msg: { text: "Error updating league gender." },
          err: error,
        });
        console.error("Error updating league gender:", error);
        cancelModal();
      } finally {
        busyStore.stopBusy("update-gender");
      }
    }
  </script>
  
  <Modal {visible} on:nnsClose={cancelModal}>
    <div class="mx-4 p-4">
      <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Update League Gender</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
      </div>
      <form on:submit|preventDefault={updateGender}>
        <div class="mt-4">
          <select
            class="p-2 fpl-dropdown min-w-[100px] mb-2"
            bind:value={newGender}
          >
            <option value={0}>Select Gender:</option>
            <option value={1}>Male</option>
            <option value={2}>Female</option>
          </select>
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
            disabled={newGender == 0}
          >
            Update
          </button>
        </div>
      </form>
    </div>
  </Modal>
  