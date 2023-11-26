<script lang="ts">
    import { onMount } from "svelte";
    import { SystemService } from "$lib/services/SystemService";

    let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
    let selectedGameweek: number = 1;
  
    onMount(async () => {
        try {
        const systemService = new SystemService();
        await systemService.updateSystemStateData();
        let systemState = await systemService.getSystemState();
        selectedGameweek = systemState?.activeGameweek ?? selectedGameweek;
        } catch (error) {
        console.error("Error fetching data:", error);
        }
    });

    const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
    };
</script>
<div class="mx-5 my-4">
    <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
        <div class="flex items-center space-x-2">
            <button class="text-2xl rounded fpl-button px-2" on:click={() => changeGameweek(-1)} disabled={selectedGameweek === 1}>
                &lt;
            </button>
        
            <select class="p-4 fpl-dropdown text-sm md:text-lg text-center" bind:value={selectedGameweek}>
                {#each gameweeks as gameweek}
                    <option value={gameweek}>Gameweek {gameweek}</option>
                {/each}
            </select>
        
            <button class="text-2xl rounded fpl-button px-2 ml-1" on:click={() => changeGameweek(1)} disabled={selectedGameweek === 38}>
                &gt;
            </button>
        </div>
    </div>

    <!-- Table -->

    <!-- Position, Flag:F.Name, Badge:Team, Points -->
</div>
