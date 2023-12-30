<script lang="ts">
  import { onMount } from "svelte";
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
</script>

<Layout>
  {#if isLoading}
    <Spinner />
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
        </ul>

        {#if activeTab === "details"}
          <ProfileDetail />
        {/if}
      </div>
    </div>
  {/if}
</Layout>
