<script lang="ts">
    import { toastsError, toastsShow } from "$lib/stores/toasts-store";
    import { Modal, busyStore } from "@dfinity/gix-components";
    import type { CreateLeagueDTO } from "../../../../../../declarations/data_canister/data_canister.did";
    import { LeagueService } from "$lib/services/league-service";
    import { countryStore } from "$lib/stores/country-store";
    
    export let visible: boolean;
    export let closeModal: () => void;
    export let cancelModal: () => void;
    
    let newLeagueName = "";
    let newAbbreviatedName = "";
    let governingBody = "";
    let gender = 1; // Default to male
    let dateFormed = "";
    let countryId = 0;
    let logo: Blob | null = null;
    let fileInput: HTMLInputElement;
    let teamCount: 0;
  
    async function addNewLeague() {
      if (!newLeagueName || !newAbbreviatedName || !governingBody || !dateFormed || !countryId) {
        toastsError({
          msg: { text: "All fields are required." }
        });
        return;
      }
  
      busyStore.startBusy({
        initiator: "add-league",
        text: "Adding new league..."
      });
  
      try {
        const newLeague: CreateLeagueDTO = {
          name: newLeagueName,
          abbreviation: newAbbreviatedName,
          governingBody,
          relatedGender: gender === 1 ? { Male: null } : { Female: null },
          formed: BigInt(new Date(dateFormed).getTime() * 1_000_000),
          countryId,
          logo: logo ? await convertFileToUint8Array(logo) : [],
          teamCount: teamCount
        };
  
        await new LeagueService().createLeague(newLeague);
        toastsShow({ text: "New league added successfully.", level: "success", duration: 2000 });
        await closeModal();
      } catch (error) {
        toastsError({
          msg: { text: "Error adding new league." },
          err: error
        });
        console.error("Error adding new league:", error);
        cancelModal();
      } finally {
        busyStore.stopBusy("add-league");
      }
    }
  
    function handleFileChange(event: Event) {
      const input = event.target as HTMLInputElement;
      if (input.files && input.files[0]) {
        const file = input.files[0];
        if (file.size > 500 * 1024) {
          alert("File size exceeds 500KB");
          return;
        }
        logo = file;
      }
    }
  
    function clickFileInput(event: Event) {
      event.preventDefault();
      fileInput.click();
    }
  
    function convertFileToUint8Array(file: Blob): Promise<Uint8Array> {
      return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onloadend = () => {
          if (reader.result) {
            resolve(new Uint8Array(reader.result as ArrayBuffer));
          } else {
            reject("Failed to read file");
          }
        };
        reader.readAsArrayBuffer(file);
      });
    }
  </script>
  
  <Modal {visible} on:nnsClose={cancelModal}>
    <div class="mx-4 p-4">
      <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Add New League</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
      </div>
      <form on:submit|preventDefault={addNewLeague}>
        <div class="mt-4">
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="League Name"
            bind:value={newLeagueName}
          />
          <input
            type="text"
            class="w-full mt-4 px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="Abbreviated Name"
            bind:value={newAbbreviatedName}
          />
          <input
            type="text"
            class="w-full mt-4 px-4 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-black"
            placeholder="Governing Body"
            bind:value={governingBody}
          />
          <div class="mt-4">
            <label for="gender">Gender</label>
            <select bind:value={gender} class="input input-bordered">
              <option value="1">Male</option>
              <option value="2">Female</option>
            </select>
          </div>
          <div class="mt-4">
            <label for="date-formed">Team Count</label>
            <input
              type="number"
              class="input input-bordered"
              bind:value={teamCount}
            />
          </div>
          <div class="mt-4">
            <label for="date-formed">Date Formed</label>
            <input
              type="date"
              class="input input-bordered"
              bind:value={dateFormed}
            />
          </div>
          <div class="mt-4">
            <label for="country">Country</label>
            <select
                class="p-2 fpl-dropdown min-w-[100px] mb-2"
                bind:value={countryId}
            >
                <option value={0}>Select League Country</option>
                {#each $countryStore as country}
                <option value={country.id}>{country.name}</option>
                {/each}
            </select>
          </div>
          <div class="mt-4">
            <label for="logo">Logo</label>
            <button class="btn-file-upload fpl-button" on:click={clickFileInput}>
              Upload Logo
            </button>
            <input
              type="file"
              id="logo-image"
              accept="image/*"
              bind:this={fileInput}
              on:change={handleFileChange}
              style="opacity: 0; position: absolute; left: 0; top: 0;"
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
          <button class="px-4 py-2 fpl-purple-btn" type="submit">
            Add League
          </button>
        </div>
      </form>
    </div>
  </Modal>
  