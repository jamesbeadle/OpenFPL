


<script lang="ts">
    import { onMount } from "svelte";
    import Layout from "../Layout.svelte";
    import { systemStore } from "$lib/stores/system-store";
    import LocalSpinner from "$lib/components/local-spinner.svelte";
    import Summary from "$lib/components/status/summary.svelte";
    import Canisters from "$lib/components/status/canisters.svelte";
    import Topups from "$lib/components/status/topups.svelte";
    import RewardPools from "$lib/components/status/reward-pools.svelte";
    
    let isLoading = true;
    let activeTab: string = "summary";

    onMount(async () => {
      try{
        await systemStore.sync();
      } catch (error){
        console.error("Error fetching system status.")
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
      <div class="flex p-4 flex-row">
        <button 
          class={`btn ${ activeTab === "summary" ? `fpl-button` : `inactive-btn` } tab-switcher-label rounded-l-md`}
          on:click={() => setActiveTab("summary")}
        >
          Summary
        </button>
        <button 
          class={`btn ${ activeTab === "canisters" ? `fpl-button` : `inactive-btn` } tab-switcher-label`}
          on:click={() => setActiveTab("canisters")}
        >
          Canisters
        </button>
        <button 
          class={`btn ${ activeTab === "topups" ? `fpl-button` : `inactive-btn` } tab-switcher-label`}
          on:click={() => setActiveTab("topups")}
        >
          Topups
        </button>
        <button 
          class={`btn ${ activeTab === "reward-pools" ? `fpl-button` : `inactive-btn` } tab-switcher-label`}
          on:click={() => setActiveTab("reward-pools")}
        >
          Reward Pools
        </button>
      </div>

      <div class="w-full px-4 my-4">
        {#if activeTab === "summary"}
          <Summary />
        {/if}

        {#if activeTab === "canisters"}
          <Canisters />
        {/if}

        {#if activeTab === "topups"}
          <Topups />
        {/if}

        {#if activeTab === "reward-pools"}
          <RewardPools />
        {/if}

      </div>
    {/if}

    </div>
  </Layout>
  