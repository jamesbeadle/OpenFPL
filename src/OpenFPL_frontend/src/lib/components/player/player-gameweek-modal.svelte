<script lang="ts">
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type {
    ClubDTO,
    PlayerDetailDTO,
    PlayerEventData,
    PlayerGameweekDTO,
  } from "../../../../../external_declarations/data_canister/data_canister.did";
  import { getFlagComponent } from "../../utils/helpers";
  import Modal from "$lib/components/shared/modal.svelte";

  export let visible: boolean;
  export let closeDetailModal: () => void;
  export let playerDetail: PlayerDetailDTO;
  export let gameweekDetail: PlayerGameweekDTO | null;
  export let playerTeam: ClubDTO | undefined;
  export let opponentTeam: ClubDTO | null;
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

  var pointsForGoal = 20;
  var pointsForAssist = 15;

  $: if (gameweekDetail) {
    appearanceEvents = [];
    concededEvents = [];
    keeperSaveEvents = [];
    otherEvents = [];
    goalConcededCount = 0;
    keeperSaveCount = 0;
    

    gameweekDetail.events.forEach((evt) => {

      var added = false;

      if(Object.keys(evt.eventType)[0] == "Appearance"){
        appearanceEvents.push(evt);
        added = true;
      }

      if(Object.keys(evt.eventType)[0] == "GoalConceded"){
          concededEvents.push(evt);
          goalConcededCount++;
          added = true;
      }

      if(Object.keys(evt.eventType)[0] == "KeeperSave"){
          keeperSaveEvents.push(evt);
          keeperSaveCount++;
          added = true;
      }
      
      if(!added){
        otherEvents.push(evt);
      }
      
    });

    let position = Object.keys(playerDetail.position)[0]; 
    if(position == "Forward"){
      pointsForGoal = 10;
      pointsForAssist = 10;
    }

    if(position == "Midfielder"){
      pointsForGoal = 15;
      pointsForAssist = 10;
    }

    concededEvents.sort((a, b) => a.eventEndMinute - b.eventEndMinute);
    keeperSaveEvents.sort((a, b) => a.eventEndMinute - b.eventEndMinute);
    otherEvents.sort(
      (a, b) =>
        a.eventEndMinute - b.eventEndMinute
    );
  }
</script>

