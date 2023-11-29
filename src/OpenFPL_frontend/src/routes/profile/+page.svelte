<script lang="ts">
  import { onMount } from "svelte";
  import { redirect } from "@sveltejs/kit";
  import { isLoading } from "$lib/stores/global-stores";
  import ManagerGameweeks from "$lib/components/manager-gameweeks.svelte";
  import ProfileDetail from "$lib/components/profile/profile-detail.svelte";
  import Layout from "../Layout.svelte";
  let activeTab: string = "details";

  onMount(async () => {
    isLoading.set(false);
  });
  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  function viewGameweekDetail(principalId: string, selectedGameweek: number) {
    throw redirect(307, `/manager?id=${principalId}&gw=${selectedGameweek}`);
  }
</script>

<Layout>
  <div class="m-4">
    <div class="bg-panel rounded-lg m-4">
      <ul class="flex rounded-lg bg-light-gray px-4 pt-2">
        <li
          class={`mr-4 text-xs md:text-lg ${
            activeTab === "details" ? "active-tab" : ""
          }`}
        >
          <button
            class={`p-2 ${
              activeTab === "details" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("details")}>Details</button
          >
        </li>
        <li
          class={`mr-4 text-xs md:text-lg ${
            activeTab === "gameweeks" ? "active-tab" : ""
          }`}
        >
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
</Layout>
