<script lang="ts">
    import { clubStore } from "$lib/stores/club-store";
    import type { Writable } from "svelte/store";
    
    export let selectedTeamId: Writable<number | null>;
    export let changeTeam : (clubId: number) => void;

    $: if ($clubStore.length && !$selectedTeamId) {
        $selectedTeamId = $clubStore[0].id;
    }
</script>

<div class="flex flex-col items-center gap-4 sm:flex-row sm:justify-between">
    <div class="flex items-center">
        <button class="mr-1 default-button fpl-button" on:click={() => changeTeam(-1)}>
            &lt;
        </button>

        <select class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[125px]" bind:value={$selectedTeamId}>
            {#each $clubStore.sort( (a, b) => a.friendlyName.localeCompare(b.friendlyName) ) as team}
                <option value={team.id}>{team.friendlyName}</option>
            {/each}
        </select>

        <button class="ml-3 default-button fpl-button" on:click={() => changeTeam(1)}>
            &gt;
        </button>
    </div>
</div>