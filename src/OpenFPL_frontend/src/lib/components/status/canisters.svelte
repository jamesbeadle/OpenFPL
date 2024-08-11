<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";
    import type { CanisterType, GetCanistersDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    let isLoading = true;
    let canisters: GetCanistersDTO;
    let filterCategory = 0;
    let currentPage = 1;
    const pageSize = 10;


    onMount(async () => {
      try{
        await systemStore.sync();
        
        let dto: GetCanistersDTO = {
            totalEntries: 0n,
            offset: 0n,
            limit: 0n,
            entries: [],
            canisterTypeFilter: { "SNS" : null }
        };

        let canister_result = await systemStore.getCanisters(dto);
        if(!canister_result){
            return;
        };

        canisters = canister_result;

      } catch (error){
        console.error("Error fetching canister information.")
      } finally {
        isLoading = false;
      };
    });

    $: { if (filterCategory !== -1) {
            filterCanisters();
            currentPage = 1;
        }
    }

    async function filterCanisters() {
        var canisterTypeFilter: CanisterType = { "SNS" : null };
        switch(currentPage){
            case 0:
                canisterTypeFilter = { "SNS" : null }
                break;
            case 1:
                canisterTypeFilter = { "Dapp" : null }
                break;
            case 2:
                canisterTypeFilter = { "Manager" : null }
                break;
            case 3:
                canisterTypeFilter = { "WeeklyLeaderboard" : null }
                break;
            case 4:
                canisterTypeFilter = { "MonthlyLeaderboard" : null }
                break;
            case 5:
                canisterTypeFilter = { "SeasonLeaderboard" : null }
                break;
            case 6:
                canisterTypeFilter = { "Archive" : null }
                break;
        }
            
        const limit = pageSize;
        const offset = (currentPage - 1) * limit;
        let dto: GetCanistersDTO = {
            totalEntries: 0n,
            offset: BigInt(offset),
            limit: BigInt(limit),
            entries: [],
            canisterTypeFilter: canisterTypeFilter
        };
        let result = await systemStore.getCanisters(dto); 
        if(result){
            canisters = result;
        }
    }
</script>
{#if isLoading}
    <LocalSpinner />
{:else}
    <div>
        <label for="filterCategory">Filter by Canister Type:</label>
        <select
        id="filterCategory"
        class="mt-1 block w-full py-2 text-white fpl-dropdown"
        bind:value={filterCategory}
        >
            <option value={0}>SNS</option>
            <option value={1}>Dapp</option>
            <option value={2}>Manager</option>
            <option value={3}>WeeklyLeaderboard</option>
            <option value={4}>MonthlyLeaderboard</option>
            <option value={5}>SeasonLeaderboard</option>
            <option value={6}>Archive</option>
        </select>
    </div>
    <div class="p-4">
        {#each canisters.entries as canister}
            <div class="flex flex-col">
                <p>{canister.canisterId}</p>
                <p>{canister.canister_type}</p>
                <p>{canister.cycles}</p>
                <p>{canister.lastTopup}</p>
            </div>
        {/each}
    </div>
{/if}