<Modal showModal={visible} onClose={closeDetailModal} title="Player Detail">
  <div class="mx-4 p-4">
    <div class="flex justify-start items-center w-full">
      <svelte:component
        this={getFlagComponent(playerDetail.nationality)}
        class="h-20 w-20"
      />
      <div class="w-full flex-col space-y-4 mb-2">
        <h3 class="default-header mb-2">
          {playerDetail.firstName}
          {playerDetail.lastName}
        </h3>
        <p class="text-gray-400 flex items-center">
          <BadgeIcon className="w-5 h-5 mr-2" club={playerTeam!} />
          {playerTeam?.friendlyName}
        </p>
      </div>
    </div>

    <div
      class="flex justify-start items-center w-full border-t border-gray-600"
    >
      <p
        class="flex w-1/3 items-center border-r border-gray-600 justify-center pt-2"
      >
        vs <BadgeIcon className="w-5 h-5 mx-1" club={opponentTeam!}/>
        {opponentTeam?.friendlyName}
      </p>
      <p class="flex w-1/3 justify-center items-center pt-2">{seasonName}</p>
      <p class="flex w-1/3 items-center justify-center border-l border-gray-600 pt-2">
        Gameweek {gameweek}
      </p>
    </div>

    <div class="mt-2">
      <div
        class="modal-header-row"
      >
        <div class="w-3/6">Category</div>
        <div class="w-2/6">Detail</div>
        <div class="w-1/6">Points</div>
      </div>
    </div>

    {#each appearanceEvents as event}
      <div class="mt-2">
        <div class="modal-row">
          <div class="w-3/6">Appearance</div>
          <div class="w-2/6">
            {event.eventStartMinute}-{event.eventEndMinute}'
          </div>
          <div class="w-1/6">{pointsForAppearance}</div>
        </div>
      </div>
    {/each}

    {#if goalConcededCount >= 2}
      <div class="mt-2">
        <div class="modal-row">
          <div class="w-3/6">
            Goal x {goalConcededCount}
          </div>
          <div class="w-2/6">-</div>
          <div class="w-1/6">
            {-(-pointsForEach2Conceded * Math.floor(goalConcededCount / 2))}
          </div>
        </div>
      </div>
    {/if}

    {#if Math.floor(keeperSaveCount / 3) > 0}
      <div class="mt-2">
        <div class="modal-row">
          <div class="w-3/6">Keeper Save x 3</div>
          <div class="w-2/6">-</div>
          <div class="w-1/6">
            {pointsFor3Saves * Math.floor(keeperSaveCount / 3)}
          </div>
        </div>
      </div>
    {/if}

    {#each otherEvents as event}
      <div class="mt-2">
        <div class="modal-row">
          <div class="w-3/6">
            {#if Object.keys(event.eventType)[0] == "Goal"}<div class="w-3/6">
                Goal Scored
              </div>{/if}
            {#if  Object.keys(event.eventType)[0] == "GoalAssisted"}<div class="w-3/6">
                Assist
              </div>{/if}
            {#if  Object.keys(event.eventType)[0] == "CleanSheet"}<div class="w-3/6">
                Clean Sheet
              </div>{/if}
            {#if  Object.keys(event.eventType)[0] == "PenaltySaved"}<div class="w-3/6">
                Penalty Save
              </div>{/if}
            {#if  Object.keys(event.eventType)[0] == "PenaltyMissed"}<div class="w-3/6">
                Penalty Missed
              </div>{/if}
            {#if  Object.keys(event.eventType)[0] == "YellowCard"}<div class="w-3/6">
                Yellow Card
              </div>{/if}
            {#if  Object.keys(event.eventType)[0] == "RedCard"}<div class="w-3/6">
                Red Card
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "OwnGoal"}<div class="w-3/6">
                Own Goal
              </div>{/if}
            {#if  Object.keys(event.eventType)[0] == "HighestScoringPlayer"}<div class="w-3/6">
                Highest Scoring Player
              </div>{/if}
          </div>
          <div class="w-2/6">
            {#if  Object.keys(event.eventType)[0] == "Goal"}<div class="w-3/6">
                {event.eventEndMinute}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "GoalAssisted"}<div class="w-3/6">
                {event.eventEndMinute}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "CleanSheet"}<div class="w-3/6">
                -
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "PenaltySaved"}<div class="w-3/6">
                -
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "PenaltyMissed"}<div class="w-3/6">
                -
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "YellowCard"}<div class="w-3/6">
                -
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "RedCard"}<div class="w-3/6">
                -
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "OwnGoal"}<div class="w-3/6">
                {event.eventEndMinute}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "HighestScoringPlayer"}<div class="w-3/6">
                -
              </div>{/if}
          </div>
          <div class="w-1/6">
            {#if Object.keys(event.eventType)[0] == "Goal"}<div class="w-3/6">
                {pointsForGoal}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "GoalAssisted"}<div class="w-3/6">
                {pointsForAssist}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "CleanSheet"}<div class="w-3/6">
                {pointsForCleanSheet}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "PenaltySaved"}<div class="w-3/6">
                {pointsForPenaltySave}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "PenaltyMissed"}<div class="w-3/6">
                {pointsForPenaltyMiss}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "YellowCard"}<div class="w-3/6">
                {pointsForYellowCard}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "RedCard"}<div class="w-3/6">
                {pointsForRedCard}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "OwnGoal"}<div class="w-3/6">
                {pointsForOwnGoal}
              </div>{/if}
            {#if Object.keys(event.eventType)[0] == "HighestScoringPlayer"}<div class="w-3/6">
                {pointsForHighestScore}
              </div>{/if}
          </div>
        </div>
      </div>
    {/each}

    <div class="mt-2">
      <div class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600">
        <span class="w-5/6">Total Points:</span>
        <span class="w-1/6">{gameweekDetail?.points}</span>
      </div>
    </div>
  </div>
</Modal>
