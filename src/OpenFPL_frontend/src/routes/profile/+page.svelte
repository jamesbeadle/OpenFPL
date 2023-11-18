<script lang="ts">
  import ManagerGameweeks from "$lib/components/manager-gameweeks.svelte";
  import ProfileDetail from "$lib/components/profile-detail.svelte";
  import Layout from "../Layout.svelte";
  let activeTab: string = "details";
  
  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>


<Layout>
  <div class="m-4">
    <div class="bg-panel rounded-lg m-4">
      <ul class="flex rounded-lg bg-light-gray px-4 pt-2">
        <li class={`mr-4 text-xs md:text-lg ${activeTab === "details" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "details" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("details")}
          >
            Details
          </button>
        </li>
        <li class={`mr-4 text-xs md:text-lg ${activeTab === "gameweeks" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "gameweeks" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("gameweeks")}
          >
            Gameweeks
          </button>
        </li>
      </ul>
  
      {#if activeTab === "details"}
        <ProfileDetail />
      {:else if activeTab === "gameweeks"}
        <ManagerGameweeks />
      {/if}
  
    </div>
  </div>
</Layout>
