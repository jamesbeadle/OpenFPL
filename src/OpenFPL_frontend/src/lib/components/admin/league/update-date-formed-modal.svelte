<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import { toastsError, toastsShow } from "$lib/stores/toasts-store";
    import { Modal, busyStore } from "@dfinity/gix-components";
    import { convertDateInputToUnixNano } from "$lib/utils/helpers";
    import type { FootballLeagueId } from "../../../../../../declarations/data_canister/data_canister.did";
    
    export let visible: boolean;
    export let closeModal: () => void;
    export let cancelModal: () => void;
    export let newDateFormed: string;
    export let leagueId: FootballLeagueId;
  
    async function updateDateFormed() {
      busyStore.startBusy({
        initiator: "update-date-formed",
        text: "Updating league date formed...",
      });
      try {
        await leagueStore.updateDateFormed(leagueId, convertDateInputToUnixNano(newDateFormed));
        await closeModal();
        toastsShow({
          text: "league date formed updated.",
          level: "success",
          duration: 2000,
        });
      } catch (error) {
        toastsError({
          msg: { text: "Error updating league date formed." },
          err: error,
        });
        console.error("Error updating league date formed:", error);
        cancelModal();
      } finally {
        busyStore.stopBusy("update-date-formed");
      }
    }
  </script>
  
  <Modal {visible} on:nnsClose={cancelModal}>
    <div class="mx-4 p-4">
      <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Update League Date Formed</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
      </div>
      <form on:submit|preventDefault={updateDateFormed}>
        <div class="mt-4">
          <div class="flex-col space-y-2">
            <p>Formation Date:</p>
            <input
              type="date"
              bind:value={newDateFormed}
              class="input input-bordered"
            />
          </div>
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
  