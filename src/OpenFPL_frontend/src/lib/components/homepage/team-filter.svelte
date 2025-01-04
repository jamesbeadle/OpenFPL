<script lang="ts">
    import { clubStore } from "$lib/stores/club-store";
    import type { Writable } from "svelte/store";
    
    export let selectedTeamId: Writable<number | null>;
    export let changeTeam : (clubId: number) => void;
</script>


<div class="ml-4 mt-4">
    <button class="fpl-button default-button" on:click={() => changeTeam(-1)}>
        &lt;
    </button>

    <select class="p-2 fpl-dropdown my-4 min-w-[100px]" bind:value={$selectedTeamId}>
        {#each $clubStore.sort( (a, b) => a.friendlyName.localeCompare(b.friendlyName) ) as team}
            <option value={team.id}>{team.friendlyName}</option>
        {/each}
    </select>

    <button class="default-button fpl-button ml-1" on:click={() => changeTeam(1)}>
        &gt;
    </button>
</div>