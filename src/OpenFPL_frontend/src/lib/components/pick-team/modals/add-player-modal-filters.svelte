<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";

  let filterTeam: number = $state(-1);
  let minValue: number = $state(0);
  let maxValue: number = $state(0);
  let filterSurname: string = $state("");

  interface Props {
    filterPlayers: (filterTeam: number, filterPosition: number, minValue: number, maxValue: number, filterSurname: string) => void;
    filterPosition: number;
  }

  let { filterPlayers, filterPosition } : Props = $props();
        
  onMount(async () => {
    filterTeam = -1;
    minValue = 0;
    maxValue = 0;
    filterSurname = "";
  });
    
  $effect(() => {
    if ( filterTeam !== -1 || filterPosition !== -1 || minValue !== 0 || maxValue !== 0 || filterSurname !== "" ) {
      filterPlayers(filterTeam, filterPosition, minValue, maxValue, filterSurname);
    }
  });

</script>
<div class="grid grid-cols-2 gap-1">
    <div>
    <label for="filterTeam">Filter by Team:</label>
    <select id="filterTeam" class="block w-full py-2 mt-1 text-white fpl-dropdown focus:outline-none bigger-text" bind:value={filterTeam}>
        <option value={-1}>All</option>
        {#each $clubStore as team}
        <option value={team.id}>{team.friendlyName}</option>
        {/each}
    </select>
    </div>
    <div>
    <label for="filterPosition">Filter by Position:</label>
    <select id="filterPosition" class="block w-full py-2 mt-1 text-white fpl-dropdown focus:outline-none" bind:value={filterPosition}>
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
        class="block w-full p-2 mt-1 text-white bg-gray-700 fpl-dropdown focus:outline-none"
        bind:value={minValue}
      />
    </div>
    <div>
      <label for="maxValue">Max Value:</label>
      <input
        id="maxValue"
        type="number"
        class="block w-full p-2 mt-1 text-white bg-gray-700 rounded-md fpl-dropdown focus:outline-none focus:border-BrandGreen"
        bind:value={maxValue}
      />
    </div>
  </div>

  <div class="my-4">
    <label for="filterSurname">Search by Name:</label>
    <input
      id="filterSurname"
      type="text"
      class="w-full p-2 mt-2 text-white transition-colors border border-gray-700 rounded-lg bg-BrandGray focus:outline-none focus:border-BrandGreen"
      placeholder="Enter"
      bind:value={filterSurname}
    />
  </div>