
<script lang="ts">
    import { systemStore } from "$lib/stores/system-store";
    import { onMount } from "svelte";
    import LocalSpinner from "../local-spinner.svelte";

    let isLoading = true;

    onMount(async () => {
      try{
        await systemStore.sync();
      } catch (error){
        console.error("Error syncing system store in status summary.")
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

<!-- TODO: Total available backend canister cycles -->

<!-- Maybe the code to top it up for anyone -->

    </div>
{/if}