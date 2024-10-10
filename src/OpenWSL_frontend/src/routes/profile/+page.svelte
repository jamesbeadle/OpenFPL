<script lang="ts">
  import { onMount } from "svelte";
  import ProfileDetail from "$lib/components/profile/profile-detail.svelte";
  import Layout from "../Layout.svelte";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import ManagerGameweeks from "$lib/components/manager/manager-gameweeks.svelte";
  import { userStore } from "$lib/stores/user-store";

  let activeTab: string = "details";
  let isLoading = true;
  onMount(async () => {
    try{
      userStore.sync();
    }
    catch (err){
      console.error("Error loading auth details");
    }
    finally{
      isLoading = false;
    };
  });
  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
  function viewGameweekDetail() {

  }
</script>

<Layout>
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="m-4">
      <div class="bg-panel rounded-md">
        <ul
          class="flex rounded-t-lg bg-light-gray border-b border-gray-700 px-4 pt-2"
        >
          <li class={`mr-4 ${activeTab === "details" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "details" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("details")}>Details</button
            >
          </li>
          <li class={`mr-4 ${activeTab === "gameweeks" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "gameweeks" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("gameweeks")}>Gameweeks</button
            >
          </li>
        </ul>

        {#if activeTab === "details"}
          <ProfileDetail />
        {/if}
        {#if activeTab === "gameweeks" && $userStore}
          <ManagerGameweeks
            {viewGameweekDetail}
            principalId={$userStore.principalId}
          />
        {/if}

      </div>
    </div>
  {/if}
</Layout>
