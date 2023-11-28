<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import { page } from "$app/stores";
  import ManagerGameweekDetails from "$lib/components/manager-gameweek-details.svelte";
  import ManagerGameweeks from "$lib/components/manager-gameweeks.svelte";
  import { ManagerService } from "$lib/services/ManagerService";
  import type { FantasyTeam, ManagerDTO, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { SystemService } from "$lib/services/SystemService";
  import { TeamService } from "$lib/services/TeamService";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Writable } from "svelte/store";

  let progress = 0;
  let isLoading = true;
  let activeTab: string = "details";
  let manager: ManagerDTO;
  $: selectedGameweek = 1;
  let selectedSeason = "";
  let joinedDate = "";
  let profilePicture: string;
  let teams: Team[];
  let favouriteTeam: Team | null = null;
  let fantasyTeam: Writable<FantasyTeam | null>;

  $: id = $page.url.searchParams.get("id");
  $: gw = Number($page.url.searchParams.get("gw"));
  onMount(async () => {
    try {
      let systemService = new SystemService();
      let managerService = new ManagerService();
      let teamService = new TeamService();

      let systemState = await systemService.getSystemState();
      selectedGameweek = gw ? gw : systemState?.activeGameweek ?? 1;
      selectedSeason = systemState?.activeSeason.name ?? "";

      manager = await managerService.getManager(id ?? "", systemState?.activeSeason.id ?? 1, systemState?.activeGameweek ?? 1);
      const blob = new Blob([new Uint8Array(manager.profilePicture)]);
      const blobUrl = manager.profilePicture.length > 0 ? URL.createObjectURL(blob) : "profile_placeholder.png";
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

      teams = await teamService.getTeams();
      favouriteTeam =
        manager.favouriteTeamId > 0
          ? teams.find((x) => x.id == manager.favouriteTeamId) ?? null
          : null;

      isLoading = false;
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  function viewGameweekDetail(gameweekTeam: FantasyTeam){
    fantasyTeam.set(gameweekTeam);
    setActiveTab('details');
  }
</script>

<Layout>
  {#if isLoading}
    <LoadingIcon {progress} />
  {:else}
    <div class="m-4">
      <div class="flex flex-col md:flex-row">
        <div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
          <div class="flex">
            <img class="w-20" src={profilePicture} alt={manager.displayName} />
          </div>
          <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"/>
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Manager</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {manager.displayName}
            </p>
            <p class="text-gray-300 text-xs">Joined: {joinedDate}</p>
          </div>
          <div class="flex-shrink-0 w-px bg-gray-400 self-stretch" style="min-width: 2px; min-height: 50px;"/>
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Favourite Team</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold flex items-center">
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
        <div class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md">
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Leaderboards</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {manager.weeklyPositionText} <span class="text-xs">({manager.weeklyPoints.toLocaleString()})</span>
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
              {manager.monthlyPositionText} <span class="text-xs">({manager.monthlyPoints.toLocaleString()})</span>
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
              {manager.seasonPositionText} <span class="text-xs">({manager.seasonPoints.toLocaleString()})</span>
            </p>
            <p class="text-gray-300 text-xs">Season</p>
          </div>
        </div>
      </div>

      <div class="flex flex-col bg-panel m-4 rounded-md">
        
        <div class="flex justify-between items-center text-white px-4 pt-4 rounded-md w-full">
          <div class="flex">
            <button class={`btn ${activeTab == "details" ? `fpl-button` : `inactive-btn`} px-4 py-2 rounded-l-md font-bold text-md min-w-[125px]`}
              on:click={() => setActiveTab("details")}>
              Details
            </button>
            <button class={`btn ${activeTab == "gameweeks" ? `fpl-button` : `inactive-btn`} px-4 py-2 rounded-r-md font-bold text-md min-w-[125px]`}
              on:click={() => setActiveTab("gameweeks")}>
              Gameweeks
            </button>
          </div>
          
          <div class="px-4">
            {#if activeTab == 'details'}<span class="text-2xl">Total Points: {0}</span>{/if}
          </div>
        </div>
        
        <div class="w-full">
          {#if activeTab === "details"}
            <ManagerGameweekDetails {selectedGameweek} {fantasyTeam} />
          {/if}
          {#if activeTab === "gameweeks"}
            <ManagerGameweeks {viewGameweekDetail} />
          {/if}
        </div>
      </div>
      
      
    </div>
  {/if}
</Layout>
