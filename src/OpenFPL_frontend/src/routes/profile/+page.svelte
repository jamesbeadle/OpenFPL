<script lang="ts">
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import ManagerGameweeks from "$lib/components/manager-gameweeks.svelte";
  import ProfileDetail from "$lib/components/profile/profile-detail.svelte";
  import Layout from "../Layout.svelte";
  import { Spinner } from "@dfinity/gix-components";
  let activeTab: string = "details";

  let isLoading = true;
  onMount(async () => {
    isLoading = false;
  });
  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  function viewGameweekDetail(principalId: string, selectedGameweek: number) {
    goto(`/manager?id=${principalId}&gw=${selectedGameweek}`);
  }
</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <div class="m-4">
      <div class="bg-panel rounded-lg m-4">
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
        {:else if activeTab === "gameweeks"}
          <ManagerGameweeks {viewGameweekDetail} />
        {/if}
      </div>
    </div>
  {/if}
</Layout>
