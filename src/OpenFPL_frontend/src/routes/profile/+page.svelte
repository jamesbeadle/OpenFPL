<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";

  import Layout from "../Layout.svelte";
  import ProfileDetail from "$lib/components/profile/profile-detail.svelte";
  import ProfileManagerGameweeks from "$lib/components/manager/profile-manager-gameweeks.svelte";
  import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";

  const tabs = [
    { id: "details", label: "Details", authOnly: false },
    { id: "gameweeks", label: "Gameweeks", authOnly: false }
  ];

  let activeTab: string = "details";
  let isLoading = true;

  onMount(async () => {
    await userStore.sync();
    isLoading = false;
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

<Layout>
  {#if isLoading}
    <WidgetSpinner />
  {:else}
    <div class="m-4">
      <div class="bg-panel">

        <TabContainer {tabs} {activeTab} {setActiveTab} isLoggedIn={false}  />

        {#if activeTab === "details"}
          <ProfileDetail />
        {/if}

        {#if activeTab === "gameweeks" && $userStore}
          <ProfileManagerGameweeks principalId={$userStore.principalId} />
        {/if}

      </div>
    </div>
  {/if}
</Layout>