<script lang="ts">
    import { clubStore } from "$lib/stores/club-store";
    import type { Writable } from "svelte/store";

    export let filterTeam: Writable<number>;
    export let filterPosition: Writable<number>;
    export let minValue: Writable<number>;
    export let maxValue: Writable<number>;
    export let filterSurname: Writable<string>;

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

<div class="grid grid-cols-2 gap-4 my-2">
    <div>
      <label for="minValue">Min Value:</label>
      <input
        id="minValue"
        type="number"
        class="mt-1 block w-full p-2 bg-gray-700 text-white fpl-dropdown"
        bind:value={$minValue}
      />
    </div>
    <div>
      <label for="maxValue">Max Value:</label>
      <input
        id="maxValue"
        type="number"
        class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md fpl-dropdown"
        bind:value={$maxValue}
      />
    </div>
  </div>

  <div class="my-4">
    <label for="filterSurname">Search by Name:</label>
    <input
      id="filterSurname"
      type="text"
      class="mt-1 block w-full p-2 bg-gray-700 text-white rounded-md"
      placeholder="Enter"
      bind:value={$filterSurname}
    />
  </div>