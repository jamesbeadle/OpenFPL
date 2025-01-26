<script lang="ts">
    import CopyIcon from "$lib/icons/CopyIcon.svelte";
    import { clubStore } from "$lib/stores/club-store";
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import UpdateFavouriteTeamModal from "./update-favourite-team-modal.svelte";
    import UpdateUsernameModal from "./update-username-modal.svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { getDateFromBigInt } from "$lib/utils/helpers";
    import { authStore } from "$lib/stores/auth.store";
    import { appStore } from "$lib/stores/app-store";
    import LoadingDots from "../shared/loading-dots.svelte";

    let isLoading = true;
    $: teamName = $clubStore.find((x) => x.id == $userStore?.favouriteClubId)?.friendlyName ?? "";
    let showUsernameModal: boolean = false;
    let showFavouriteTeamModal: boolean = false;
    let username = "Not Set";
    let joinedDate = "";
    let gameweek: number = 1;
    let unsubscribeUserProfile: () => void;
  
    onMount(async () => {
      await userStore.sync();
      await storeManager.syncStores();

      unsubscribeUserProfile = userStore.subscribe((value) => {
        console.log("found user")
        console.log(value)
        if (!value) { return; }
        username = value.username;
        joinedDate = getDateFromBigInt(Number(value.createDate));
      });
      isLoading = false;
    });

  function displayUsernameModal(): void {
    showUsernameModal = true;
  }

  function displayFavouriteTeamModal(): void {
    showFavouriteTeamModal = true;
  }

  async function copyTextAndShowToast() {
    await appStore.copyTextAndShowToast($userStore ? $userStore.principalId : "");
  }
</script>
<div class="w-full md:w-1/2 lg:w-2/3 xl:w-3/4 md:px-2 mb-4 md:mb-0">
    <div class="md:ml-4 md:px-4 px-4 mt-2 md:mt-1 rounded-lg">
      <p class="mb-1">Username:</p>
      <h2 class="default-header mb-1 md:mb-2">
        {#if isLoading}
          <LoadingDots />
        {:else}
          {username}
        {/if}
      </h2>
      <button class="p-1 md:p-2 px-2 md:px-4 fpl-button" on:click={displayUsernameModal}>Update</button>
      <p class="mb-1 mt-4">Favourite Team:</p>
      <h2 class="default-header mb-1 md:mb-2">{teamName == "" ? "Not Set" : teamName}</h2>
      
      {#if isLoading}
          <LoadingDots />
        {:else}
        <button
          class={`p-1 md:p-2 px-2 md:px-4 ${
            gameweek > 1 && ($userStore?.favouriteClubId ?? 0) > 0
              ? "bg-gray-500"
              : "fpl-button"
          } rounded`}
          on:click={displayFavouriteTeamModal}
          disabled={gameweek > 1 && ($userStore?.favouriteClubId ?? 0) > 0}
        >
          Update
        </button>
        {/if}

      <p class="mb-1 mt-4">Joined:</p>
      <h2 class="default-header mb-1 md:mb-2">
        {#if isLoading}
          <LoadingDots />
        {:else}
          {joinedDate}
        {/if}</h2>
      <p class="mb-1">Principal:</p>
      <div class="flex items-center">
        <button class="flex items-center text-left" on:click={copyTextAndShowToast}>
          <span>
            {#if isLoading}
              <LoadingDots />
            {:else}
              {$authStore.identity?.getPrincipal().toText()}
            {/if}
          </span>
          <CopyIcon className="w-7 xs:w-6 text-left" fill="#FFFFFF" />
        </button>
      </div>
    </div>
  </div>
  {#if !isLoading}
  <UpdateUsernameModal
    newUsername={$userStore.username}
    bind:visible={showUsernameModal}
  />
  <UpdateFavouriteTeamModal
    newFavouriteTeam={$userStore.favouriteClubId}
    bind:visible={showFavouriteTeamModal}
  />
  {/if}