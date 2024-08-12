<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";
    import type { TimerType, GetTimersDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    let isLoading = true;
    let timers: GetTimersDTO;
    let filterCategory = 0;
    let currentPage = 1;
    let itemsPerPage = 25;


    onMount(async () => {
      try{
        await systemStore.sync();
        await loadTimers();
      } catch (error){
        console.error("Error fetching timer information.")
      } finally {
        isLoading = false;
      };
    });

    $: { if (filterCategory !== -1) {
        loadTimers();
            currentPage = 1;
        }
    }

    async function loadTimers() {

        try{
            isLoading = true;
            var timerTypeFilter: TimerType = { "GameweekBegin" : null };
            switch(currentPage){
                case 0:
                    timerTypeFilter = { "GameweekBegin" : null }
                    break;
                case 1:
                    timerTypeFilter = { "LoanComplete" : null }
                    break;
                case 2:
                    timerTypeFilter = { "TransferWindow" : null }
                    break;
                case 3:
                    timerTypeFilter = { "InjuryExpired" : null }
                    break;
                case 4:
                    timerTypeFilter = { "GameKickOff" : null }
                    break;
                case 5:
                    timerTypeFilter = { "GameComplete" : null }
                    break;
            }
            let result = await systemStore.getTimers(currentPage, itemsPerPage, timerTypeFilter); 
            if(result){
                timers = result;
            }
        } catch (error) {
            console.error("Error fetching canister information.")
        } finally {
            isLoading = true;
        }
    }
</script>
{#if isLoading}
    <LocalSpinner />
{:else}
    <div>
        <label for="filterCategory">Filter by Timer Type:</label>
        <select
        id="filterCategory"
        class="mt-1 block w-full py-2 text-white fpl-dropdown"
        bind:value={filterCategory}
        >
            <option value={0}>GameweekBegin</option>
            <option value={1}>LoanComplete</option>
            <option value={2}>TransferWindow</option>
            <option value={3}>InjuryExpired</option>
            <option value={4}>GameKickOff</option>
            <option value={5}>GameComplete</option>
        </select>
    </div>
    <div class="p-4">
        {#each timers.entries as timer}
            <div class="flex flex-col">
                <p>{timer.id}</p>
                <p>{timer.callbackName}</p>
                <p>{timer.triggerTime}</p>
            </div>
        {/each}
    </div>
{/if}