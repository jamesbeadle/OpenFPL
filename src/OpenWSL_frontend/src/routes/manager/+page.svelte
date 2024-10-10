<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { page } from "$app/stores";
  import { systemStore } from "$lib/stores/system-store";
  import { clubStore } from "$lib/stores/club-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import type {
    FantasyTeamSnapshot,
    ClubDTO,
    ManagerDTO,
  } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import Layout from "../Layout.svelte";
  import ManagerGameweekDetails from "$lib/components/manager/manager-gameweek-details.svelte";
  import ManagerGameweeks from "$lib/components/manager/manager-gameweeks.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { getDateFromBigInt } from "$lib/utils/helpers";
    import LocalSpinner from "$lib/components/local-spinner.svelte";
    import { storeManager } from "$lib/managers/store-manager";

  $: id = $page.url.searchParams.get("id");

  let activeTab: string = "details";
  let fantasyTeam: Writable<FantasyTeamSnapshot | null> = writable(null);
  let selectedGameweek: Writable<number> = writable(
    Number($page.url.searchParams.get("gw")) ?? 1
  );

  let manager: ManagerDTO;
  let displayName = "";
  let favouriteTeam: ClubDTO | null = null;
  let selectedSeason = "";
  let joinedDate = "";
  let profilePicture: string;
  let isLoading = true;
  let loadingGameweekDetail: Writable<boolean> = writable(false);

  onMount(async () => {
    try {
      await storeManager.syncStores();
      manager = await managerStore.getPublicProfile(id ?? "");
      if(!manager){
        return;
      }
      displayName =
        manager.username === manager.principalId ? "Unknown" : manager.username;

      let profilePicture = manager?.profilePicture as unknown as string;
      let profileSrc =
        typeof profilePicture === "string" &&
        profilePicture.startsWith("data:image")
          ? profilePicture
          : "/profile_placeholder.png";
      profilePicture = profileSrc;

      joinedDate = getDateFromBigInt(Number(manager.createDate));

      /* //TODO
      favouriteTeam =
        manager.favouriteClubId > 0
          ? $clubStore.find((x) => x.id == manager.favouriteClubId) ?? null
          : null;
      viewGameweekDetail($selectedGameweek!);
      */
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching manager details." },
        err: error,
      });
      console.error("Error fetching manager details:", error);
    } finally {
      isLoading = false;
    }
  });

  function setActiveTab(tab: string): void {
    if (tab === "details") {
      $loadingGameweekDetail = true;
    }
    activeTab = tab;
  }

  function viewGameweekDetail(gw: number) {
    $selectedGameweek = gw;
    let team = manager.gameweeks.find((x) => x.gameweek === $selectedGameweek)!;
    if (team) {
      fantasyTeam.set(team);
    } else {
      fantasyTeam.set(null);
    }
    setActiveTab("details");
  }
</script>

<Layout>
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="page-header-wrapper flex">
      <div class="content-panel lg:w-1/2">
        <div class="flex">
          <img class="w-20" src={profilePicture} alt={displayName} />
        </div>

        <div class="vertical-divider" />

        <div class="flex-grow">
          <p class="content-panel-header">Manager</p>
          <p class="content-panel-stat">
            {displayName}
          </p>
          <p class="content-panel-header">
            Joined: {joinedDate}
          </p>
        </div>

        <div class="vertical-divider" />

        <div class="flex-grow">
          <!-- //TODO
          <p class="content-panel-header">Favourite Team</p>
          <p class="content-panel-stat flex items-center">
            <BadgeIcon
              className="w-7 mr-2"
              primaryColour={favouriteTeam?.primaryColourHex ?? "#2CE3A6"}
              secondaryColour={favouriteTeam?.secondaryColourHex ?? "#FFFFFF"}
              thirdColour={favouriteTeam?.thirdColourHex ?? "#000000"}
            />
            {favouriteTeam?.abbreviatedName ?? "-"}
          </p>
          <p class="content-panel-header">
            {favouriteTeam?.name ?? "Not Set"}
          </p>
          -->
        </div>
      </div>
      <div class="content-panel lg:w-1/2">
        <div class="flex-grow">
          <p class="content-panel-header">Leaderboards</p>
          <p class="content-panel-stat">
            {manager.weeklyPosition}
            <span class="text-xs"
              >({manager.weeklyPoints.toLocaleString()})</span
            >
          </p>
          <p class="content-panel-header">Weekly</p>
        </div>

        <div class="vertical-divider" />
        <div class="flex-grow">
          <p class="content-panel-header">
            <!-- //TODO
            {favouriteTeam?.friendlyName ?? "Not Entered"}
            -->
          </p>
          <p class="content-panel-stat">
            {manager.monthlyPosition}
            <span class="text-xs"
              >({favouriteTeam
                ? manager.monthlyPoints.toLocaleString()
                : "-"})</span
            >
          </p>
          <p class="content-panel-header">Club</p>
        </div>
        <div class="vertical-divider" />
        <div class="flex-grow">
          <p class="content-panel-header">
            {selectedSeason}
          </p>
          <p class="content-panel-stat">
            {manager.seasonPosition}
            <span class="text-xs"
              >({manager.seasonPoints.toLocaleString()})</span
            >
          </p>
          <p class="content-panel-header">Season</p>
        </div>
      </div>
    </div>

    <div class="bg-panel rounded-md">
      <div class="flex flex-row ml-3 md:justify-between md:items-center">
        <div class="flex">
          <button
            class={`btn ${
              activeTab === "details" ? `fpl-button` : `inactive-btn`
            } tab-switcher-label rounded-l-md`}
            on:click={() => setActiveTab("details")}
          >
            Details
          </button>
          <button
            class={`btn ${
              activeTab === "gameweeks" ? `fpl-button` : `inactive-btn`
            } tab-switcher-label rounded-r-md`}
            on:click={() => setActiveTab("gameweeks")}
          >
            Gameweeks
          </button>
        </div>

        <div class="px-4 hidden lg:flex md:mr-8">
          {#if $fantasyTeam && activeTab === "details"}
            <span>Total Points: {$fantasyTeam?.points}</span>
          {/if}
        </div>
      </div>

      <div class="flex px-4 lg:hidden mb-2">
        {#if $fantasyTeam && activeTab === "details"}
          <span>Total Points: {$fantasyTeam?.points}</span>
        {/if}
      </div>

      <div class="w-full">
        {#if activeTab === "details"}
          <ManagerGameweekDetails
            loadingGameweek={loadingGameweekDetail}
            {selectedGameweek}
            {fantasyTeam}
          />
        {/if}
        {#if activeTab === "gameweeks"}
          <ManagerGameweeks
            {viewGameweekDetail}
            principalId={manager.principalId}
          />
        {/if}
      </div>
    </div>
  {/if}
</Layout>
