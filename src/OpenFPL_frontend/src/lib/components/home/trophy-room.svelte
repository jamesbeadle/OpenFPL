<!--

    // TODO
    
    All Time high scores
        - Show record value
        - Show record held by
        - Show value of pot if broken

    For
    - Weekly high score
    - Monthly high score
    - Season high score

-->

<script lang="ts">
    import { onMount } from "svelte";
    import LocalSpinner from "../shared/global/local-spinner.svelte";
    
    let isLoading = $state(true);
    
    onMount(async () => {
        try {
        } catch (error) {
        } finally {
            isLoading = false;
        }
    });
  

    

</script>
{#if isLoading}
      <LocalSpinner />
{:else}
  <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 min-h-64">
      <div class="bg-BrandGray text-left rounded shadow-md p-4 hover:shadow-lg transition-shadow flex items-center flex-col">
        
        <h3 class="w-full text-2xl font-semibold">All Time Weekly High Score</h3>
        <p class="w-full text-sm font-bold text-BrandLightGray">{weeklyLeaderboardATHScore.currentRecord}</p>
        <p>Next Winner Prize Pool: {weeklyLeaderboardATHScore.currentPrizePool}</p>
        <p>Record Holder: {weeklyLeaderboardATHScore.recordHolderUsername}</p>
        
    </div>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 min-h-64">
    <div class="bg-BrandGray text-left rounded shadow-md p-4 hover:shadow-lg transition-shadow flex items-center flex-col">
      
      <h3 class="w-full text-2xl font-semibold">All Time Monthly High Score</h3>
      <p class="w-full text-sm font-bold text-BrandLightGray">{monthlyLeaderboardATHScore.currentRecord}</p>
      <p>Next Winner Prize Pool: {monthlyLeaderboardATHScore.currentPrizePool}</p>
      <p>Record Holder: {monthlyLeaderboardATHScore.recordHolderUsername}</p>
     </div>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 min-h-64">
        <div class="bg-BrandGray text-left rounded shadow-md p-4 hover:shadow-lg transition-shadow flex items-center flex-col">
        
        <h3 class="w-full text-2xl font-semibold">All Time Season High Score</h3>
        <p class="w-full text-sm font-bold text-BrandLightGray">{seasonLeaderboardATHScore.currentRecord}</p>
        <p>Next Winner Prize Pool: {seasonLeaderboardATHScore.currentPrizePool}</p>
        <p>Record Holder: {seasonLeaderboardATHScore.recordHolderUsername}</p>
    </div>
    </div>
{/if}