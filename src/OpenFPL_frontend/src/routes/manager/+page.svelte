<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { page } from "$app/stores";
  import { systemStore } from "$lib/stores/system-store";
  import { teamStore } from "$lib/stores/team-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import type {
    FantasyTeamSnapshot,
    ManagerDTO,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import Layout from "../Layout.svelte";
  import ManagerGameweekDetails from "$lib/components/manager-gameweek-details.svelte";
  import ManagerGameweeks from "$lib/components/manager-gameweeks.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { Spinner } from "@dfinity/gix-components";
  import { getDateFromBigInt } from "$lib/utils/Helpers";

  $: id = $page.url.searchParams.get("id");

  let activeTab: string = "details";
  let fantasyTeam: Writable<FantasyTeamSnapshot | null> = writable(null);
  let selectedGameweek: Writable<number> = writable(
    Number($page.url.searchParams.get("gw")) ?? 1
  );

  let manager: ManagerDTO;
  let displayName = "";
  let favouriteTeam: Team | null = null;
  let selectedSeason = "";
  let joinedDate = "";
  let profilePicture: string;
  let isLoading = true;
  let loadingGameweekDetail: Writable<boolean> = writable(false);

  onMount(async () => {
    try {
      await systemStore.sync();
      await teamStore.sync();
      manager = await managerStore.getManager(
        id ?? "",
        $systemStore?.activeSeason.id ?? 1,
        $selectedGameweek ?? 1
      );
      displayName =
        manager.displayName === manager.principalId
          ? "Unknown"
          : manager.displayName;
      const blob = new Blob([new Uint8Array(manager.profilePicture)]);
      const blobUrl =
        manager.profilePicture.length > 0
          ? URL.createObjectURL(blob)
          : "profile_placeholder.png";
      profilePicture = blobUrl;
      selectedSeason = $systemStore?.activeSeason.name ?? "-";

      joinedDate = getDateFromBigInt(Number(manager.createDate));
      favouriteTeam =
        manager.favouriteTeamId > 0
          ? $teamStore.find((x) => x.id == manager.favouriteTeamId) ?? null
          : null;
      viewGameweekDetail(manager.principalId, $selectedGameweek!);
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

  function viewGameweekDetail(principalId: string, gw: number) {
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
    <Spinner />
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
            {favouriteTeam?.friendlyName ?? "Not Entered"}
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
            {selectedGameweek}
            principalId={manager.principalId}
          />
        {/if}
      </div>
    </div>
  {/if}
</Layout>
