


<script lang="ts">
    import { onMount } from "svelte";
    import Layout from "../Layout.svelte";
    import { systemStore } from "$lib/stores/system-store";
    import LocalSpinner from "$lib/components/local-spinner.svelte";
    import Summary from "$lib/components/status/summary.svelte";
    import Canisters from "$lib/components/status/canisters.svelte";
    import Timers from "$lib/components/status/timers.svelte";
    import Topups from "$lib/components/canisters/topups.svelte";
    import RewardPools from "$lib/components/status/reward-pools.svelte";
    import Logs from "$lib/components/status/logs.svelte";
    
    let isLoading = true;
    let activeTab: string = "summary";

    onMount(async () => {
      try{
        await systemStore.sync();
      } catch (error){
        console.error("Error fetching system logs.")
      } finally {
        isLoading = false;
      };
    });

    function setActiveTab(tab: string): void {
      activeTab = tab;
    }
  </script>
  
  <Layout>
    <div class="bg-panel rounded-md mt-4">
      <h1 class="default-header p-4">OpenFPL System Status</h1>
      
    {#if isLoading}
        <LocalSpinner />
    {:else}
      <div class="flex">
        <button 
          class={`btn ${ activeTab === "summary" ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-l-md`}
          on:click={() => setActiveTab("summary")}
        >
          Summary
        </button>
        <button 
          class={`btn ${ activeTab === "canisters" ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-l-md`}
          on:click={() => setActiveTab("canisters")}
        >
          Canisters
        </button>
        <button 
          class={`btn ${ activeTab === "timers" ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-l-md`}
          on:click={() => setActiveTab("timers")}
        >
          Timers
        </button>
        <button 
          class={`btn ${ activeTab === "topups" ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-l-md`}
          on:click={() => setActiveTab("topups")}
        >
          Topups
        </button>
        <button 
          class={`btn ${ activeTab === "reward-pools" ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-l-md`}
          on:click={() => setActiveTab("reward-pools")}
        >
          Reward Pools
        </button>
        <button 
          class={`btn ${ activeTab === "logs" ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-l-md`}
          on:click={() => setActiveTab("logs")}
        >
          Logs
        </button>
      </div>

      <div class="w-full">
        {#if activeTab === "summary"}
          <Summary />
        {/if}

        {#if activeTab === "canisters"}
          <Canisters />
        {/if}

        {#if activeTab === "timers"}
          <Timers />
        {/if}

        {#if activeTab === "topups"}
          <Topups />
        {/if}

        {#if activeTab === "reward-pools"}
          <RewardPools />
        {/if}

        {#if activeTab === "logs"}
          <Logs />
        {/if}
      </div>
    {/if}

    </div>
  </Layout>
  