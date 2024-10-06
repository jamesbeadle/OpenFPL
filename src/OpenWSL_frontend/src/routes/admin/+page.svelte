<script lang="ts">
    import Layout from "../Layout.svelte";
    let activeTab: string = 'cycles';

    function setActiveTab(tab:string){
        activeTab = tab;
    }

</script>

<Layout>
<div class="admin-dashboard">

    <nav class ="tabs">
        <button class = {activeTab === 'cycles' ? 'active' : '' } on:click={()=> setActiveTab('cycles')}>
            Canister Cycles
        </button>
        <button class = {activeTab === 'static' ? 'active' : '' } on:click={()=> setActiveTab('static')}>
            Static Canisters
        </button>
        <button class ={activeTab === 'snapshot' ? 'active' : ''} on:click={() => setActiveTab('snapshot')}>
            Snapshot Managers
        </button>
        <button class ={activeTab === 'points' ? 'active' : ''} on:click={() => setActiveTab('points')}>
            Recalculate Points
        </button>
        <button class ={activeTab === 'payouts' ? 'active' : ''} on:click={() => setActiveTab('payouts')}>
            View Payouts
        </button>
        <button class ={activeTab === 'reward' ? 'active' : ''} on:click={() => setActiveTab('reward')}>
            Update Rewards Pools
        </button>
        <button class ={activeTab === 'state' ? 'active' : ''} on:click={() => setActiveTab('state')}>
            System State
        </button>
    </nav>

    {#if activeTab === 'cycles'}
        <section class="canister-cyles">
            <h2> Canister Cycles</h2>
            <div class="cycle-count">
                <h3>Cycle Count</h3>
                <ul>
                    <li>OpenFPL Frontend: </li>
                    <li>OpenFPL Backend: </li>
                    <li>Data Canister</li>
                </ul>
            </div>
        </section>
    {/if}

    {#if activeTab === 'static'}
        <section class="static-canisters">
            <h2> Static Canisters</h2>
            <div class="cycle-count">
                <ul>
                    <li>OpenFPL Frontend: </li>
                    <li>OpenFPL Backend: </li>
                    <li>Data Canister</li>
                </ul>
            </div>
        </section>
    {/if}

    {#if activeTab === 'snapshot'}
        <section class="snapshot-managers">
            <h3>Snapshot Managers</h3>
            <div class="snapshot-button">
                <button>Snapshot Managers</button>
            </div>
        </section>
    {/if}

    {#if activeTab === 'points'}
        <section class="recalculate-points">
            <h2>Recalculate Points</h2>
            <button>Recalculate Points</button>
        </section>
    {/if}

    {#if activeTab === 'payouts'}
        <section class="payouts">
            <h2>View Payouts</h2>
            <button>View Payout</button>
        </section>
    {/if}

    {#if activeTab === 'state'}
        <section class="system-state">
            <h2>System State</h2>
            <button>Change System State</button>
        </section>
    {/if}

</div>
</Layout>

<style>
    .admin-dashboard {
      padding: 2rem;
    }
  
    /* Tabs Styling */
    .tabs {
      display: flex;
      justify-content: space-around;
      margin-bottom: 2rem;
    }
  
    .tabs button {
      padding: 0.75rem 1.5rem;
      background-color: #0d70da;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }
  
    .tabs button.active {
      background-color: #0056b3;
    }
  
    .tabs button:hover {
      background-color: #0056b3;
    }
  
    section {
      border: 1px solid #ccc;
      padding: 1.5rem;
    }
  
    h2 {
      margin-bottom: 1rem;
    }
  
    button {
      padding: 0.75rem 1.5rem;
      background-color: blue;
      color: white;
      border: none;
      cursor: pointer;
      border-radius: 5px;
    }
  
    button:hover {
      background-color: BRAND;
    }
  </style>