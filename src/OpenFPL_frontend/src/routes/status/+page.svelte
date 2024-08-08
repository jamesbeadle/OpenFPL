<!-- Status Page -->

<!-- Season Active - False  -->

<!-- Transfer Window Active - False  -->

<!-- On Hold  -->

<!-- 
    See the timers that are waiting be triggered
        - Snapshotting of teams and change of the pick team gameweek timers
-->

<!-- 
    List Canisters

    Add in list of manager canisters
        - Cycles
-->

<!--
    Log of an attempt to topup canisters
-->

<!-- Total available backend canister cycles -->
<!-- Maybe the code to top it up for anyone -->

<!-- See reward pools -->


<script lang="ts">
    import { onMount } from "svelte";
    import Layout from "../Layout.svelte";
    import { systemStore } from "$lib/stores/system-store";
    import LocalSpinner from "$lib/components/local-spinner.svelte";
    
    let isLoading = true;

    onMount(async () => {
      try{
        await systemStore.sync();
      } catch (error){
        console.error("Error fetching system logs.")
      } finally {
        isLoading = false;
      };
    });
  </script>
  
  <Layout>
    <div class="bg-panel rounded-md mt-4">
      <h1 class="default-header p-4">OpenFPL System Status</h1>
      
    {#if isLoading}
        <LocalSpinner />
    {:else}
        <div class="p-4">
            <p>Pick Team Season: {$systemStore?.pickTeamSeasonName} (Id: {$systemStore?.pickTeamSeasonId})</p>
            <p>Calculation Season: {$systemStore?.calculationSeasonName} (Id: {$systemStore?.pickTeamSeasonId})</p>
            <p>Pick Team Gameweek: {$systemStore?.pickTeamGameweek}</p>
            <p>Calculation Gameweek: {$systemStore?.calculationGameweek}</p>
            <p>Season Active: {$systemStore?.seasonActive}</p>
            <p>Transfer Window Active: {$systemStore?.transferWindowActive}</p>
            <p>On Hold: {$systemStore?.onHold}</p>
        </div>
    {/if}

    </div>
  </Layout>
  