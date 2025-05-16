<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";

  import TabContainer from "$lib/components/shared/global/tab-container.svelte";
  import ProfileDetail from "$lib/components/profile/details/profile-detail.svelte";
  import ProfileManagerGameweeks from "$lib/components/manager/profile-manager-gameweeks.svelte";
  import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";

  const tabs = [
    { id: "details", label: "Details", authOnly: false },
    { id: "gameweeks", label: "Gameweeks", authOnly: false }
  ];

  let activeTab: string =$state("details");
  let isLoading = $state(true);

  onMount(async () => {
    await userStore.sync();
    isLoading = false;
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

{#if isLoading}
  <LocalSpinner />
{:else}
  <TabContainer {tabs} {activeTab} {setActiveTab}  />

  {#if activeTab === "details"}
    <ProfileDetail />
  {/if}
  
  {#if activeTab === "gameweeks" && $userStore}
    <ProfileManagerGameweeks principalId={$userStore.principalId} />
  {/if}
{/if}