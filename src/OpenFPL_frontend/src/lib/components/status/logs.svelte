<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";
    import type { EventLogEntryType, GetSystemLogDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    let isLoading = true;
    let systemLog: GetSystemLogDTO;
    let filterCategory = 0;
    let currentPage = 1;
    const pageSize = 10;


    onMount(async () => {
      try{
        await systemStore.sync();
        
        let dto: GetSystemLogDTO = {
            totalEntries: 0n,
            offset: 0n,
            limit: 0n,
            entries: [],
            eventType: { "CanisterTopup" : null },
            dateEnd: 0n,
            dateStart: 0n
        };

        let logs_result = await systemStore.getLogs(dto);
        if(!logs_result){
            return;
        };

        systemLog = logs_result;

      } catch (error){
        console.error("Error fetching system logs.")
      } finally {
        isLoading = false;
      };
    });

    $: { if (filterCategory !== -1) {
            filterLogs();
            currentPage = 1;
        }
    }

    async function filterLogs() {
        var logFilterType: EventLogEntryType = { "CanisterTopup" : null };
        switch(currentPage){
            case 0:
                logFilterType = { "ManagerCanisterCreated" : null }
                break;
            case 1:
                logFilterType = { "UnexpectedError" : null }
                break;
            case 2:
                logFilterType = { "CanisterTopup" : null }
                break;
        }
            
        const limit = pageSize;
        const offset = (currentPage - 1) * limit;
        let dto: GetSystemLogDTO = {
            totalEntries: 0n,
            offset: BigInt(offset),
            limit: BigInt(limit),
            entries: [],
            eventType: logFilterType,
            dateEnd: 0n,
            dateStart: 0n
        };
        let result = await systemStore.getLogs(dto); 
        if(result){
            systemLog = result;
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
                <p>{log.eventTime}</p>
                <p>{log.eventDetail}</p>
            </div>
        {/each}
    </div>
{/if}