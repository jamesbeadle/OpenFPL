<script lang="ts">
  import { onMount } from "svelte";
  import { userStore } from "$lib/stores/user-store";
  import { browser } from "$app/environment";

  import Layout from "../Layout.svelte";
  import ProfileDetail from "$lib/components/profile/profile-detail.svelte";
  import ProfileManagerGameweeks from "$lib/components/manager/profile-manager-gameweeks.svelte";
  import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
  import TabContainer from "$lib/components/shared/tab-container.svelte";
  import WelcomeBanner from "$lib/components/profile/welcome-banner.svelte";

  const tabs = [
    { id: "details", label: "Details", authOnly: false },
    { id: "gameweeks", label: "Gameweeks", authOnly: false }
  ];

  let activeTab: string = "details";
  let isLoading = true;
  let bannerVisible = false;

  const urlParams = browser ? new URLSearchParams(window.location.search) : null;
  const showWelcome = urlParams?.get('welcome') === 'true';

  onMount(async () => {
    await userStore.sync();
    bannerVisible = urlParams?.get('welcome') === 'true';
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
      {#if bannerVisible}
        <WelcomeBanner 
          bind:visible={bannerVisible}
        />
      {/if}
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