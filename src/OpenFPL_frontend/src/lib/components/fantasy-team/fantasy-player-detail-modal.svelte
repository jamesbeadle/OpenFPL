<script lang="ts">
  import { convertPositionToIndex, getFlagComponent, getPlayerName } from "../../utils/helpers";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import Modal from "$lib/components/shared/modal.svelte";
  import FantasyPlayerDetailRow from "./fantasy-player-detail-row.svelte";
  import ModalTotalRow from "../shared/modal-total-row.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { Club } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  export let visible: boolean;
  export let gameweekData: GameweekData;
  export let playerTeam: Club;
  export let opponentTeam: Club;
  export let seasonName: string;
</script>

<Modal showModal={visible} onClose={() => {visible = false;}} title="Player Detail">
  <div class="flex flex-row items-center w-full mb-4 space-y-4">
    <div class="flex items-center justify-center w-full sm:w-1/3">
      <svelte:component this={getFlagComponent(gameweekData.nationalityId)} class="w-12 h-12 xs:w-16 xs:h-16" />
    </div>
    <div class="flex items-center justify-center w-full sm:w-1/3">
      <h3 class="mb-2 text-lg font-semibold text-center xs:mb-3 xs:text-xl">
        {getPlayerName(gameweekData.player)}
      </h3>
    </div>
    <div class="flex flex-col items-center justify-center w-full sm:w-1/3">
      <BadgeIcon className="w-8 h-8 xs:w-10 xs:h-10 mb-1" club={playerTeam!} />
      <p class="text-sm text-center text-gray-400">
        {playerTeam?.friendlyName}
      </p>
    </div>
  </div>

  <div class="flex items-center justify-start w-full border-t border-gray-600" >
    <p class="flex items-center justify-center w-1/3 pt-2 border-l border-gray-600 xs:mr-0">
      Gameweek {gameweekData.gameweek}
    </p>
    <p class="flex items-center justify-center w-1/3 pt-2 ml-2 border-gray-600 border-x xs:ml-0">
      vs <BadgeIcon className="w-5 h-5 mx-1" club={opponentTeam!} /> {opponentTeam?.abbreviatedName}
    </p>
    <p class="flex items-center justify-center w-1/3 pt-2 border-r border-gray-600">{seasonName}</p>
  </div>

  <div class="modal-header-row">
    <FantasyPlayerDetailRow col1="Category" col2="Detail" col3="Points" />
  </div>
  <div class="border-b modal-row border-BrandLightGray/80">
    <FantasyPlayerDetailRow col1="Appearance" col2={gameweekData.appearance > 0 ? gameweekData.appearance.toString() : "-"} col3={gameweekData.appearance > 0 ? (gameweekData.appearance * 5).toString() : "-"} />
  </div>
  <div class="border-b modal-row border-BrandLightGray/80">
    <FantasyPlayerDetailRow col1="Goals" col2={gameweekData.goals.toString()} col3={gameweekData.goalPoints.toString()} />
  </div>
  <div class="border-b modal-row border-BrandLightGray/80">
    <FantasyPlayerDetailRow col1="Assists" col2={gameweekData.assists.toString()} col3={gameweekData.assistPoints.toString()} />
  </div>
  <div class="border-b modal-row border-BrandLightGray/80">
    <FantasyPlayerDetailRow col1="Yellow Card" col2={gameweekData.yellowCards.toString()} col3={(gameweekData.yellowCards * -5).toString()} />
  </div>
  <div class="border-b modal-row border-BrandLightGray/80">
    <FantasyPlayerDetailRow col1="Red Card" col2={gameweekData.redCards.toString()} col3={(gameweekData.redCards > 0 ? -20 : 0).toString()} />
  </div>

  {#if convertPositionToIndex(gameweekData.player.position) < 2}
    <div class="border-b modal-row border-BrandLightGray/80">
      <FantasyPlayerDetailRow col1="Clean Sheet" col2={gameweekData.cleanSheets.toString()} col3={gameweekData.cleanSheetPoints.toString()} />
    </div>
    <div class="border-b modal-row border-BrandLightGray/80">
      <FantasyPlayerDetailRow col1="Conceded" col2={gameweekData.goalsConceded.toString()} col3={gameweekData.goalsConcededPoints.toString()} />
    </div>
  {/if}

  {#if convertPositionToIndex(gameweekData.player.position) === 0}
    <div class="border-b modal-row border-BrandLightGray/80">
      <FantasyPlayerDetailRow col1="Saves" col2={gameweekData.saves.toString()} col3={(Math.floor(gameweekData.saves / 3) * 5).toString()} />
    </div>
    <div class="border-b modal-row border-BrandLightGray/80">
      <FantasyPlayerDetailRow col1="Penalty Saves" col2={gameweekData.penaltySaves.toString()} col3={(gameweekData.penaltySaves * 20).toString()} />
    </div>
  {/if}

  <div class="border-b modal-row border-BrandLightGray/80">
    <FantasyPlayerDetailRow col1="Own Goal" col2={gameweekData.ownGoals.toString()} col3={(gameweekData.ownGoals * -10).toString()} />
  </div>
  <div class="modal-row">
    <FantasyPlayerDetailRow col1="Penalty Misses" col2={gameweekData.missedPenalties.toString()} col3={(gameweekData.missedPenalties * -15).toString()} />
  </div>

  {#if gameweekData.highestScoringPlayerId > 0}
    <div class="modal-row">
      <FantasyPlayerDetailRow col1="Highest Scoring Player" col2={gameweekData.highestScoringPlayerId.toString()} col3={(gameweekData.highestScoringPlayerId * 25).toString()} />
    </div>
  {/if}

  <div class="border-t-2 border-b border-BrandLightGray/80">
    <ModalTotalRow header="Player Points" content={gameweekData.points.toString()} />
  </div>
  <div class="border-y border-BrandLightGray/80">
    <ModalTotalRow header="Bonus Points" content={gameweekData.bonusPoints.toString()} />
  </div>

  {#if gameweekData.isCaptain}
    <div class="border-y border-BrandLightGray/80">
      <ModalTotalRow header="Captain Points" content={gameweekData.points.toString()} />
    </div>
  {/if}

  <div class="border-y border-BrandLightGray/80">
    <ModalTotalRow header="Total Points" content={gameweekData.totalPoints.toString()} />
  </div>
</Modal>