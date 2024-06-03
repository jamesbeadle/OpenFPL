<script lang="ts">
    import { onMount } from "svelte";
    import Layout from "../Layout.svelte";
    import type { EventLogEntryType, GetSystemLogDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { systemStore } from "$lib/stores/system-store";
    import LocalSpinner from "$lib/components/local-spinner.svelte";
    
    let systemLog: GetSystemLogDTO | null = null;
    let startDate: string = "";
    let endDate: string = "";
    let eventType: EventLogEntryType | null = null;


    let currentPage = 1;
    let itemsPerPage = 25;
    let isLoading = true;

    let eventTypes: EventLogEntryType[] = [
        { 'SystemCheck' : null },
        { 'CyclesBalanceCheck' : null },
        { 'UnexpectedError' : null },
        { 'NewManagerCanisterCreated' : null },
        { 'TopupSent' : null }
    ];
  
    onMount(async () => {
      try{
        await systemStore.sync();

        let dto : GetSystemLogDTO = {
            dateEnd: 0n,
            offset: 0n,
            dateStart: 0n,
            limit: 0n,
            entries: [],
            eventType: [],
            totalEntries: 0n,
        };

        let result = await systemStore.getLogs(dto);
        if(result){
            systemLog = result;
        }

      } catch (error){
        console.error("Error fetching system logs.")
      } finally {
        isLoading = false;
      };
    });
  
    async function filterLogs() {
        isLoading = true;
        try{
            const limit = itemsPerPage;
            const offset = (currentPage - 1) * limit;

            let dto : GetSystemLogDTO = {
                dateEnd: 0n,
                offset: BigInt(offset),
                dateStart: 0n,
                limit: BigInt(limit),
                entries: [],
                eventType: eventType ? [eventType] : [],
                totalEntries: 0n,
            };

            let result = await systemStore.getLogs(dto);
            console.log(result)
            if(result){
                systemLog = result;
                return;
            }

            systemLog = null;
        } catch (error) {
            console.error("Error filtering logs:", error);
            systemLog = null;
        } finally {
            isLoading =  false
        }
    }


    function formatEventType(type: string): string {
        return type.replace(/([a-z])([A-Z])/g, '$1 $2');
    }
  </script>
  
  <Layout>
    <div class="bg-panel rounded-md mt-4">
      <h1 class="default-header p-4">OpenFPL System Log</h1>
      
      <div class="p-4 flex flex-col sm:flex-row gap-4">
        <div>
          <label for="start-date" class="block text-sm font-medium">Start Date</label>
          <input
            type="date"
            id="start-date"
            bind:value={startDate}
            class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          />
        </div>
        <div>
          <label for="end-date" class="block text-sm font-medium">End Date</label>
          <input
            type="date"
            id="end-date"
            bind:value={endDate}
            class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
          />
        </div>
        <div>
            <label for="event-type" class="block text-sm font-medium">Event Type</label>
            <select
                id="event-type"
                bind:value={eventType}
                class="mt-1 block w-full p-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm bg-light-gray"
            >
                <option value={null}>Select an event type</option>
                {#each eventTypes as type}
                <option value={type}>{formatEventType(Object.keys(type)[0])}</option>
                {/each}
            </select>
        </div>
        <div class="flex items-end">
          <button
            on:click={filterLogs}
            class="fpl-button default-button"
          >
            Filter
          </button>
        </div>
      </div>


      {#if isLoading}
        <LocalSpinner />
    {:else}
        {#if systemLog}
            <div class="mb-4">
                {#each systemLog.entries as log (log.eventId)}
                    <div class="grid grid-cols-3 gap-4 border-b border-gray-300">
                        <div class="col-span-1 font-bold">{log.eventTime}</div>
                        <div class="col-span-1">{log.eventType}</div>
                        <div class="col-span-1">{log.eventDetail}</div>
                    </div>
                {/each}
                {#if systemLog.totalEntries === 0n}
                    <p class="px-4">No log entries found.</p>
                {/if}
            </div> 
        {/if}
    {/if}

    </div>
  </Layout>
  