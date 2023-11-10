
<script lang="ts">
  import Layout from './Layout.svelte';
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponents from "$lib/components/gameweek-points.svelte";
  let activeTab: string = 'fixtures';

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>

  <div class="bg-gray-700 p-4 m-1">
    <div class="flex justify-between items-center text-white">
      <div>
        <p>Game week</p>
        <p class="text-xl font-bold">12</p>
        <p>2023/24</p>
      </div>
      <div>
        <p>Managers</p>
        <p class="text-xl font-bold">200</p>
        <p>Total</p>
      </div>
      <div>
        <p>Weekly Prize Pool</p>
        <p class="text-xl font-bold">0</p>
        <p>$FPL</p>
      </div>
      <div>
        <p>Upcoming Game</p>
        <p class="text-xl font-bold">00 : 18 : 55</p>
        <div class="flex items-center">
          <p>WOL</p>
          <p class="mx-2">vs</p>
          <p>TOT</p>
        </div>
      </div>
    </div>
  </div>

  <div class="bg-gray-800 p-4 m-1">
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
