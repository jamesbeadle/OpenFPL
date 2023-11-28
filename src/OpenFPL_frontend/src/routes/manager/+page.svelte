<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { page } from "$app/stores";
  import { teamStore } from "$lib/stores/team-store";
  import { systemStore } from "$lib/stores/system-store";
  import { managerStore } from "$lib/stores/manager-store";
  import Layout from "../Layout.svelte";
  import ManagerGameweekDetails from "$lib/components/manager-gameweek-details.svelte";
  import ManagerGameweeks from "$lib/components/manager-gameweeks.svelte";
  import type {
    FantasyTeam,
    ManagerDTO,
    SystemState,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { Writable } from "svelte/store";
  import { toastStore } from "$lib/stores/toast-store";
  import { isLoading } from "$lib/stores/global-stores";

  let activeTab: string = "details";
  let manager: ManagerDTO;
  $: selectedGameweek = 1;
  let selectedSeason = "";
  let joinedDate = "";
  let profilePicture: string;
  let teams: Team[];
  let favouriteTeam: Team | null = null;
  let fantasyTeam: Writable<FantasyTeam | null>;
  let systemState: SystemState | null;
  
  let unsubscribeSystemState: () => void;
  let unsubscribeTeams: () => void;

  $: id = $page.url.searchParams.get("id");
  $: gw = Number($page.url.searchParams.get("gw")) ?? 0;
  onMount(async () => {
    isLoading.set(true);
    try {
      await systemStore.sync();
      await teamStore.sync();

      unsubscribeSystemState = systemStore.subscribe((value) => {
        systemState = value;
      });

      unsubscribeTeams = teamStore.subscribe((value) => {
        teams = value;
      });
   
      manager = await managerStore.getManager(
        id ?? "",
        systemState?.activeSeason.id ?? 1,
        gw && gw > 0 ? gw : systemState?.activeGameweek ?? 1
      );
      const blob = new Blob([new Uint8Array(manager.profilePicture)]);
      const blobUrl =
        manager.profilePicture.length > 0
          ? URL.createObjectURL(blob)
          : "profile_placeholder.png";
      profilePicture = blobUrl;

      const dateInMilliseconds = Number(manager.createDate / 1000000n);
      const date = new Date(dateInMilliseconds);
      const monthNames = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      joinedDate = `${monthNames[date.getUTCMonth()]} ${date.getUTCFullYear()}`;

      favouriteTeam =
        manager.favouriteTeamId > 0
          ? teams.find((x) => x.id == manager.favouriteTeamId) ?? null
          : null;
      isLoading.set(false);
    } catch (error) {
      toastStore.show("Error fetching manager details.", "error");
      console.error("Error fetching manager details:", error);
    }
  });

  onDestroy(() => {
    unsubscribeTeams?.();
    unsubscribeSystemState?.();
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  function viewGameweekDetail(principalId: string, selectedGameweek: number) {
    fantasyTeam.set(
      manager.gameweeks.find((x) => x.gameweek === selectedGameweek)!
    );
    setActiveTab("details");
  }
</script>

<Layout>
  <div class="m-4">
    <div class="flex flex-col md:flex-row">
      <div
        class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
      >
        <div class="flex">
          <img class="w-20" src={profilePicture} alt={manager.displayName} />
        </div>
        <div
          class="flex-shrink-0 w-px bg-gray-400 self-stretch"
          style="min-width: 2px; min-height: 50px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Manager</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
            {manager.displayName}
          </p>
          <p class="text-gray-300 text-xs">Joined: {joinedDate}</p>
        </div>
        <div
          class="flex-shrink-0 w-px bg-gray-400 self-stretch"
          style="min-width: 2px; min-height: 50px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Favourite Team</p>
          <p
            class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold flex items-center"
          >
            <BadgeIcon
              className="w-7 mr-2"
              primaryColour={favouriteTeam?.primaryColourHex}
              secondaryColour={favouriteTeam?.secondaryColourHex}
              thirdColour={favouriteTeam?.thirdColourHex}
            />
            {favouriteTeam?.abbreviatedName}
          </p>
          <p class="text-gray-300 text-xs">{favouriteTeam?.name}</p>
        </div>
      </div>
      <div
        class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
      >
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">Leaderboards</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
            {manager.weeklyPositionText}
            <span class="text-xs"
              >({manager.weeklyPoints.toLocaleString()})</span
            >
          </p>
          <p class="text-gray-300 text-xs">Weekly</p>
        </div>
        <div
          class="flex-shrink-0 w-px bg-gray-400 self-stretch"
          style="min-width: 2px; min-height: 50px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">{favouriteTeam?.friendlyName}</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
            {manager.monthlyPositionText}
            <span class="text-xs"
              >({manager.monthlyPoints.toLocaleString()})</span
            >
          </p>
          <p class="text-gray-300 text-xs">Club</p>
        </div>
        <div
          class="flex-shrink-0 w-px bg-gray-400 self-stretch"
          style="min-width: 2px; min-height: 50px;"
        />
        <div class="flex-grow">
          <p class="text-gray-300 text-xs">{selectedSeason}</p>
          <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
            {manager.seasonPositionText}
            <span class="text-xs"
              >({manager.seasonPoints.toLocaleString()})</span
            >
          </p>
          <p class="text-gray-300 text-xs">Season</p>
        </div>
      </div>
    </div>

    <div class="flex flex-col bg-panel m-4 rounded-md">
      <div
        class="flex justify-between items-center text-white px-4 pt-4 rounded-md w-full"
      >
        <div class="flex">
          <button
            class={`btn ${
              activeTab === "details" ? `fpl-button` : `inactive-btn`
            } px-4 py-2 rounded-l-md font-bold text-md min-w-[125px]`}
            on:click={() => setActiveTab("details")}
          >
            Details
          </button>
          <button
            class={`btn ${
              activeTab === "gameweeks" ? `fpl-button` : `inactive-btn`
            } px-4 py-2 rounded-r-md font-bold text-md min-w-[125px]`}
            on:click={() => setActiveTab("gameweeks")}
          >
            Gameweeks
          </button>
        </div>

        <div class="px-4">
          {#if activeTab === "details"}<span class="text-2xl"
              >Total Points: {0}</span
            >{/if}
        </div>
      </div>

      <div class="w-full">
        {#if activeTab === "details"}
          <ManagerGameweekDetails {selectedGameweek} {fantasyTeam} />
        {/if}
        {#if activeTab === "gameweeks"}
          <ManagerGameweeks
            {viewGameweekDetail}
            principalId={manager.principalId}
          />
        {/if}
      </div>
    </div>
  </div>
</Layout>
