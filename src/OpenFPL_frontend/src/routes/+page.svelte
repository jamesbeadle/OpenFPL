
<script lang="ts">
  import Layout from './Layout.svelte';
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponents from "$lib/components/gameweek-points.svelte";
  let activeTab: string = 'fixtures';

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<style>
  .bg-panel{
    background-color: rgba(46,50,58,0.9);
  }
</style>

<Layout>

  <div class="p-1">
    <div class="flex">
      <div class="flex justify-start items-center text-white space-x-4 flex-grow m-1 bg-panel p-4 rounded-md border border-gray-500">
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Gameweek</p>
          <p class="text-4xl mt-2 mb-2 font-bold">12</p>
          <p class="text-gray-300 text-xs">2023/24</p>
        </div>
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Managers</p>
          <p class="text-4xl mt-2 mb-2 font-bold">200</p>
          <p class="text-gray-300 text-xs">Total</p>
        </div>
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Weekly Prize Pool</p>
          <p class="text-4xl mt-2 mb-2 font-bold">0</p>
          <p class="text-gray-300 text-xs">$FPL</p>
        </div>
      </div>
      <div class="flex justify-start items-center text-white space-x-4 flex-grow m-1 bg-panel p-4 rounded-md border border-gray-500">
        <div class="flex-grow">
          
          <p class="text-gray-300 text-xs">Next Game</p>
          <p class="text-4xl mt-2 mb-2 font-bold">00<span class="text-gray-300 text-xs ml-1">d</span> : 18<span class="text-gray-300 text-xs ml-1">h</span> : 55<span class="text-gray-300 text-xs ml-1">m</span></p>
          <p class="text-gray-300 text-xs">Sat 11th Nov, 12:30pm</p>
          
        </div>
      </div>
    </div>
  </div>
  
  <div class="bg-panel p-4 m-1 bg-panel p-4 rounded-md border border-gray-500">
    <ul class="flex">
      <li class="mr-4">
        <button
          class={`p-2 ${activeTab === 'fixtures' ? 'text-white' : 'text-gray-400'}`}
          on:click={() => setActiveTab('fixtures')}>
          Fixtures
        </button>
      </li>
      <li class="mr-4">
        <button
          class={`p-2 ${activeTab === 'points' ? 'text-white' : 'text-gray-400'}`}
          on:click={() => setActiveTab('points')}>
          Gameweek Points
        </button>
      </li>
    </ul>

    {#if activeTab === 'fixtures'}
      <FixturesComponent />
    {:else if activeTab === 'points'}
      <GamweekPointsComponents />
    {/if}
  </div>
  


</Layout>
