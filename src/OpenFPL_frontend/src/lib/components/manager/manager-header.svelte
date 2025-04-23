<script lang="ts">
    import { onMount } from "svelte";
    import HeaderContentPanel from "../shared/panels/header-content-panel.svelte";
    import { clubStore } from "$lib/stores/club-store";
    import { getProfilePictureString } from "$lib/derived/user.derived";
    import { getDateFromBigInt } from "$lib/utils/helpers";
    import PageHeader from "../shared/panels/page-header.svelte";
    import ContentPanel from "../shared/panels/content-panel.svelte";
    import ManagerFavouriteTeamPanel from "./manager-favourite-team-panel.svelte";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import type { Manager, Club } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    interface Props {
      manager: Manager;
    }
    let { manager }: Props = $props();
    
    let isLoading = true;
    let joinedDate = "";
    let profilePicture: string;
    let favouriteTeam = $state<Club | null>(null);
    let displayName = "";
    let selectedSeason = "";

    onMount(async () => {
      displayName = manager.username === manager.principalId ? "Unknown" : manager.username;
      profilePicture = getProfilePictureString(manager);
      joinedDate = getDateFromBigInt(Number(manager.createDate));

      favouriteTeam = manager.favouriteClubId 
          ? $clubStore.find((x) => x.id == manager.favouriteClubId[0]) ?? null
          : null;
      isLoading = false;
    });
</script>
<PageHeader>
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <ContentPanel>
      <div class="flex">
        <img class="w-20" src={profilePicture} alt={displayName} />
      </div>
      <div class="vertical-divider"></div>
      <HeaderContentPanel header="Manager" content={displayName} footer={`Joined: ${joinedDate}`} loading={false} />
      <div class="vertical-divider"></div>
      <ManagerFavouriteTeamPanel {favouriteTeam} />
    </ContentPanel>
    <ContentPanel>
      <HeaderContentPanel header="Leaderboards" content={`${manager.weeklyPosition} (${manager.weeklyPoints.toLocaleString()})`} footer="Weekly" loading={isLoading} />
      <div class="vertical-divider"></div>
      <HeaderContentPanel header={favouriteTeam?.friendlyName ?? "Not Entered"} content={`${manager.monthlyPosition} (${manager.monthlyPoints.toLocaleString()})`} footer="Club" loading={isLoading} />
      <div class="vertical-divider"></div>
      <HeaderContentPanel header={selectedSeason} content={`${manager.seasonPosition} (${manager.seasonPoints.toLocaleString()})`} footer="Season" loading={isLoading} />
    </ContentPanel>
  {/if}
</PageHeader>
