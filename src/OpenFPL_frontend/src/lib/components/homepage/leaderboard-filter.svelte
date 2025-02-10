<script lang="ts">
    import type { Writable } from "svelte/store";

    export let changeLeaderboardType : (delta: number) => void;
    export let selectedLeaderboardType : Writable<number>;
</script>
<div class="mt-6 xs:p-4 xs:mt-0 {$selectedLeaderboardType === 3 ? 'pb-6' : ''}">
    <div class="flex flex-col items-center gap-4 sm:flex-row sm:justify-between">
        <div class="flex items-center">
            <button
                class="mr-1 default-button fpl-button"
                on:click={() => changeLeaderboardType(-1)}>&lt;</button>
            <select
                class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[125px]"
                bind:value={$selectedLeaderboardType}
            >
                <option value={1}>Weekly</option>
                <option value={2}>Monthly</option>
                <option value={3}>Season</option>
            </select>
            <button
                class="ml-3 default-button fpl-button"
                on:click={() => changeLeaderboardType(1)}>&gt;
            </button>
        </div>
    </div>
</div>