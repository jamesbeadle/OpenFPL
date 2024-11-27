<script lang="ts">
  import { onMount } from "svelte";
  import { writable, type Writable } from "svelte/store";
  import { page } from "$app/stores";

  import { storeManager } from "$lib/managers/store-manager";
  import { clubStore } from "$lib/stores/club-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { playerStore } from "$lib/stores/player-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";

  import { toastsError } from "$lib/stores/toasts-store";
  import type {
    FantasyTeamSnapshot,
    ClubDTO,
    ManagerDTO,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  
  import { getDateFromBigInt, uint8ArrayToBase64 } from "$lib/utils/helpers";
  import { calculateBonusPoints, getTeamFormationReadOnly } from "$lib/utils/pick-team.helpers";
  
  import Layout from "../Layout.svelte";
  import LocalSpinner from "$lib/components/local-spinner.svelte";
  import ManagerGameweeks from "$lib/components/manager/manager-gameweeks.svelte";
  import ReadOnlyPitchView from "$lib/components/manager/read-only-pitch-view.svelte";

  $: id = $page.url.searchParams.get("id");
  $: formation = "4-4-2";
  $: gridSetup = getGridSetup(formation);

  $: if ($fantasyTeam && $selectedGameweek && $selectedGameweek > 0) {
    updateGameweekPlayers();
  }

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

  let gameweekPlayers = writable<GameweekData[]>([]);

  onMount(async () => {
    try {
      await storeManager.syncStores();
      manager = await managerStore.getPublicProfile(id ?? "");
      
      formation = getTeamFormationReadOnly($fantasyTeam, $playerStore);
      gridSetup = getGridSetup(formation);
      if(!manager){
        return;
      }
      displayName = manager.username === manager.principalId ? "Unknown" : manager.username;
      profilePicture = getProfilePictureString(manager);
      joinedDate = getDateFromBigInt(Number(manager.createDate));

      favouriteTeam = manager.favouriteClubId == null
          ? $clubStore.find((x) => x.id == manager.favouriteClubId[0]) ?? null
          : null;
      viewGameweekDetail($selectedGameweek!);
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

  function getProfilePictureString(manager: ManagerDTO) : string {
    try {
      let byteArray;
      if (manager && manager.profilePicture) {
        if (
          Array.isArray(manager.profilePicture) &&
          manager.profilePicture[0] instanceof Uint8Array
        ) {
          byteArray = manager.profilePicture[0];
          return `data:image/${
            manager.profilePictureType
          };base64,${uint8ArrayToBase64(byteArray)}`;
        } else if (manager.profilePicture instanceof Uint8Array) {
          return `data:${manager.profilePictureType};base64,${uint8ArrayToBase64(
            manager.profilePicture,
          )}`;
        } else {
          if (typeof manager.profilePicture === "string") {            
            return `data:${manager.profilePictureType};base64,${manager.profilePicture}`;
          }
        }
      }
      return "/profile_placeholder.png";
    } catch (error) {
      console.error(error);
      return "/profile_placeholder.png";
    }
  }

  function getGridSetup(formation: string): number[][] {
    const formationSplits = formation.split("-").map(Number);
    const setups = [
      [1],
      ...formationSplits.map((s) =>
        Array(s)
          .fill(0)
          .map((_, i) => i + 1)
      ),
    ];
    return setups;
  }

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

  async function updateGameweekPlayers() {
    try {

      if (!$fantasyTeam) {
        gameweekPlayers.set([]);
        return;
      }
  
      let fetchedPlayers = await playerEventsStore.getGameweekPlayers(
        $fantasyTeam!,
        1, //TODO Set from dropdown
        $selectedGameweek!
      );

      calculateBonusPoints(fetchedPlayers, $fantasyTeam);
      
      gameweekPlayers.set(
        fetchedPlayers.sort((a, b) => {
          if (b.totalPoints === a.totalPoints) {
            return (
              b.player.valueQuarterMillions - a.player.valueQuarterMillions
            );
          }
          return b.totalPoints - a.totalPoints;
        })
      );
    } catch (error) {
      toastsError({
        msg: { text: "Error updating gameweek players." },
        err: error,
      });
      console.error("Error updating gameweek players:", error);
    } finally {
      isLoading = false;
    }
  }
</script>

<Layout>
  {#if isLoading}
    <LocalSpinner />
  {:else}

    <div class="flex flex-col lg:flex-row">
      <div class="w-full lg:w-1/2 order-1 lg:order-2">

        <div class="page-header-wrapper fle w-full">
          <div class="content-panel w-full">
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
          <div class="content-panel w-full flex-row">
            <div class="w-full">
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

            <div class="w-full">
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
            <div class="w-full">
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

          <div class="flex flex-col px-4 mb-2">
            {#if $fantasyTeam && activeTab === "details"}
              <div class="flex-row">
                <span>Total Points: {$fantasyTeam?.points}</span>
              </div>
              <div class="flex-row">
                <span>Total Team Value: £{($fantasyTeam?.teamValueQuarterMillions  / 4).toFixed(2)}m</span>
              </div>
            {/if}
          </div>
        </div>

      </div>
      <div class="w-full lg:w-1/2 order-2 lg:order-1">

        <div class="flex w-full">
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

        {#if activeTab === "details"}
        <ReadOnlyPitchView
          {fantasyTeam}
          {gridSetup}
          {gameweekPlayers}
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
