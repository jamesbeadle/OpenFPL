<script lang="ts">
    import { leagueStore } from "$lib/stores/league-store";
    import { toastsError, toastsShow } from "$lib/stores/toasts-store";
    import { Modal, busyStore } from "@dfinity/gix-components";
    import type { CountryId, FootballLeagueId } from "../../../../../../declarations/data_canister/data_canister.did";
    import { countryStore } from "$lib/stores/country-store";
  
    export let visible: boolean;
    export let closeModal: () => void;
    export let cancelModal: () => void;
    export let newCountryId: CountryId;
    export let leagueId: FootballLeagueId;
  
    async function updateCountry() {
      busyStore.startBusy({
        initiator: "update-country",
        text: "Updating league country...",
      });
      try {
        await leagueStore.updateCountryId(leagueId, newCountryId);
        await closeModal();
        toastsShow({
          text: "league country updated.",
          level: "success",
          duration: 2000,
        });
      } catch (error) {
        toastsError({
          msg: { text: "Error updating league country." },
          err: error,
        });
        console.error("Error updating league country:", error);
        cancelModal();
      } finally {
        busyStore.stopBusy("update-country");
      }
    }
  </script>
  
  <Modal {visible} on:nnsClose={cancelModal}>
    <div class="mx-4 p-4">
      <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Update League Country</h3>
        <button class="times-button" on:click={cancelModal}>&times;</button>
      </div>
      <form on:submit|preventDefault={updateCountry}>
        <div class="mt-4">
         <select
            class="p-2 fpl-dropdown min-w-[100px] mb-2"
            bind:value={newCountryId}
          >
            <option value={0}>Select Country:</option>
            {#each $countryStore as country}
              <option value={country.id}>{country.name}</option>
            {/each}
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
          >
            Update
          </button>
        </div>
      </form>
    </div>
  </Modal>
  