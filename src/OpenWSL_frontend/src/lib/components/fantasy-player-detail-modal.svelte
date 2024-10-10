<script lang="ts">
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import { Modal } from "@dfinity/gix-components";
  import type { ClubDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import { convertPlayerPosition, getFlagComponent } from "../utils/helpers";

  export let visible: boolean;
  export let closeDetailModal: () => void;
  export let gameweekData: GameweekData;
  export let playerTeam: ClubDTO;
  export let opponentTeam: ClubDTO;
  export let seasonName: string;
</script>

<Modal {visible} on:nnsClose={closeDetailModal}>
  <div class="mx-4 p-4">
    <div class="flex justify-between items-center my-2">
      <h3 class="default-header">Player Detail</h3>
      <button class="times-button" on:click={closeDetailModal}>&times;</button>
    </div>

    <div class="flex justify-start items-center w-full">
      <svelte:component
        this={getFlagComponent(gameweekData.nationalityId)}
        class="h-20 w-20"
      />
      <div class="w-full flex-col space-y-4 mb-2">
        <h3 class="default-header mb-2">
          {(gameweekData.player.firstName != ""
            ? gameweekData.player.firstName.charAt(0) + "."
            : "") + gameweekData.player.lastName}
        </h3>
        <p class="text-gray-400 flex items-center">
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
      class="flex justify-start items-center w-full border-t border-gray-600"
    >
      <p
        class="flex w-1/3 items-center border-r border-gray-600 pt-2 ml-2 xs:ml-0 xs:justify-center"
      >
        vs <BadgeIcon
          className="w-5 h-5 mx-1"
          primaryColour={opponentTeam?.primaryColourHex}
          secondaryColour={opponentTeam?.secondaryColourHex}
          thirdColour={opponentTeam?.thirdColourHex}
        />
        {opponentTeam?.abbreviatedName}
      </p>
      <p class="flex w-1/3 justify-center items-center pt-2">{seasonName}</p>
      <p
        class="flex w-1/3 items-center justify-end border-l border-gray-600 pt-2 mr-2 xs:mr-0 xs:justify-center"
      >
        Gameweek {gameweekData.gameweek}
      </p>
    </div>

    <div class="mt-2">
      <div
        class="flex justify-between items-center mt-4 bg-light-gray p-2 border-t border-b border-gray-600"
      >
        <div class="w-3/6">Category</div>
        <div class="w-2/6">Detail</div>
        <div class="w-1/6">Points</div>
      </div>
    </div>

    <div class="flex justify-between items-center p-2">
      <div class="w-3/6">Appearance</div>
      <div class="w-2/6">
        {gameweekData.appearance > 0 ? gameweekData.appearance : "-"}
      </div>
      <div class="w-1/6">
        {gameweekData.appearance > 0 ? gameweekData.appearance * 5 : "-"}
      </div>
    </div>

    <div class="flex justify-between items-center p-2">
      <div class="w-3/6">Goals</div>
      <div class="w-2/6">{gameweekData.goals}</div>
      <div class="w-1/6">{gameweekData.goalPoints}</div>
    </div>

    <div class="flex justify-between items-center p-2">
      <div class="w-3/6">Assists</div>
      <div class="w-2/6">{gameweekData.assists}</div>
      <div class="w-1/6">{gameweekData.assistPoints}</div>
    </div>

    <div class="flex justify-between items-center p-2">
      <div class="w-3/6">Yellow Card</div>
      <div class="w-2/6">{gameweekData.yellowCards}</div>
      <div class="w-1/6">
        {gameweekData.yellowCards * -5}
      </div>
    </div>

    <div class="flex justify-between items-center p-2">
      <div class="w-3/6">Red Card</div>
      <div class="w-2/6">{gameweekData.redCards}</div>
      <div class="w-1/6">
        {gameweekData.redCards > 0 ? -20 : 0}
      </div>
    </div>

    {#if convertPlayerPosition(gameweekData.player.position) < 2}
      <div class="flex justify-between items-center p-2">
        <div class="w-3/6">Clean Sheet</div>
        <div class="w-2/6">
          {gameweekData.cleanSheets}
        </div>
        <div class="w-1/6">
          {gameweekData.cleanSheetPoints}
        </div>
      </div>

      <div class="flex justify-between items-center p-2">
        <div class="w-3/6">Conceded</div>
        <div class="w-2/6">
          {gameweekData.goalsConceded}
        </div>
        <div class="w-1/6">
          {gameweekData.goalsConcededPoints}
        </div>
      </div>
    {/if}

    {#if convertPlayerPosition(gameweekData.player.position) === 0}
      <div class="flex justify-between items-center p-2">
        <div class="w-3/6">Saves</div>
        <div class="w-2/6">{gameweekData.saves}</div>
        <div class="w-1/6">
          {Math.floor(gameweekData.saves / 3) * 5}
        </div>
      </div>

      <div class="flex justify-between items-center p-2">
        <div class="w-3/6">Penalty Saves</div>
        <div class="w-2/6">
          {gameweekData.penaltySaves}
        </div>
        <div class="w-1/6">
          {gameweekData.penaltySaves * 20}
        </div>
      </div>
    {/if}

    <div class="flex justify-between items-center p-2">
      <div class="w-3/6">Own Goal</div>
      <div class="w-2/6">{gameweekData.ownGoals}</div>
      <div class="w-1/6">
        {gameweekData.ownGoals * -10}
      </div>
    </div>

    <div class="flex justify-between items-center p-2">
      <div class="w-3/6">Penalty Misses</div>
      <div class="w-2/6">
        {gameweekData.missedPenalties}
      </div>
      <div class="w-1/6">
        {gameweekData.missedPenalties * -15}
      </div>
    </div>
    {#if gameweekData.highestScoringPlayerId > 0}
      <div class="flex justify-between items-center p-2">
        <div class="w-3/6">Highest Scoring Player:</div>
        <div class="w-2/6">
          {gameweekData.highestScoringPlayerId}
        </div>
        <div class="w-1/6">
          {gameweekData.highestScoringPlayerId * 25}
        </div>
      </div>
    {/if}

    <div class="mt-2">
      <div
        class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600"
      >
        <span class="w-5/6">Player Points:</span>
        <span class="w-1/6">{gameweekData.points}</span>
      </div>
    </div>

    <div class="mt-2">
      <div
        class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600"
      >
        <span class="w-5/6">Bonus Points:</span>
        <span class="w-1/6">{gameweekData.bonusPoints}</span>
      </div>
    </div>

    {#if gameweekData.isCaptain}
      <div class="mt-2">
        <div
          class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600"
        >
          <span class="w-5/6">Captain Points:</span>
          <span class="w-1/6">{gameweekData.points}</span>
        </div>
      </div>
    {/if}

    <div class="mt-2">
      <div
        class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600"
      >
        <span class="w-5/6">Total Points:</span>
        <span class="w-1/6">{gameweekData.totalPoints}</span>
      </div>
    </div>
  </div>
</Modal>
