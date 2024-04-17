<script lang="ts">
    import { writable, derived } from "svelte/store";
    import type { CreatePrivateLeagueDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    let numberOfWinners = writable(10); // Example number of winners
    let individualPercentages = writable([]);

    // This derived store calculates the percentages based on the number of winners
    let percentages = derived(numberOfWinners, $numberOfWinners => {
        let shares = [];
        let harmonicSum = 0;

        // Calculate the harmonic sum for normalization
        for (let i = 1; i <= $numberOfWinners; i++) {
            harmonicSum += 1 / i;
        }

        // Calculate each percentage based on the harmonic sum
        for (let i = 1; i <= $numberOfWinners; i++) {
            shares.push((1 / i) / harmonicSum);
        }
         // Convert shares to percentages and reverse to give higher values to lower indices
         let percentages = shares.map(x => x * 100);

        // Adjust the last element to ensure the sum is exactly 100%
        let total = percentages.reduce((acc, curr) => acc + curr, 0);
        percentages[percentages.length - 1] += 100 - total;

        return percentages;
    });

    export let privateLeague = writable<CreatePrivateLeagueDTO | null>(null);
</script>

<div class="container mx-auto p-4">
    <p class="text-xl mb-2">Prize Setup</p>
    
    <div class="mb-4">
        <label class="block text-sm font-bold mb-2" for="league-name">
          Number of Winners:
        </label>
        <input type="number" step="1" min="1" max="1000" bind:value={$numberOfWinners} class="shadow appearance-none border rounded w-full py-2 px-3 leading-tight focus:outline-none focus:shadow-outline" id="max-entrants" />
    </div>
    
    
    <div class="mb-4">
        <p class="block text-sm font-bold mb-2">
          Percentage Split:
        </p>
        {#each $percentages as percent, index (index)}
            <div class="mb-2">
                <input type="number" min="0" max="100" bind:value={$percentages[index]} class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" id={`winner-${index}`} />
            </div>
        {/each}

        {#if $percentages.reduce((total, curr) => total + curr, 0) !== 100}
            <p class="text-red-500 text-xs italic">Total percentage must equal 100%.</p>
        {/if}
    </div>

  </div>
  