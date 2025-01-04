<script lang="ts">
    import type { Writable } from "svelte/store";
    import TeamFilter from "./team-filter.svelte";
    import { clubStore } from "$lib/stores/club-store";

    export let selectedTeamIndex: Writable<number>;
    export let selectedTeamId: Writable<number>;
    export let selectedMonth: Writable<number>;

    function changeTeam(delta: number) {
        $selectedTeamIndex =
        ($selectedTeamIndex + delta + $clubStore.length) % $clubStore.length;

        if ($selectedTeamIndex > $clubStore.length - 1) {
            $selectedTeamIndex = 0;
        }

        $selectedTeamId = $clubStore[$selectedTeamIndex].id;
    }

    function changeMonth(delta: number) {
        $selectedMonth += delta;
        if ($selectedMonth > 12) {
            $selectedMonth = 1;
        } else if ($selectedMonth < 1) {
            $selectedMonth = 12;
        }
    }

</script>
<TeamFilter {selectedTeamId} {changeTeam}  />

<div class="sm:flex sm:items-center sm:mt-0 mt-2 ml-2">
    <button class="fpl-button default-button" on:click={() => changeMonth(-1)}>
        &lt;
    </button>

    <select class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]" bind:value={$selectedMonth}>
        <option value={1}>January</option>
        <option value={2}>February</option>
        <option value={3}>March</option>
        <option value={4}>April</option>
        <option value={5}>May</option>
        <option value={6}>June</option>
        <option value={7}>July</option>
        <option value={8}>August</option>
        <option value={9}>September</option>
        <option value={10}>October</option>
        <option value={11}>November</option>
        <option value={12}>December</option>
    </select>

    <button class="default-button fpl-button ml-1" on:click={() => changeMonth(1)}>
        &gt;
    </button>
</div>