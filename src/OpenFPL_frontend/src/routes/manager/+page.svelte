<script lang="ts">
    import { onMount } from "svelte";
    import Layout from "../Layout.svelte";
    import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
    import { page } from "$app/stores";
    import ManagerGameweekDetails from "$lib/components/manager-gameweek-details.svelte";
    import ManagerGameweeks from "$lib/components/manager-gameweeks.svelte";
    
    let progress = 0;
    let isLoading = true;
    let activeTab: string = "details";
  
    $: id = $page.url.searchParams.get("id");
    onMount(async () => {
      try {
        
        //GET MANAGER

        isLoading = false;
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    });
  
    function setActiveTab(tab: string): void {
      activeTab = tab;
    }
  </script>
  
  <Layout>
    {#if isLoading}
      <LoadingIcon {progress} />
    {:else}
      <div class="m-4">
        <div class="flex flex-col md:flex-row">
            <div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
                <div class="flex-grow">
                  <p class="text-gray-300 text-xs">&nbsp</p>
                  <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                    Profile Picture
                  </p>
                  <p class="text-gray-300 text-xs">&nbsp</p>
                </div>
                <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;" />
                <div class="flex-grow">
                  <p class="text-gray-300 text-xs">Manager</p>
                  <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                    Name
                  </p>
                  <p class="text-gray-300 text-xs">Joined</p>
                </div>
                <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"/>
                <div class="flex-grow">
                  <p class="text-gray-300 text-xs">Favourite Team</p>
                  <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                    Team
                  </p>
                  <p class="text-gray-300 text-xs">???</p>
                </div>
            </div>
            <div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
                <div class="flex-grow">
                  <p class="text-gray-300 text-xs">Leaderboard Positions</p>
                  <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                    1 <span class="text-xs">(200)</span>
                  </p>
                  <p class="text-gray-300 text-xs">Weekly</p>
                </div>
                <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;" />
                <div class="flex-grow">
                    <p class="text-gray-300 text-xs">Leaderboard Positions</p>
                    <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                        1 <span class="text-xs">(200)</span>
                    </p>
                    <p class="text-gray-300 text-xs">Club</p>
                </div>
                <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"/>
                <div class="flex-grow">
                    <p class="text-gray-300 text-xs">Leaderboard Positions</p>
                    <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
                        1 <span class="text-xs">(2,000)</span>
                    </p>
                    <p class="text-gray-300 text-xs">Season</p>
                </div>
            </div>
        </div>
      </div>
  
      <div class="m-4">
        <div class="bg-panel rounded-md m-4">
          <ul class="flex bg-light-gray px-4 pt-2">
            <li class={`mr-4 text-xs md:text-lg ${ activeTab === "history" ? "active-tab" : "" }`}>
              <button class={`p-2 ${ activeTab === "history" ? "text-white" : "text-gray-400" }`} on:click={() => setActiveTab("history")}>
                Gameweek History
              </button>
            </li>
          </ul>
          {#if activeTab === "details"}
            <ManagerGameweekDetails />
          {/if}
          {#if activeTab === "gameweeks"}
            <ManagerGameweeks />
          {/if}
        </div>
      </div>
    {/if}
  </Layout>
  