<script lang="ts">
  import { onMount } from "svelte";
  import { isLoading } from "$lib/stores/global-stores";
  import Layout from "../Layout.svelte";
  import AdminFixtures from "$lib/components/admin/admin-fixtures.svelte";
  import SystemStateModal from "$lib/components/admin/system-state-modal.svelte";
  
  //get seasons for dropdown

  export let showModal: boolean = false;
  
  let activeTab: string = "fixtures";

  onMount(async () => {
    isLoading.set(false);
  });

  function displaySystemStateModal(): void {
    showModal = true;
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  function hideModal(): void {
    showModal = false;
  }

</script>

<Layout>
  <SystemStateModal
    showModal={showModal}
    closeModal={hideModal}
    cancelModal={hideModal}
    {isLoading}
  />
  <div class="m-4">
    <div class="bg-panel rounded-lg m-4">
      <div class="flex flex-col p-4">
        <h1 class="text-xl">OpenFPL Admin</h1>
        <p class="mt-2">This view is for testing purposes only.</p>
      </div>

      <div class="flex flex-row p-4 space-x-4">
        <button class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1" on:click={displaySystemStateModal}>System Status</button>
      </div>

      <ul class="flex rounded-t-lg bg-light-gray px-4 pt-2">
        <li class={`mr-4 text-xs md:text-base ${ activeTab === "fixtures" ? "active-tab" : ""}`}>
          <button class={`p-2 ${ activeTab === "fixtures" ? "text-white" : "text-gray-400" }`}
            on:click={() => setActiveTab("fixtures")}>Fixtures</button>
        </li>
      </ul>

      {#if activeTab === "fixtures"}
        <AdminFixtures />
      {/if}
    </div>
  </div>
</Layout>
