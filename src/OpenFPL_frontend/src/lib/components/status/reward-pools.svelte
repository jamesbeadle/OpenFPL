<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";
    import type { GetRewardPoolDTO, SeasonDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    let isLoading = true;
    let rewardPool: GetRewardPoolDTO;
    let filterSeason = 0;
    let seasons: SeasonDTO[];

    onMount(async () => {
      try{
        await systemStore.sync();
        seasons = await systemStore.getSeasons();
        filterSeason = seasons[0].id;
        await loadRewardPool();
      } catch (error){
        console.error("Error fetching canister information.")
      } finally {
        isLoading = false;
      };
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
            isLoading = true;
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
                <option value={season.id}>season.name</option>
            {/each}
        </select>
    </div>
    <div>
        <p>Weekly Leaderboard Pool: ${rewardPool.rewardPool.weeklyLeaderboardPool}</p>
        <p>Monthly Leaderboard Pool: ${rewardPool.rewardPool.monthlyLeaderboardPool}</p>
        <p>Season Leaderboard Pool: ${rewardPool.rewardPool.seasonLeaderboardPool}</p>
        <p>Most Valuable Match Player Pool: ${rewardPool.rewardPool.highestScoringMatchPlayerPool}</p>
        <p>All Time Weekly High Score Pool: ${rewardPool.rewardPool.allTimeWeeklyHighScorePool}</p>
        <p>All Time Monthly High Score Pool: ${rewardPool.rewardPool.allTimeMonthlyHighScorePool}</p>
        <p>All Time Season High Score Pool: ${rewardPool.rewardPool.allTimeSeasonHighScorePool}</p>
    </div>
{/if}