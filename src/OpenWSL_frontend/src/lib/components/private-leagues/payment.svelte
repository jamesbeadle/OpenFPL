<script lang="ts">
    import { writable } from "svelte/store";
    import type { CreatePrivateLeagueDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { onMount } from 'svelte';
  
    // Assuming you would fetch these from a store or an API
    let fplBalance: BigInt;
    let icpBalance: BigInt;
  
    onMount(async () => {
      // Initialize balances, this should be replaced with actual data fetching logic
      fplBalance = BigInt(0); // replace with actual balance fetching
      icpBalance = BigInt(0); // replace with actual balance fetching
    });
  
    function purchaseWithFPL() {
      // Logic to handle purchase with FPL
      console.log('Purchasing with FPL');
    }
  
    function purchaseWithICP() {
      // Logic to handle purchase with ICP
      console.log('Purchasing with ICP');
    }

export let privateLeague = writable<CreatePrivateLeagueDTO | null>(null);
  </script>
  
  <div class="container mx-auto px-4 py-8">
    <p class="text-xl mb-2">Payment</p>
    
    <div class="mb-4">
  
        <p>FPL Balance: {fplBalance}</p>
        <p>ICP Balance: {icpBalance}</p>
    </div>
    
    <div class="grid grid-cols-2 gap-4">
        <button class="fpl-button px-4 py-2 rounded-md" on:click={purchaseWithFPL}>
          Purchase with 250 FPL
        </button>
        <button class="fpl-button px-4 py-2 rounded-md" on:click={purchaseWithICP}>
          Purchase with 1 ICP
        </button>
      </div>
      
      <div class="text-sm mt-4">
        <p>* Purchasing in FPL will burn the tokens and reduce the token supply.</p>
        <p>* Purchasing in ICP will add funds to the DAO's treasury.</p>
      </div>

  </div>