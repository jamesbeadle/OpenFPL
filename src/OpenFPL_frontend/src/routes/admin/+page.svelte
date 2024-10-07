<script lang="ts">
    import ViewPayoutModal from '../../lib/components/admin/view-payout-modal.svelte';
    
    let activeTab: string = 'cycles';

    function selectTab(tab:string){
        activeTab = tab;
    }

</script>

<div class="admin-dashboard">

    <nav class ="tabs">
        <button class = {activeTab === 'cycles' ? 'active' : '' } on:click={()=> selectTab('cycles')}>
            Canister Cycles
        </button>
        <button class ={activeTab === 'snapshot' ? 'active' : ''} on:click={() => selectTab('snapshot')}>
            Snapshot Managers
        </button>
        <button class ={activeTab === 'points' ? 'active' : ''} on:click={() => selectTab('points')}>
            Recalculate Points
        </button>
        <button class ={activeTab === 'payouts' ? 'active' : ''} on:click={() => selectTab('payouts')}>
            View Payouts
        </button>
        <button class ={activeTab === 'reward' ? 'active' : ''} on:click={() => selectTab('reward')}>
            Update Rewards Pools
        </button>
        <button class ={activeTab === 'state' ? 'active' : ''} on:click={() => selectTab('state')}>
            System State
        </button>
    </nav>

    {#if activeTab === 'cycles'}
        <section class="canister-cyles">
            <h2> Canister Cycles</h2>
            <div class="static-canisters">
                <h3>Static Canisters</h3>
                <ul>
                    <li>OpenFPL Frontend: </li>
                    <li>OpenFPL Backend: </li>
                    <li>Data Canister</li>
                </ul>
            </div>
            <div class="cycle-top-up">
                <button>Top Up Cycles</button>
            </div>
        </section>
    {/if}
    
    {#if activeTab === 'snapshot'}
    <section class="snapshot-managers">
        <h2>Snapshot Managers</h2>
        <button>Snapshot Manager</button>
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

    {#if activeTab === 'reward'}
    <section class="update-rewardpool">
        <h2>Update Reward Pools</h2>
        <button>Change Reward Pools</button>
    </section>
    {/if}

    {#if activeTab === 'state'}
        <section class="system-state">
            <h2>System State</h2>
            <button>Change System State</button>
        </section>
    {/if}

</div>

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
      background-color: #007bff;
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
      background-color: BRAND;
    }
  
    h2 {
      margin-bottom: 1rem;
    }
  
    button {
      padding: 0.75rem 1.5rem;
      background-color: BRAND;
      color: white;
      border: none;
      cursor: pointer;
      border-radius: 5px;
    }
  
    button:hover {
      background-color: BRAND;
    }
  </style>