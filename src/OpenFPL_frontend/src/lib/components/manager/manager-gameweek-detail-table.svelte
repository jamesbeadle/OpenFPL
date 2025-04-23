w<script lang="ts">
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import { playerStore } from "$lib/stores/player-store";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import GameweekDetailTableRow from "./gameweek-detail-table-row.svelte";
  import FantasyPlayerDetailModal from "../fantasy-team/fantasy-player-detail-modal.svelte";
  import type { FantasyTeamSnapshot, Club } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  interface Props {
    fantasyTeam: FantasyTeamSnapshot | null;
    gameweekPlayers: GameweekData[];
    showModal: boolean;
    activeSeasonName: string;
  }
  let { fantasyTeam, gameweekPlayers, showModal, activeSeasonName }: Props = $props();
  
  let selectedTeam: Club;
  let selectedOpponentTeam: Club;
  let selectedGameweekData: GameweekData;
  
  async function showDetailModal(gameweekData: GameweekData) {
    selectedGameweekData = gameweekData;
    let playerTeamId = gameweekData.player.clubId;
    selectedTeam = $clubStore.find((x) => x.id === playerTeamId)!;

    let playerFixture = $fixtureStore.find(
      (x) =>
        x.gameweek === gameweekData.gameweek &&
        (x.homeClubId === playerTeamId || x.awayClubId === playerTeamId)
    );
    let opponentId =
      playerFixture?.homeClubId === playerTeamId
        ? playerFixture?.awayClubId
        : playerFixture?.homeClubId;
    selectedOpponentTeam = $clubStore.find((x) => x.id === opponentId)!;
    showModal = true;
  }

</script>

<div class="flex flex-col">
    {#if fantasyTeam}
      <div class="flex-1 overflow-x-auto">
        <div
          class="flex justify-between p-2 py-4 border border-gray-700 bg-light-gray"
        >
          <div class="w-1/12 text-center">Pos</div>
          <div class="w-2/12">Player</div>
          <div class="hidden w-1/12 lg:flex">Team</div>
          <div class="flex w-1/2 xxs:w-7/12 lg:7/12">
            <div class="w-4/12 text-center xxs:w-1/12">A</div>
            <div class="w-4/12 text-center xxs:w-1/12">HSP</div>
            <div class="hidden w-1/12 text-center xxs:block">GS</div>
            <div class="hidden w-1/12 text-center xxs:block">GA</div>
            <div class="hidden w-1/12 text-center xxs:block">PS</div>
            <div class="hidden w-1/12 text-center xxs:block">CS</div>
            <div class="hidden w-1/12 text-center xxs:block">KS</div>
            <div class="hidden w-1/12 text-center xxs:block">YC</div>
            <div class="hidden w-1/12 text-center xxs:block">OG</div>
            <div class="hidden w-1/12 text-center xxs:block">GC</div>
            <div class="hidden w-1/12 text-center xxs:block">RC</div>
            <div class="w-4/12 text-center xxs:w-1/12">B</div>
          </div>
          <div class="w-1/12 text-center">C</div>
          <div class="w-1/12 text-center">PTS</div>
        </div>

        {#each $gameweekPlayers as data}
          {@const playerDTO = $playerStore.find((x) => x.id === data.player.id) ?? null}
          {@const playerTeam = $clubStore.find((x) => x.id === data.player.clubId) ?? null}
          <button
            class="w-full"
            onclick={() => {
              showDetailModal(data);
            }}
          >
           <GameweekDetailTableRow fantasyTeam={fantasyTeam} player={playerDTO!} playerTeam={playerTeam!} {data} />
          </button>
        {/each} 
      </div>
    {:else}
      <p>No Fantasy Team Data</p>
    {/if}
  </div>

  {#if showModal}
    <FantasyPlayerDetailModal
      playerTeam={selectedTeam}
      opponentTeam={selectedOpponentTeam}
      seasonName={activeSeasonName}
      visible={showModal}
      gameweekData={selectedGameweekData}
    />
  {/if}