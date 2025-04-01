<script lang="ts">
  import { onMount, tick } from "svelte";
  import { browser } from "$app/environment";
  import { type Writable } from "svelte/store";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { clubStore } from "$lib/stores/club-store";
  import { toasts } from "$lib/stores/toasts-store";
  import { getActualIndex } from "$lib/utils/helpers";
  import { calculateBonusPoints, getBonusUsed, getGridSetup, getTeamFormationReadOnly, isBonusUsed, sortPlayersByPointsThenValue } from "$lib/utils/pick-team.helpers";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import ManagerPitchPlayer from "./manager-pitch-player.svelte";
  import { playerStore } from "$lib/stores/player-store";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import type { FantasyTeamSnapshot, GameweekNumber } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import type { Club } from "../../../../../declarations/data_canister/data_canister.did";

  export let fantasyTeam: Writable<FantasyTeamSnapshot | null>;
  export let gridSetup: number[][];
  export let gameweekPlayers: Writable<GameweekData[]>;
  export let selectedGameweek: Writable<GameweekNumber>;
  
  let pitchHeight = 0;
  let pitchElement: HTMLImageElement | null = null;
  let isLoading = true;
  let favouriteTeam: Club | null = null;

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
  <LocalSpinner />
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
      <LocalSpinner />
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
                    <ManagerPitchPlayer {playerData} {clubData} isCaptain={$fantasyTeam?.captainId == playerId} />
                  {/if}
                </div>
              {/each}
            </div>
          {/each}
        </div>
      {/if}
    {/if}
  </div>
  <div class="relative hidden lg:flex w-1/2 text-lg">
    
    <div class="flex flex-col w-full p-4 border border-gray-700 py-4 bg-light-gray space-y-4">
      <p class="text-3xl">{$fantasyTeam?.username}</p>
      <p class="text-3xl">{$fantasyTeam?.points} Points</p>
      {#if favouriteTeam}
        <p class="text-xs">Favourite Club</p>
        <p class="content-panel-stat flex items-center">
          <span class="flex flex-row items-center">
            <BadgeIcon className="w-7 mr-2" club={favouriteTeam} />
            {favouriteTeam.friendlyName}
          </span>
        </p>
      {/if}
      <p>Team Value: £{(($fantasyTeam?.teamValueQuarterMillions!) / 4).toFixed(2)}</p>
      <p>Transfers Available: {$fantasyTeam?.transfersAvailable}</p>
      <p>Bonus Played: {getBonusUsed($fantasyTeam!, $fantasyTeam?.gameweek ?? 0)}</p>
      
    </div>
    
  </div>  
</div>
{/if}
