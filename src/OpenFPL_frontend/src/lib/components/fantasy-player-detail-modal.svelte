<script lang="ts">
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { getFlagComponent } from "../utils/Helpers";

  export let showModal: boolean;
  export let closeDetailModal: () => void;
  export let gameweekData: GameweekData;
  export let playerTeam: Team;
  export let opponentTeam: Team;
  export let seasonName: string;
</script>

{#if showModal}
  <div
    class="fixed inset-0 bg-gray-900 bg-opacity-80 overflow-y-auto h-full w-full modal-backdrop"
    on:click={closeDetailModal}
    on:keydown={closeDetailModal}
  >
    <div
      class="relative top-20 mx-auto p-5 border border-gray-700 w-96 shadow-lg rounded-md bg-panel text-white"
      on:click|stopPropagation
      on:keydown|stopPropagation
    >
      <div class="flex justify-between items-center">
        <h3 class="text-xl font-semibold text-white">Player Detail</h3>
        <button class="text-white text-3xl" on:click={closeDetailModal}
          >&times;</button
        >
      </div>

      <div class="flex justify-start items-center w-full">
        <svelte:component
          this={getFlagComponent(gameweekData.player.nationality)}
          class="h-20 w-20"
        />
        <div class="ml-4">
          <h3 class="text-2xl mb-2">
            {(gameweekData.player.firstName != ""
              ? gameweekData.player.firstName.charAt(0) + "."
              : "") + gameweekData.player.lastName}
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
          Gameweek {gameweekData.gameweek}
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

      <div class="flex justify-between items-center p-2">
        <div class="text-sm font-medium w-3/6">Appearance</div>
        <div class="text-sm font-medium w-2/6">
          {gameweekData.appearance > 0 ? gameweekData.appearance : "-"}
        </div>
        <div class="text-sm font-medium w-1/6">
          {gameweekData.appearance > 0 ? gameweekData.appearance * 5 : "-"}
        </div>
      </div>

      <div class="flex justify-between items-center p-2">
        <div class="text-sm font-medium w-3/6">Goals</div>
        <div class="text-sm font-medium w-2/6">{gameweekData.goals}</div>
        <div class="text-sm font-medium w-1/6">{gameweekData.goalPoints}</div>
      </div>

      <div class="flex justify-between items-center p-2">
        <div class="text-sm font-medium w-3/6">Assists</div>
        <div class="text-sm font-medium w-2/6">{gameweekData.assists}</div>
        <div class="text-sm font-medium w-1/6">{gameweekData.assistPoints}</div>
      </div>

      <div class="flex justify-between items-center p-2">
        <div class="text-sm font-medium w-3/6">Yellow Card</div>
        <div class="text-sm font-medium w-2/6">{gameweekData.yellowCards}</div>
        <div class="text-sm font-medium w-1/6">
          {gameweekData.yellowCards * -5}
        </div>
      </div>

      <div class="flex justify-between items-center p-2">
        <div class="text-sm font-medium w-3/6">Red Card</div>
        <div class="text-sm font-medium w-2/6">{gameweekData.redCards}</div>
        <div class="text-sm font-medium w-1/6">
          {gameweekData.redCards > 0 ? -20 : 0}
        </div>
      </div>

      {#if gameweekData.player.position < 2}
        <div class="flex justify-between items-center p-2">
          <div class="text-sm font-medium w-3/6">Clean Sheet</div>
          <div class="text-sm font-medium w-2/6">
            {gameweekData.cleanSheets}
          </div>
          <div class="text-sm font-medium w-1/6">
            {gameweekData.cleanSheetPoints}
          </div>
        </div>

        <div class="flex justify-between items-center p-2">
          <div class="text-sm font-medium w-3/6">Conceded</div>
          <div class="text-sm font-medium w-2/6">
            {gameweekData.goalsConceded}
          </div>
          <div class="text-sm font-medium w-1/6">
            {gameweekData.goalsConcededPoints}
          </div>
        </div>
      {/if}

      {#if gameweekData.player.position === 0}
        <div class="flex justify-between items-center p-2">
          <div class="text-sm font-medium w-3/6">Saves</div>
          <div class="text-sm font-medium w-2/6">{gameweekData.saves}</div>
          <div class="text-sm font-medium w-1/6">
            {Math.floor(gameweekData.saves / 3) * 5}
          </div>
        </div>

        <div class="flex justify-between items-center p-2">
          <div class="text-sm font-medium w-3/6">Penalty Saves</div>
          <div class="text-sm font-medium w-2/6">
            {gameweekData.penaltySaves}
          </div>
          <div class="text-sm font-medium w-1/6">
            {gameweekData.penaltySaves * 20}
          </div>
        </div>
      {/if}

      <div class="flex justify-between items-center p-2">
        <div class="text-sm font-medium w-3/6">Own Goal</div>
        <div class="text-sm font-medium w-2/6">{gameweekData.ownGoals}</div>
        <div class="text-sm font-medium w-1/6">
          {gameweekData.ownGoals * -10}
        </div>
      </div>

      <div class="flex justify-between items-center p-2">
        <div class="text-sm font-medium w-3/6">Penalty Misses</div>
        <div class="text-sm font-medium w-2/6">
          {gameweekData.missedPenalties}
        </div>
        <div class="text-sm font-medium w-1/6">
          {gameweekData.missedPenalties * -15}
        </div>
      </div>

      <div class="mt-2">
        <div
          class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600"
        >
          <span class="text-sm font-bold w-5/6">Player Points:</span>
          <span class="text-sm font-bold w-1/6">{gameweekData.points}</span>
        </div>
      </div>

      <div class="mt-2">
        <div
          class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600"
        >
          <span class="text-sm font-bold w-5/6">Bonus Points:</span>
          <span class="text-sm font-bold w-1/6">{gameweekData.bonusPoints}</span
          >
        </div>
      </div>

      <div class="mt-2">
        <div
          class="flex justify-between items-center bg-light-gray p-2 border-t border-b border-gray-600"
        >
          <span class="text-sm font-bold w-5/6">Total Points:</span>
          <span class="text-sm font-bold w-1/6">{gameweekData.totalPoints}</span
          >
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
  </div>
{/if}
