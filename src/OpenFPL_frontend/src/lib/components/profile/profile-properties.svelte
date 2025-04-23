<script lang="ts">
    import { clubStore } from "$lib/stores/club-store";
    import { userStore } from "$lib/stores/user-store";
    import { onMount } from "svelte";
    import UpdateFavouriteTeamModal from "./update-favourite-team-modal.svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { getDateFromBigInt } from "$lib/utils/helpers";
    import LoadingDots from "../shared/loading-dots.svelte";
    import CopyPrincipal from "./copy-principal.svelte";

    let isLoading = true;
    $: teamName = $clubStore.find((x) => x.id == $userStore?.favouriteClubId)?.friendlyName ?? "";
    let showFavouriteTeamModal: boolean = false;
    let username = "";
    let joinedDate = "";
    let gameweek: number = 1;
    let unsubscribeUserProfile: () => void;
  
    onMount(async () => {
      await userStore.sync();
      await storeManager.syncStores();

      unsubscribeUserProfile = userStore.subscribe((value) => {
        if (!value) { return; }
        username = value.username;
        joinedDate = getDateFromBigInt(Number(value.createDate));
      });
      isLoading = false;
    });
  
  $effect(() => {
      
  });


    function displayFavouriteTeamModal(): void {
      showFavouriteTeamModal = true;
    }
</script>
<div class="w-full mb-4 md:w-1/2 lg:w-2/3 xl:w-3/4 md:px-2 md:mb-0">
    <div class="px-4 mt-2 rounded-lg md:ml-4 md:px-4 md:mt-1">
      <p class="mb-1">Username:</p>
      <h2 class="mb-1 default-header md:mb-2">
        {#if isLoading}
          <LoadingDots />
        {:else}
          {username}
        {/if}
      </h2>
      <p class="mt-4 mb-1">Favourite Team:</p>
      <h2 class="mb-1 default-header md:mb-2">{teamName == "" ? "Not Set" : teamName}</h2>

      <p class="mt-4 mb-1">Joined:</p>
      <h2 class="mb-1 default-header md:mb-2">
        {#if isLoading}
          <LoadingDots />
        {:else}
          {joinedDate}
        {/if}</h2>
        <CopyPrincipal />
    </div>
  </div>
