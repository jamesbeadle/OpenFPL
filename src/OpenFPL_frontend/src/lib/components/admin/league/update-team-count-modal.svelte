<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import { toastsError, toastsShow } from "$lib/stores/toasts-store";
    import { Modal, busyStore } from "@dfinity/gix-components";
    import type { FootballLeagueId } from "../../../../../../declarations/data_canister/data_canister.did";
  
    export let visible: boolean;
    export let closeModal: () => void;
    export let cancelModal: () => void;
    export let newTeamCount: number;
    export let leagueId: FootballLeagueId;
  
    async function updateName() {
      busyStore.startBusy({
        initiator: "update-team-count",
        text: "Updating team count...",
      });
      try {
        await leagueStore.updateTeamCount(leagueId, newTeamCount);
        await closeModal();
        toastsShow({
          text: "League team count updated.",
          level: "success",
          duration: 2000,
        });
      } catch (error) {
        toastsError({
          msg: { text: "Error updating league team count." },
          err: error,
        });
        console.error("Error updating league team count:", error);
        cancelModal();
      } finally {
        busyStore.stopBusy("update-team-count");
      }
    }
  </script>
  
  <Modal {visible} on:nnsClose={cancelModal}>
    <div class="mx-4 p-4">
      <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Update League Team Count</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
      </div>
      <form on:submit|preventDefault={updateName}>
        <div class="mt-4">
          <input
            type="number"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="New League Name"
            bind:value={newTeamCount}
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
  