<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";
    import type { GetRewardPoolDTO, SeasonDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { formatE8s } from "$lib/utils/helpers";
    
    let isLoading = true;
    let rewardPool: GetRewardPoolDTO;
    let filterSeason = 0;
    let seasons: SeasonDTO[];

    onMount(async () => {
        await systemStore.sync();
        seasons = await systemStore.getSeasons();
        filterSeason = seasons[0].id;
        await loadRewardPool();
    });

    $: { if (filterSeason !== 0) {
            loadRewardPool();
        }
    }

    async function loadRewardPool() {
        
        try{
            isLoading = true;
            let result = await systemStore.getRewardPool(filterSeason);
            if(result){
                rewardPool = result;
            }
        } catch (error) {
            console.error("Error fetching reward pool information.")
        } finally {
            isLoading = false;
        }
    }
</script>
{#if isLoading}
    <LocalSpinner />
{:else}
    <div>
        <label for="filterSeason">Reward Pool:</label>
        <select
        id="filterSeason"
        class="mt-1 block w-full py-2 text-white fpl-dropdown"
        bind:value={filterSeason}
        >
            {#each seasons as season}
                <option value={season.id}>{season.name}</option>
            {/each}
        </select>
    </div>
    <div>
        <p>Weekly Leaderboard Pool: {formatE8s(rewardPool.rewardPool.weeklyLeaderboardPool)} FPL</p>
        <p>Monthly Leaderboard Pool: {formatE8s(rewardPool.rewardPool.monthlyLeaderboardPool)} FPL</p>
        <p>Season Leaderboard Pool: {formatE8s(rewardPool.rewardPool.seasonLeaderboardPool)} FPL</p>
        <p>Most Valuable Match Player Pool: {formatE8s(rewardPool.rewardPool.highestScoringMatchPlayerPool)} FPL</p>
        <p>Most Valuable Team Player Pool: {formatE8s(rewardPool.rewardPool.mostValuableTeamPool)} FPL</p>
        <p>All Time Weekly High Score Pool: {formatE8s(rewardPool.rewardPool.allTimeWeeklyHighScorePool)} FPL</p>
        <p>All Time Monthly High Score Pool: {formatE8s(rewardPool.rewardPool.allTimeMonthlyHighScorePool)} FPL</p>
        <p>All Time Season High Score Pool: {formatE8s(rewardPool.rewardPool.allTimeSeasonHighScorePool)} FPL</p>
        <p>Total Reward Pool: {
            formatE8s((
                rewardPool.rewardPool.weeklyLeaderboardPool +
                rewardPool.rewardPool.monthlyLeaderboardPool +
                rewardPool.rewardPool.seasonLeaderboardPool +
                rewardPool.rewardPool.highestScoringMatchPlayerPool +
                rewardPool.rewardPool.mostValuableTeamPool +
                rewardPool.rewardPool.allTimeWeeklyHighScorePool +
                rewardPool.rewardPool.allTimeMonthlyHighScorePool +
                rewardPool.rewardPool.allTimeSeasonHighScorePool
            ))
        }</p>
    </div>
{/if}