<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import AdminFixtures from "$lib/components/admin/admin-fixtures.svelte";
  import SystemStateModal from "$lib/components/admin/system-state-modal.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  export let showSystemStateModal: boolean = false;

  let activeTab: string = "fixtures";
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
</script>

<Layout>
  {#if isLoading}
    <LoadingIcon />
  {:else}
    <SystemStateModal
      visible={showSystemStateModal}
      closeModal={hideSystemStateModal}
      cancelModal={hideSystemStateModal}
    />
    <div class="m-4">
      <div class="bg-panel rounded-lg m-4">
        <div class="flex flex-col p-4">
          <h1 class="text-xl">OpenFPL Admin</h1>
          <p class="mt-2">This view is for testing purposes only.</p>
        </div>

        <div class="flex flex-row p-4 space-x-4">
          <button
            class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
            on:click={displaySystemStateModal}>System Status</button
          >
        </div>

        <ul class="flex rounded-t-lg bg-light-gray px-4 pt-2">
          <li
            class={`mr-4 text-xs md:text-base ${
              activeTab === "fixtures" ? "active-tab" : ""
            }`}
          >
            <button
              class={`p-2 ${
                activeTab === "fixtures" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("fixtures")}>Fixtures</button
            >
          </li>
        </ul>

        {#if activeTab === "fixtures"}
          <AdminFixtures />
        {/if}
      </div>
    </div>
  {/if}
</Layout>
