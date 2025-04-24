<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { browser } from "$app/environment";

  import ProfileDetail from "$lib/components/profile/details/profile-detail.svelte";
  import ProfileManagerGameweeks from "$lib/components/manager/profile-manager-gameweeks.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";
  import WelcomeBanner from "$lib/components/profile/welcome-banner.svelte";
  import LocalSpinner from "$lib/components/shared/local-spinner.svelte";

  const tabs = [
    { id: "details", label: "Details", authOnly: false },
    { id: "gameweeks", label: "Gameweeks", authOnly: false }
  ];

  let activeTab: string =$state("details");
  let isLoading = $state(true);
  let bannerVisible = $state(false);

  const urlParams = browser ? new URLSearchParams(window.location.search) : null;

  onMount(async () => {
    await userStore.sync();
    bannerVisible = urlParams?.get('welcome') === 'true';
    isLoading = false;
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }
</script>

  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="m-4">
      {#if bannerVisible}
        <WelcomeBanner 
          visible={bannerVisible}
        />
      {/if}
      <div class="bg-panel">

        <TabContainer {tabs} {activeTab} {setActiveTab}  />

        {#if activeTab === "details"}
          <ProfileDetail />
        {/if}

        {#if activeTab === "gameweeks" && $userStore}
          <ProfileManagerGameweeks principalId={$userStore.principalId} />
        {/if}

      </div>
    </div>
  {/if}