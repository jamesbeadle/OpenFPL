<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import AdminCanisters from "$lib/components/admin/admin-canisters.svelte";
  import AdminClubs from "$lib/components/admin/admin-clubs.svelte";
  import AdminFixtures from "$lib/components/admin/admin-fixtures.svelte";
  import AdminPlayers from "$lib/components/admin/admin-players.svelte";
  import AdminTimers from "$lib/components/admin/admin-timers.svelte";
  import SystemStateModal from "$lib/components/admin/system-state-modal.svelte";
  import SnapshotFantasyTeams from "$lib/components/admin/snapshot-fantasy-teams.svelte";
  import { Spinner } from "@dfinity/gix-components";
  import AdminManagers from "$lib/components/admin/admin-managers.svelte";

  export let showSystemStateModal: boolean = false;
  export let showSnapshotModal: boolean = false;

  let activeTab: string = "canisters";
  let isLoading = true;

  onMount(async () => {
    isLoading = false;
  });

  function displaySystemStateModal(): void {
    showSystemStateModal = true;
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  function hideSystemStateModal(): void {
    showSystemStateModal = false;
  }

  function displaySnapshotModal(): void {
    showSnapshotModal = true;
  }

  function hideSnapshotModal(): void {
    showSnapshotModal = false;
  }
</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <SystemStateModal
      visible={showSystemStateModal}
      closeModal={hideSystemStateModal}
      cancelModal={hideSystemStateModal}
    />
    <SnapshotFantasyTeams
      visible={showSnapshotModal}
      closeModal={hideSnapshotModal}
      cancelModal={hideSnapshotModal}
    />
    <div class="m-4">
      <div class="bg-panel rounded-md">
        <div class="flex flex-col p-4">
          <h1 class="text-xl">OpenFPL Admin</h1>
          <p class="mt-2">This view is for testing purposes only.</p>
        </div>

        <div class="flex flex-row p-4 space-x-4">
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1"
            on:click={displaySystemStateModal}>System Status</button
          >
          <button
            class="rounded fpl-button px-3 sm:px-2 px-3 py-1"
            on:click={displaySnapshotModal}>Snapshot Fantasy Teams</button
          >
        </div>

        <ul
          class="flex rounded-t-lg bg-light-gray px-4 pt-2 border-b border-gray-700"
        >
          <li class={`mr-4 ${activeTab === "canisters" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "canisters" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("canisters")}>Canisters</button
            >
          </li>
          <li class={`mr-4 ${activeTab === "timers" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "timers" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("timers")}>Timers</button
            >
          </li>
          <li class={`mr-4 ${activeTab === "fixtures" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "fixtures" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("fixtures")}>Fixtures</button
            >
          </li>
          <li class={`mr-4 ${activeTab === "clubs" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "clubs" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("clubs")}>Clubs</button
            >
          </li>
          <li class={`mr-4 ${activeTab === "players" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "players" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("players")}>Players</button
            >
          </li>
          <li class={`mr-4 ${activeTab === "managers" ? "active-tab" : ""}`}>
            <button
              class={`p-2 ${
                activeTab === "managers" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("managers")}>Managers</button
            >
          </li>
        </ul>

        {#if activeTab === "canisters"}
          <AdminCanisters />
        {:else if activeTab === "timers"}
          <AdminTimers />
        {:else if activeTab === "fixtures"}
          <AdminFixtures />
        {:else if activeTab === "clubs"}
          <AdminClubs />
        {:else if activeTab === "players"}
          <AdminPlayers />
        {:else if activeTab === "managers"}
          <AdminManagers />
        {/if}
      </div>
    </div>
  {/if}
</Layout>
