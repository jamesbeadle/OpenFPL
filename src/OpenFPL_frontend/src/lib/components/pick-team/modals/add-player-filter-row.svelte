<script lang="ts">
    import { clubStore } from "$lib/stores/club-store";
    import type { Writable } from "svelte/store";

    export let filterTeam: Writable<number>;
    export let filterPosition: Writable<number>;

</script>
<div class="grid grid-cols-2 gap-1">
    <div>
    <label for="filterTeam">Filter by Team:</label>
    <select id="filterTeam" class="mt-1 block w-full py-2 text-white fpl-dropdown bigger-text" bind:value={$filterTeam}>
        <option value={-1}>All</option>
        {#each $clubStore as team}
        <option value={team.id}>{team.friendlyName}</option>
        {/each}
    </select>
    </div>
    <div>
    <label for="filterPosition">Filter by Position:</label>
    <select id="filterPosition" class="mt-1 block w-full py-2 text-white fpl-dropdown" bind:value={$filterPosition}>
        <option value={-1}>All</option>
        <option value={0}>Goalkeepers</option>
        <option value={1}>Defenders</option>
        <option value={2}>Midfielders</option>
        <option value={3}>Forwards</option>
    </select>
    </div>
</div>