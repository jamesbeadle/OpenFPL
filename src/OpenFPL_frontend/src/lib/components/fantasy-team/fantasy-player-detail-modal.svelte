<script lang="ts">
  import { convertPositionToIndex, getFlagComponent, getPlayerName } from "../../utils/helpers";
  import type { ClubDTO } from "../../../../../declarations/data_canister/data_canister.did";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import Modal from "$lib/components/shared/modal.svelte";
  import FantasyPlayerDetailRow from "./fantasy-player-detail-row.svelte";
  import ModalTotalRow from "../shared/modal-total-row.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  
  export let visible: boolean;
  export let gameweekData: GameweekData;
  export let playerTeam: ClubDTO;
  export let opponentTeam: ClubDTO;
  export let seasonName: string;
</script>

<Modal showModal={visible} onClose={() => {visible = false;}} title="Player Detail">
  <div class="flex justify-start items-center w-full">
    <svelte:component this={getFlagComponent(gameweekData.nationalityId)} class="h-20 w-20" />
    <div class="w-full flex-col space-y-4 mb-2">
      <h3 class="default-header mb-2">
        { getPlayerName(gameweekData.player) }
      </h3>
      <p class="text-gray-400 flex items-center">
        <BadgeIcon className="w-5 h-5 mr-2" club={playerTeam!} />
        {playerTeam?.friendlyName}
      </p>
    </div>
  </div>

  <div class="flex justify-start items-center w-full border-t border-gray-600" >
    <p class="flex w-1/3 items-center border-r border-gray-600 pt-2 ml-2 xs:ml-0 xs:justify-center">
      vs <BadgeIcon className="w-5 h-5 mx-1" club={opponentTeam!} /> {opponentTeam?.abbreviatedName}
    </p>
    <p class="flex w-1/3 justify-center items-center pt-2">{seasonName}</p>
    <p class="flex w-1/3 items-center justify-end border-l border-gray-600 pt-2 mr-2 xs:mr-0 xs:justify-center">
      Gameweek {gameweekData.gameweek}
    </p>
  </div>

  <div class="modal-header-row">
    <FantasyPlayerDetailRow col1="Category" col2="Detail" col3="Points" />
  </div>
  <div class="modal-row">
    <FantasyPlayerDetailRow col1="Appearance" col2={gameweekData.appearance > 0 ? gameweekData.appearance.toString() : "-"} col3={gameweekData.appearance > 0 ? (gameweekData.appearance * 5).toString() : "-"} />
  </div>
  <div class="modal-row">
    <FantasyPlayerDetailRow col1="Goals" col2={gameweekData.goals.toString()} col3={gameweekData.goalPoints.toString()} />
  </div>
  <div class="modal-row">
    <FantasyPlayerDetailRow col1="Assists" col2={gameweekData.assists.toString()} col3={gameweekData.assistPoints.toString()} />
  </div>
  <div class="modal-row">
    <FantasyPlayerDetailRow col1="Yellow Card" col2={gameweekData.yellowCards.toString()} col3={(gameweekData.yellowCards * -5).toString()} />
  </div>
  <div class="modal-row">
    <FantasyPlayerDetailRow col1="Red Card" col2={gameweekData.redCards.toString()} col3={(gameweekData.redCards > 0 ? -20 : 0).toString()} />
  </div>

  {#if convertPositionToIndex(gameweekData.player.position) < 2}
    <div class="modal-row">
      <FantasyPlayerDetailRow col1="Clean Sheet" col2={gameweekData.cleanSheets.toString()} col3={gameweekData.cleanSheetPoints.toString()} />
    </div>
    <div class="modal-row">
      <FantasyPlayerDetailRow col1="Conceded" col2={gameweekData.goalsConceded.toString()} col3={gameweekData.goalsConcededPoints.toString()} />
    </div>
  {/if}

  {#if convertPositionToIndex(gameweekData.player.position) === 0}
    <div class="modal-row">
      <FantasyPlayerDetailRow col1="Saves" col2={gameweekData.saves.toString()} col3={(Math.floor(gameweekData.saves / 3) * 5).toString()} />
    </div>
    <div class="modal-row">
      <FantasyPlayerDetailRow col1="Penalty Saves" col2={gameweekData.penaltySaves.toString()} col3={(gameweekData.penaltySaves * 20).toString()} />
    </div>
  {/if}

  <div class="modal-row">
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

  <ModalTotalRow header="Player Points" content={gameweekData.points.toString()} />
  <ModalTotalRow header="Bonus Points" content={gameweekData.bonusPoints.toString()} />

  {#if gameweekData.isCaptain}
    <ModalTotalRow header="Captain Points" content={gameweekData.points.toString()} />
  {/if}

  <ModalTotalRow header="Total Points" content={gameweekData.totalPoints.toString()} />
</Modal>