<script lang="ts">
    import { onMount } from "svelte";
    import LocalSpinner from "../shared/global/local-spinner.svelte";
    import type { AllTimeHighScores } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { allTimeHighScoresStore } from "$lib/stores/all-time-high-score-store";
    import { toasts } from "$lib/stores/toasts-store";
    
    let isLoading = $state(true);
    let allTimeHighScores: AllTimeHighScores | undefined = $state(undefined);
    
    onMount(async () => {
        try {
            allTimeHighScores = await allTimeHighScoresStore.getAllTimeHighScores({});
        } catch (error) {
            toasts.addToast({type: 'error', message: 'Error fetching high scores'})
        } finally {
            isLoading = false;
        }
    });
  
</script>
{#if isLoading}
      <LocalSpinner />
{:else}
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 min-h-64">
        <div class="bg-BrandDarkGray text-left rounded shadow-md p-4 hover:shadow-lg transition-shadow flex items-center flex-col">
        
            <h3 class="w-full text-2xl font-semibold">All Time Weekly High Score</h3>
            <p class="w-full text-sm font-bold text-BrandLightGray">{allTimeHighScores?.weeklyHighScore[0]?.recordPoints}</p>
            <p>Next Winner Prize Pool: {allTimeHighScores?.weeklyHighScore[0]?.recordPrizePool}</p>
            <p>Record Holder: {allTimeHighScores?.weeklyHighScore[0]?.recordHolderUsername}</p>
        
        </div>
        <div class="bg-BrandGray text-left rounded shadow-md p-4 hover:shadow-lg transition-shadow flex items-center flex-col">
        
            <h3 class="w-full text-2xl font-semibold">All Time Monthly High Score</h3>
            <p class="w-full text-sm font-bold text-BrandLightGray">{allTimeHighScores?.monthlyHighScore[0]?.recordPoints}</p>
            <p>Next Winner Prize Pool: {allTimeHighScores?.monthlyHighScore[0]?.recordPrizePool}</p>
            <p>Record Holder: {allTimeHighScores?.monthlyHighScore[0]?.recordHolderUsername}</p>
        
        </div>
        <div class="bg-BrandGray text-left rounded shadow-md p-4 hover:shadow-lg transition-shadow flex items-center flex-col">
        
            <h3 class="w-full text-2xl font-semibold">All Time Season High Score</h3>
            <p class="w-full text-sm font-bold text-BrandLightGray">{allTimeHighScores?.seasonHighScore[0]?.recordPoints}</p>
            <p>Next Winner Prize Pool: {allTimeHighScores?.seasonHighScore[0]?.recordPrizePool}</p>
            <p>Record Holder: {allTimeHighScores?.seasonHighScore[0]?.recordHolderUsername}</p>
        
        </div>
    </div>
{/if}