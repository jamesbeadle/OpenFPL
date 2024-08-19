<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";
    import type { EventLogEntryType, GetSystemLogDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { formatUnixDateTimeToReadable } from "$lib/utils/helpers";
    
    let isLoading = true;
    let systemLog: GetSystemLogDTO;
    let filterCategory = 0;
    let currentPage = 1;
    let itemsPerPage = 25;

    onMount(async () => {
        await systemStore.sync();
        await loadLogs();
    });

    $: { if (filterCategory !== -1) {
            loadLogs();
            currentPage = 1;
        }
    }

    async function loadLogs() {

        try{
            isLoading = true;
            var logFilterType: EventLogEntryType = { "SystemCheck" : null };
            switch(filterCategory){
                case 0:
                    logFilterType = { "SystemCheck" : null }
                    break;
                case 1:
                    logFilterType = { "ManagerCanisterCreated" : null }
                    break;
                case 2:
                    logFilterType = { "UnexpectedError" : null }
                    break;
                case 3:
                    logFilterType = { "CanisterTopup" : null }
                    break;
            }
            
            let result = await systemStore.getLogs(currentPage, itemsPerPage, logFilterType); 
            if(result){
                systemLog = result;
            }
        } catch (error) {
            console.error("Error fetching log information.")
        } finally {
            isLoading = false;
        }
    }
</script>
{#if isLoading}
    <LocalSpinner />
{:else}
    <div>
        <label for="filterCategory">Filter by Log Type:</label>
        <select
        id="filterCategory"
        class="mt-1 block w-full py-2 text-white fpl-dropdown"
        bind:value={filterCategory}
        >
            <option value={0}>Manager Canister Created</option>
            <option value={1}>Unexpected Error</option>
            <option value={2}>Canister Topped Up</option>
        </select>
    </div>
    <div class="p-4">
        {#each systemLog.entries as log}
            <div class="flex flex-col">
                <p>{log.eventId}</p>
                <p>{log.eventTitle}</p>
                <p>{formatUnixDateTimeToReadable(log.eventTime)}</p>
                <p>{log.eventDetail}</p>
            </div>
        {/each}
    </div>
{/if}