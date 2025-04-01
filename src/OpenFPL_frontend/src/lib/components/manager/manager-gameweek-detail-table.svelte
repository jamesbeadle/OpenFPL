<script lang="ts">
  import { type Writable } from "svelte/store";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import { playerStore } from "$lib/stores/player-store";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import GameweekDetailTableRow from "./gameweek-detail-table-row.svelte";
  import FantasyPlayerDetailModal from "../fantasy-team/fantasy-player-detail-modal.svelte";
    import type { FantasyTeamSnapshot } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import type { Club } from "../../../../../declarations/data_canister/data_canister.did";
  
  export let fantasyTeam: Writable<FantasyTeamSnapshot | null>;
  export let gameweekPlayers: Writable<GameweekData[]>;
  export let showModal = false;
  export let activeSeasonName: string;
  
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
    {#if $fantasyTeam}
      <div class="overflow-x-auto flex-1">
        <div
          class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
        >
          <div class="w-1/12 text-center">Pos</div>
          <div class="w-2/12">Player</div>
          <div class="w-1/12 hidden lg:flex">Team</div>
          <div class="w-1/2 xxs:w-7/12 lg:7/12 flex">
            <div class="w-4/12 xxs:w-1/12 text-center">A</div>
            <div class="w-4/12 xxs:w-1/12 text-center">HSP</div>
            <div class="hidden xxs:block w-1/12 text-center">GS</div>
            <div class="hidden xxs:block w-1/12 text-center">GA</div>
            <div class="hidden xxs:block w-1/12 text-center">PS</div>
            <div class="hidden xxs:block w-1/12 text-center">CS</div>
            <div class="hidden xxs:block w-1/12 text-center">KS</div>
            <div class="hidden xxs:block w-1/12 text-center">YC</div>
            <div class="hidden xxs:block w-1/12 text-center">OG</div>
            <div class="hidden xxs:block w-1/12 text-center">GC</div>
            <div class="hidden xxs:block w-1/12 text-center">RC</div>
            <div class="w-4/12 xxs:w-1/12 text-center">B</div>
          </div>
          <div class="w-1/12 text-center">C</div>
          <div class="w-1/12 text-center">PTS</div>
        </div>

        {#each $gameweekPlayers as data}
          {@const playerDTO = $playerStore.find((x) => x.id === data.player.id) ?? null}
          {@const playerTeam = $clubStore.find((x) => x.id === data.player.clubId) ?? null}
          <button
            class="w-full"
            on:click={() => {
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
      bind:visible={showModal}
      gameweekData={selectedGameweekData}
    />
  {/if}