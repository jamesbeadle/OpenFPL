<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";
    import type { GetTopupsDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    let isLoading = true;
    let topups: GetTopupsDTO;
    let currentPage = 1;
    let itemsPerPage = 25;
    let totalPages: number = 0;

    $: if (topups && topups.totalEntries) {
        totalPages = Math.ceil(Number(topups.totalEntries) / itemsPerPage);
    }


    onMount(async () => {
      try{
        await systemStore.sync();

        let topups_result = await systemStore.getTopups(currentPage, itemsPerPage);
        if(!topups_result){
            return;
        };

        topups = topups_result;

      } catch (error){
        console.error("Error fetching topup information.")
      } finally {
        isLoading = false;
      };
    });

    function changePage(delta: number) {
        currentPage = Math.max(1, Math.min(totalPages, currentPage + delta));
        loadTopups();
    }

    async function loadTopups(){

      try{
            isLoading = true;
            let topups_result = await systemStore.getTopups(currentPage, itemsPerPage);
            if(!topups_result){
                return;
            };

            topups = topups_result;

        } catch (error) {
            console.error("Error fetching canister information.")
        } finally {
            isLoading = true;
        }
    };

</script>
{#if isLoading}
    <LocalSpinner />
{:else}
    <div class="p-4">
        {#each topups.entries as topup}
            <div class="flex flex-col">
                <p>{topup.canisterId}</p>
                <p>{topup.toppedUpOn}</p>
                <p>{topup.topupAmount}</p>
            </div>
        {/each}
    </div>
    
    <div class="flex justify-center items-center mt-4 mb-4">
      <button
        on:click={() => changePage(-1)}
        disabled={currentPage === 1}
        class={`${currentPage === 1 ? "bg-gray-500" : "fpl-button"}
        disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
      >
        Previous
      </button>

      <span class="px-4">Page {currentPage}</span>

      <button
        on:click={() => changePage(1)}
        disabled={currentPage >= totalPages}
        class={`${
          currentPage === $systemStore?.calculationGameweek
            ? "bg-gray-500"
            : "fpl-button"
        } 
          disabled:bg-gray-400 disabled:text-gray-700 disabled:cursor-not-allowed min-w-[100px] default-button`}
      >
        Next
      </button>
    </div>

{/if}