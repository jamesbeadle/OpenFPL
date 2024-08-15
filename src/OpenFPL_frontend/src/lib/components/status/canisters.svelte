<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";
    import type { CanisterType, GetCanistersDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { formatCycles, formatUnixDateTimeToReadable } from "$lib/utils/helpers";
    
    let isLoading = true;
    let canisters: GetCanistersDTO;
    let priorFilterCategory = 0;
    let filterCategory = 0;
    let currentPage = 1;
    let itemsPerPage = 25;

    onMount(async () => {
        await systemStore.sync();
        await loadCanisters();
    });

    $: { if (priorFilterCategory !== filterCategory) {
            console.log("filter changed, loading canisters");
            loadCanisters();
            currentPage = 1;
            priorFilterCategory = filterCategory;
        }
    }

    async function loadCanisters() {
        try{
            isLoading = true;
            var canisterTypeFilter: CanisterType = { "SNS" : null };
            switch(filterCategory){
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

            console.log("getting canisters");
            let result = await systemStore.getCanisters(currentPage, itemsPerPage, canisterTypeFilter); 

            console.log(result);
            
            console.log("^^");
            if(result){
                canisters = result;
            }
        } catch (error) {
            console.error("Error fetching canister information.")
        } finally {
            isLoading = false;
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
            <div class="flex flex-col text-sm">
                <p>Id: {canister.canisterId}</p>
                <p>Type: {Object.keys(canister.canister_type)[0]}</p>
                <p>Cycles: {formatCycles(canister.cycles)}</p>
                <p>Last Topup: {formatUnixDateTimeToReadable(canister.lastTopup)}</p>
            </div>
        {/each}
    </div>
{/if}