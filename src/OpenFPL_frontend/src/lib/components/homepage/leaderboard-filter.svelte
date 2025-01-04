<script lang="ts">
    import type { Writable } from "svelte/store";

    export let changeLeaderboardType : (delta: number) => void;
    export let selectedLeaderboardType : Writable<number>;
</script>
<div class="flex p-4">
    <button
        class="default-button fpl-button"
        on:click={() => changeLeaderboardType(-1)}>&lt;</button
    >
    <select
        class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[125px]"
        bind:value={$selectedLeaderboardType}
    >
        <option value={1}>Weekly</option>
        <option value={2}>Monthly</option>
        <option value={3}>Season</option>
    </select>
    <button
        class="default-button fpl-button ml-2"
        on:click={() => changeLeaderboardType(1)}>&gt;</button
    >
  </div>