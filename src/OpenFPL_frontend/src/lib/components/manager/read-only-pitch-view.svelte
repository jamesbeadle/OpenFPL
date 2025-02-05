<script lang="ts">
  import { onMount, tick } from "svelte";
  import { browser } from "$app/environment";
  import { type Writable } from "svelte/store";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { clubStore } from "$lib/stores/club-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { getActualIndex } from "$lib/utils/helpers";
  import { calculateBonusPoints, getGridSetup, getTeamFormationReadOnly, sortPlayersByPointsThenValue } from "$lib/utils/pick-team.helpers";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import type { ClubDTO, GameweekNumber } from "../../../../../declarations/data_canister/data_canister.did";
  import ManagerPitchPlayer from "./manager-pitch-player.svelte";
  import { playerStore } from "$lib/stores/player-store";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { ManagerGameweekDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  export let fantasyTeam: Writable<ManagerGameweekDTO | null>;
  export let gridSetup: number[][];
  export let gameweekPlayers: Writable<GameweekData[]>;
  export let selectedGameweek: Writable<GameweekNumber>;
  
  let pitchHeight = 0;
  let pitchElement: HTMLImageElement | null = null;
  let isLoading = true;
  let favouriteTeam: ClubDTO | null = null;

  $: rowHeight = (pitchHeight * 0.9) / 4;
  $: gridSetup = getGridSetup( getTeamFormationReadOnly($fantasyTeam!, $playerStore));

  $: if ($fantasyTeam || $selectedGameweek > 0) {
    updateGameweekPlayers();
  }

  onMount(async () => {
    if (!browser) return;
    await tick();
    measurePitch();
    window.addEventListener("resize", measurePitch);
  });

function onPitchLoad() {
  measurePitch();
}

function measurePitch() {
  if (!pitchElement) return;
  pitchHeight = pitchElement.clientHeight;
}

async function updateGameweekPlayers() {
  try {
    if (!$fantasyTeam) { gameweekPlayers.set([]); return; }

    let favouriteClubId = $fantasyTeam.favouriteClubId[0];

    if(favouriteClubId){
      let foundFavouriteClub = $clubStore.find(x => x.id == favouriteClubId);
      if(foundFavouriteClub){
        favouriteTeam = foundFavouriteClub;
      }
    }

    let fetchedPlayers = await playerEventsStore.getGameweekPlayers(
      $fantasyTeam!,
      $leagueStore!.activeSeasonId,
      $selectedGameweek!
    );
    calculateBonusPoints(fetchedPlayers, $fantasyTeam);
    sortPlayersByPointsThenValue(fetchedPlayers);
    gameweekPlayers.set(fetchedPlayers);
  } catch (error) {
    toasts.addToast({ type: "error", message: "Error updating gameweek players." });
    console.error("Error updating gameweek players:", error);
  } finally {
    isLoading = false;
  }
}
</script>
{#if isLoading}
  <WidgetSpinner />
{:else}
<div class="relative w-full flex flex-row">
  <div class="relative w-full lg:w-1/2 mt-2">
    <img 
      src="/pitch.png" 
      alt="pitch" 
      class="w-full h-auto" 
      bind:this={pitchElement}
      on:load={onPitchLoad} 
    />
    {#if isLoading}
      <WidgetSpinner />
    {:else}
      {#if gridSetup && rowHeight}
        <div class="absolute top-0 left-0 right-0 bottom-0">
          {#each gridSetup as row, rowIndex}
            <div class="flex justify-around items-center w-full" style="height: {rowHeight}px;">
              {#each row as _, colIndex (colIndex)}
                {@const actualIndex = getActualIndex(rowIndex, colIndex, gridSetup)}
                {@const playerIds = $fantasyTeam?.playerIds ?? []}
                {@const playerId = playerIds[actualIndex]}
                {@const playerData = $gameweekPlayers.find((data) => data.player.id === playerId) ?? null}
                {@const clubData = $clubStore.find((club) => club.id === playerData?.player.clubId) ?? null}
  
                <div class="flex flex-col justify-center items-center flex-1 player-card">
                  {#if playerData && clubData}
                    <ManagerPitchPlayer {playerData} {clubData} />
                  {/if}
                </div>
              {/each}
            </div>
          {/each}
        </div>
      {/if}
    {/if}
  </div>
  <div class="relative hidden lg:flex w-1/2">
    
    <div
      class="flex flex-col w-full justify-between p-2 md:px-4 border border-gray-700 py-4 bg-light-gray"
    >
      <p>Username: {$fantasyTeam?.username}</p>
      {#if favouriteTeam}
      <p class="content-panel-stat flex items-center">
        Favourite Club: 
        <span class="flex flex-row items-center">
          <BadgeIcon className="w-7 mr-2" club={favouriteTeam} />
          {favouriteTeam.friendlyName}
        </span>
      </p>
      {/if}
      <p>Team Value: {($fantasyTeam?.teamValueQuarterMillions!) / 1200}</p>
      <p>Transfers Available: {$fantasyTeam?.transfersAvailable}</p>
    </div>
    
  </div>  
</div>
{/if}
