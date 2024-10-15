<script lang="ts">
  import { leagueStore } from "$lib/stores/league-store";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import { Modal, busyStore } from "@dfinity/gix-components";
  import type { FootballLeagueId } from "../../../../../../declarations/data_canister/data_canister.did";
  import { getImageURL } from "$lib/utils/helpers";
    import { storeManager } from "$lib/managers/store-manager";
  
  export let visible: boolean;
  export let closeModal: () => void;
  export let cancelModal: () => void;
  export let newLogo: string;
  export let leagueId: FootballLeagueId;
  let fileInput: HTMLInputElement;
  let selectedLogo: Blob | null = null;

  async function updateLogo() {
    busyStore.startBusy({
      initiator: "update-logo",
      text: "Updating league logo...",
    });
    try {
      if (selectedLogo != null) {

        const reader = new FileReader();
        reader.readAsArrayBuffer(selectedLogo);
        reader.onloadend = async () => {
          const arrayBuffer = reader.result as ArrayBuffer;
          const uint8Array = new Uint8Array(arrayBuffer);
          await leagueStore.updateLogo(leagueId, uint8Array);  
          await storeManager.syncStores();

          await closeModal();
          toastsShow({
            text: "League logo updated.",
            level: "success",
            duration: 2000,
          });
        };
      }
    } catch (error) {
      toastsError({
        msg: { text: "Error updating league logo." },
        err: error,
      });
      console.error("Error updating league logo:", error);
      cancelModal();
    } finally {
      busyStore.stopBusy("update-logo");
    }
  }

  function clickFileInput(event: Event) {
    event.preventDefault();
    fileInput.click();
  }

  function handleFileChange(event: Event) {
  const input = event.target as HTMLInputElement;
  if (input.files && input.files[0]) {
    const file = input.files[0];
    if (file.size > 500 * 1024) {
      alert("File size exceeds 500KB");
      return;
    }
    selectedLogo = file;

    // Update the preview of the logo with a temporary URL
    newLogo = URL.createObjectURL(file);
  }
}
</script>

<Modal {visible} on:nnsClose={cancelModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Update League Logo</h3>
      <button class="times-button" on:click={cancelModal}>&times;</button>
    </div>
    <form on:submit|preventDefault={updateLogo}>
      <div class="mt-4">
        <div class="group flex flex-col md:block">
          <img
            src={newLogo}
            alt="League Logo"
            class="w-full mb-1 rounded-lg"
          />

  
          <div class="file-upload-wrapper mt-4">
            <button class="btn-file-upload fpl-button" on:click={clickFileInput}>
              Upload Logo
            </button>
            <input
              type="file"
              id="profile-image"
              accept="image/*"
              bind:this={fileInput}
              on:change={handleFileChange}
              style="opacity: 0; position: absolute; left: 0; top: 0;"
            />
          </div>
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
          class="px-4 py-2 fpl-purple-btn"
          type="submit"
        >
          Update
        </button>
      </div>
    </form>
  </div>
</Modal>
