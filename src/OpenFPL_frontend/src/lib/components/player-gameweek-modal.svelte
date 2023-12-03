<script lang="ts">
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { Modal } from "@dfinity/gix-components";
  import type {
    PlayerEventData,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type {
    PlayerDetailDTO,
    PlayerGameweekDTO,
  } from "../../../../declarations/player_canister/player_canister.did";
  import { getFlagComponent } from "../utils/Helpers";

  export let visible: boolean;
  export let closeDetailModal: () => void;
  export let playerDetail: PlayerDetailDTO;
  export let gameweekDetail: PlayerGameweekDTO | null;
  export let playerTeam: Team | null;
  export let opponentTeam: Team | null;
  export let gameweek = 0;
  export let seasonName = "";

  let appearanceEvents: PlayerEventData[] = [];
  let concededEvents: PlayerEventData[] = [];
  let keeperSaveEvents: PlayerEventData[] = [];
  let otherEvents: PlayerEventData[] = [];
  let goalConcededCount = 0;
  let keeperSaveCount = 0;

  let pointsForAppearance = 5;
  let pointsFor3Saves = 5;
  let pointsForPenaltySave = 20;
  let pointsForHighestScore = 25;
  let pointsForRedCard = -20;
  let pointsForPenaltyMiss = -10;
  let pointsForEach2Conceded = -15;
  let pointsForOwnGoal = -10;
  let pointsForYellowCard = -5;
  let pointsForCleanSheet = 10;

  var pointsForGoal = 0;
  var pointsForAssist = 0;

  $: if (gameweekDetail) {
    appearanceEvents = [];
    concededEvents = [];
    keeperSaveEvents = [];
    otherEvents = [];
    goalConcededCount = 0;
    keeperSaveCount = 0;

    gameweekDetail.events.forEach((evt) => {
      switch (evt.eventType) {
        case 0:
          appearanceEvents.push(evt);
          break;
        case 3:
          concededEvents.push(evt);
          goalConcededCount++;
          break;
        case 4:
          keeperSaveEvents.push(evt);
          keeperSaveCount++;
          break;
        default:
          otherEvents.push(evt);
          break;
      }
    });

    concededEvents.sort((a, b) => a.eventEndMinute - b.eventEndMinute);
    keeperSaveEvents.sort((a, b) => a.eventEndMinute - b.eventEndMinute);
    otherEvents.sort(
      (a, b) => a.eventType - b.eventType || a.eventEndMinute - b.eventEndMinute
    );
  }
</script>

<Modal {visible} on:nnsClose={closeDetailModal}>
  <div class="bg-gray-900 p-4">
    <div class="flex justify-between items-center">
      <h3 class="text-xl font-semibold text-white">Player Detail</h3>
      <button class="text-white text-3xl" on:click={closeDetailModal}
        >&times;</button
      >
    </div>

    <div class="flex justify-start items-center w-full">
      <svelte:component
        this={getFlagComponent(playerDetail.nationality)}
        class="h-20 w-20"
      />
      <div class="ml-4">
        <h3 class="text-2xl mb-2">
          {playerDetail.firstName}
          {playerDetail.lastName}
        </h3>
        <p class="text-sm text-gray-400 flex items-center">
          <BadgeIcon
            className="w-5 h-5 mr-2"
            primaryColour={playerTeam?.primaryColourHex}
            secondaryColour={playerTeam?.secondaryColourHex}
            thirdColour={playerTeam?.thirdColourHex}
          />
          {playerTeam?.friendlyName}
        </p>
      </div>
    </div>

    <div
      class="flex justify-start items-center w-full border-t border-gray-600 text-sm"
    >
      <p
        class="flex w-1/3 items-center border-r border-gray-600 justify-center pt-2"
      >
        vs <BadgeIcon
          className="w-5 h-5 mx-1"
          primaryColour={opponentTeam?.primaryColourHex}
          secondaryColour={opponentTeam?.secondaryColourHex}
          thirdColour={opponentTeam?.thirdColourHex}
        />
        {opponentTeam?.friendlyName}
      </p>
      <p class="flex w-1/3 justify-center items-center pt-2">{seasonName}</p>
      <p
        class="flex w-1/3 items-center justify-center border-l border-gray-600 pt-2"
      >
        Gameweek {gameweek}
      </p>
    </div>

    <div class="mt-2">
      <div
        class="flex justify-between items-center mt-4 bg-light-gray p-2 border-t border-b border-gray-600"
      >
        <div class="text-sm font-medium w-3/6">Category</div>
        <div class="text-sm font-medium w-2/6">Detail</div>
        <div class="text-sm font-medium w-1/6">Points</div>
      </div>
    </div>

    {#each appearanceEvents as event}
      <div class="mt-2">
        <div class="flex justify-between items-center p-2">
          <div class="text-sm font-medium w-3/6">Appearance</div>
          <div class="text-sm font-medium w-2/6">
            {event.eventStartMinute}-{event.eventEndMinute}'
          </div>
          <div class="text-sm font-medium w-1/6">{pointsForAppearance}</div>
        </div>
      </div>
    {/each}

    {#if goalConcededCount >= 2}
      <div class="mt-2">
        <div class="flex justify-between items-center p-2">
          <div class="text-sm font-medium w-3/6">
            Goal x {goalConcededCount}
          </div>
          <div class="text-sm font-medium w-2/6">-</div>
          <div class="text-sm font-medium w-1/6">
            {-(-pointsForEach2Conceded * Math.floor(goalConcededCount / 2))}
          </div>
        </div>
      </div>
    {/if}

    {#if Math.floor(keeperSaveCount / 3) > 0}
      <div class="mt-2">
        <div class="flex justify-between items-center p-2">
          <div class="text-sm font-medium w-3/6">Keeper Save x 3</div>
          <div class="text-sm font-medium w-2/6">-</div>
          <div class="text-sm font-medium w-1/6">
            {pointsFor3Saves * Math.floor(keeperSaveCount / 3)}
          </div>
        </div>
      </div>
    {/if}

    {#each otherEvents as event}
      <div class="mt-2">
        <div class="flex justify-between items-center p-2">
          <div class="text-sm font-medium w-3/6">
            {#if event.eventType === 1}<div class="text-sm font-medium w-3/6">
                Goal Scored
              </div>{/if}
            {#if event.eventType === 2}<div class="text-sm font-medium w-3/6">
                Assist
              </div>{/if}
            {#if event.eventType === 5}<div class="text-sm font-medium w-3/6">
                Clean Sheet
              </div>{/if}
            {#if event.eventType === 6}<div class="text-sm font-medium w-3/6">
                Penalty Save
              </div>{/if}
            {#if event.eventType === 7}<div class="text-sm font-medium w-3/6">
                Penalty Missed
              </div>{/if}
            {#if event.eventType === 8}<div class="text-sm font-medium w-3/6">
                Yellow Card
              </div>{/if}
            {#if event.eventType === 9}<div class="text-sm font-medium w-3/6">
                Red Card
              </div>{/if}
            {#if event.eventType === 10}<div class="text-sm font-medium w-3/6">
                Own Goal
              </div>{/if}
            {#if event.eventType === 11}<div class="text-sm font-medium w-3/6">
                Highest Scoring Player
              </div>{/if}
          </div>
          <div class="text-sm font-medium w-2/6">
            {#if event.eventType === 1}<div class="text-sm font-medium w-3/6">
                {event.eventEndMinute}
              </div>{/if}
            {#if event.eventType === 2}<div class="text-sm font-medium w-3/6">
                {event.eventEndMinute}
              </div>{/if}
            {#if event.eventType === 5}<div class="text-sm font-medium w-3/6">
                -
              </div>{/if}
            {#if event.eventType === 6}<div class="text-sm font-medium w-3/6">
                -
              </div>{/if}
            {#if event.eventType === 7}<div class="text-sm font-medium w-3/6">
                -
              </div>{/if}
            {#if event.eventType === 8}<div class="text-sm font-medium w-3/6">
                -
              </div>{/if}
            {#if event.eventType === 9}<div class="text-sm font-medium w-3/6">
                -
              </div>{/if}
            {#if event.eventType === 10}<div class="text-sm font-medium w-3/6">
                {event.eventEndMinute}
              </div>{/if}
            {#if event.eventType === 11}<div class="text-sm font-medium w-3/6">
                -
              </div>{/if}
          </div>
          <div class="text-sm font-medium w-1/6">
            {#if event.eventType === 1}<div class="text-sm font-medium w-3/6">
                {pointsForGoal}
              </div>{/if}
            {#if event.eventType === 2}<div class="text-sm font-medium w-3/6">
                {pointsForAssist}
              </div>{/if}
            {#if event.eventType === 5}<div class="text-sm font-medium w-3/6">
                {pointsForCleanSheet}
              </div>{/if}
            {#if event.eventType === 6}<div class="text-sm font-medium w-3/6">
                {pointsForPenaltySave}
              </div>{/if}
            {#if event.eventType === 7}<div class="text-sm font-medium w-3/6">
                {pointsForPenaltyMiss}
              </div>{/if}
            {#if event.eventType === 8}<div class="text-sm font-medium w-3/6">
                {pointsForYellowCard}
              </div>{/if}
            {#if event.eventType === 9}<div class="text-sm font-medium w-3/6">
                {pointsForRedCard}
              </div>{/if}
            {#if event.eventType === 10}<div class="text-sm font-medium w-3/6">
                {pointsForOwnGoal}
              </div>{/if}
            {#if event.eventType === 11}<div class="text-sm font-medium w-3/6">
                {pointsForHighestScore}
              </div>{/if}
          </div>
        </div>
      </div>
    {/each}

    <div class="mt-2">
      <div
        class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600"
      >
        <span class="text-sm font-bold w-5/6">Total Points:</span>
        <span class="text-sm font-bold w-1/6">{gameweekDetail?.points}</span>
      </div>
    </div>

    <div class="mt-2 flex justify-end">
      <button
        on:click={closeDetailModal}
        on:keydown={closeDetailModal}
        class="fpl-purple-btn px-4 py-2 mt-2 rounded-md">Close</button
      >
    </div>
  </div>
</Modal>
