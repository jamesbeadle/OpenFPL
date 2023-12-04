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
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  $: id = $page.url.searchParams.get("id");
  $: gw = Number($page.url.searchParams.get("gw")) ?? 0;
  $: selectedGameweek = gw;

  let activeTab: string = "details";

  let fantasyTeam: Writable<FantasyTeamSnapshot | null> = writable(null);

  let manager: ManagerDTO;
  let displayName = "";
  let favouriteTeam: Team | null = null;
  let selectedSeason = "";
  let joinedDate = "";
  let profilePicture: string;
  let isLoading = true;

  onMount(async () => {
    try {
      await systemStore.sync();
      await teamStore.sync();

      manager = await managerStore.getManager(
        id ?? "",
        $systemStore?.activeSeason.id ?? 1,
        gw && gw > 0 ? gw : $systemStore?.focusGameweek ?? 1
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
          ? $teamStore.find((x) => x.id == manager.favouriteTeamId) ?? null
          : null;
      viewGameweekDetail(manager.principalId, selectedGameweek);
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
    activeTab = tab;
  }

  function viewGameweekDetail(principalId: string, selectedGameweek: number) {
    let team = manager.gameweeks.find((x) => x.gameweek === selectedGameweek)!;
    fantasyTeam.set(team);
    console.log("$fantasyTeam");
    console.log($fantasyTeam);
    setActiveTab("details");
  }
</script>

<Layout>
  {#if isLoading}
    <LoadingIcon />
  {:else}
    <div class="m-4">
      <div class="flex flex-col md:flex-row">
        <div
          class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex">
            <img class="w-20" src={profilePicture} alt={displayName} />
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Manager</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {displayName}
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
                primaryColour={favouriteTeam?.primaryColourHex ?? "#2CE3A6"}
                secondaryColour={favouriteTeam?.secondaryColourHex ?? "#FFFFFF"}
                thirdColour={favouriteTeam?.thirdColourHex ?? "#000000"}
              />
              {favouriteTeam?.abbreviatedName ?? "-"}
            </p>
            <p class="text-gray-300 text-xs">
              {favouriteTeam?.name ?? "Not Set"}
            </p>
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
            <p class="text-gray-300 text-xs">
              {favouriteTeam?.friendlyName ?? "Not Entered"}
            </p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {manager.monthlyPositionText}
              <span class="text-xs"
                >({favouriteTeam
                  ? manager.monthlyPoints.toLocaleString()
                  : "-"})</span
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
            {#if activeTab === "details"}
              <span class="text-2xl">Total Points: {$fantasyTeam?.points}</span>
            {/if}
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
  {/if}
</Layout>
