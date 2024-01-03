<script lang="ts">
    import { onMount } from "svelte";
    import { Modal } from "@dfinity/gix-components";
    import { toastsError } from "$lib/stores/toasts-store";
    import { teamStore } from "$lib/stores/team-store";
    import type { ClubDTO } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let visible: boolean;
    export let closeDetailModal: () => void;

    let formerClubs: ClubDTO[] = [];
    let selectedClubId: number = -1;
    let isLoading = true;

    $: isSubmitDisabled = selectedClubId <= 0;
   
  onMount(async () => {
    try {
        await teamStore.sync();
        formerClubs = await teamStore.getFormerClubs();
    } catch (error) {
      toastsError({
        msg: { text: "Error syncing club details." },
        err: error,
      });
      console.error("Error syncing club details.", error);
    } finally {
      isLoading = false;
    }
  });

</script>

<Modal {visible} on:nnsClose={closeDetailModal}>
    <div class="p-4">
        <div class="flex justify-between items-center my-2">
        <h3 class="default-header">Promote Former Club</h3>
        <button class="times-button" on:click={closeDetailModal}>&times;</button>
        </div>

        <div class="flex justify-start items-center w-full">
            <div class="ml-4">
                <select
                    class="p-2 fpl-dropdown mx-0 md:mx-2 min-w-[100px]"
                    bind:value={selectedClubId}
                >
                    <option value={-1}>Select</option>
                    {#each formerClubs as club}
                        <option value={club.id}>{club.friendlyName}</option>
                    {/each}
                </select>
                <button
                  class={`px-4 py-2 ${
                    isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"
                  } default-button fpl-purple-btn`}
                  type="submit"
                  disabled={isSubmitDisabled}
                >
                  Submit Proposal
                </button>
            </div>
        </div>
    </div>
</Modal>
