
<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";

    let isLoading = true;
    let backendCanisterBalance = 0n;
    let backendCyclesAvailable = 0n;

    onMount(async () => {
      try{
        await systemStore.sync();

        let fplBalance = await systemStore.getBackendCanisterBalance();

        if(fplBalance){
          backendCanisterBalance = fplBalance;
        }

        let cyclesBalance = await systemStore.getBackendCanisterCyclesAvailable();

        if(cyclesBalance){
          backendCyclesAvailable = cyclesBalance; 
        }
      } catch (error){
        console.error("Error fetching system summary.")
      } finally {
        isLoading = false;
      };
    });
</script>
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
        <p>Backend Canister FPL Balance: {backendCanisterBalance}</p>
        <p>Backend Cycles Available: {backendCyclesAvailable}</p>
        <p>To topup the OpenFPL backend canister with 100T cycles, run dfx wallet --network=ic send bboqb-jiaaa-aaaal-qb6ea-cai 100_000_000_000_000</p>
    </div>
{/if}