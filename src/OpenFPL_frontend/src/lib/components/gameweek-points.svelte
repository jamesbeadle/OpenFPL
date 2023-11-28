<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { getPositionAbbreviation } from "$lib/utils/Helpers";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import FantasyPlayerDetailModal from "./fantasy-player-detail-modal.svelte";
  import { toastStore } from "$lib/stores/toast-store";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import { managerStore } from "$lib/stores/manager-store";
  import { playerStore } from "$lib/stores/player-store";
  import type { Fixture } from "../../../../declarations/player_canister/player_canister.did";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import type {
    SystemState,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  let teams: Team[] = [];
  let systemState: SystemState | null;
  let fixtures: Fixture[] = [];
  let unsubscribeTeams: () => void;
  let unsubscribeSystemState: () => void;
  let unsubscribeFixtures: () => void;

  let selectedGameweek: number = 1;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let gameweekData: GameweekData[] = [];
  let showModal = false;
  let selectedTeam: Team;
  let selectedOpponentTeam: Team;
  let selectedGameweekData: GameweekData;
  let activeSeasonName: string;
  let isLoading = true;

  onMount(async () => {
    try {
      await teamStore.sync();
      await systemStore.sync();
      await fixtureStore.sync();

      unsubscribeTeams = teamStore.subscribe((value) => {
        teams = value.sort((a, b) =>
          a.friendlyName.localeCompare(b.friendlyName)
        );
      });

      unsubscribeSystemState = systemStore.subscribe((value) => {
        systemState = value;
      });

      unsubscribeFixtures = fixtureStore.subscribe((value) => {
        fixtures = value;
      });

      await loadGameweekPoints("");
    } catch (error) {
      toastStore.show("Error fetching gameweek points.", "error");
      console.error("Error fetching gameweek points:", error);
    } finally {
      isLoading = false;
    }
  });

  onDestroy(() => {
    unsubscribeTeams?.();
    unsubscribeFixtures?.();
    unsubscribeSystemState?.();
  });

  async function loadGameweekPoints(principalId: string) {
    let fantasyTeam = await managerStore.getFantasyTeamForGameweek(
      principalId,
      selectedGameweek
    );
    gameweekData = await playerStore.getGameweekPlayers(
      fantasyTeam,
      selectedGameweek
    );
  }

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  async function showDetailModal(gameweekData: GameweekData) {
    try {
      selectedGameweekData = gameweekData;
      let playerTeamId = gameweekData.player.teamId;
      selectedTeam = teams.find((x) => x.id === playerTeamId)!;

      let playerFixture = fixtures.find(
        (x) =>
          x.gameweek === gameweekData.gameweek &&
          (x.homeTeamId === playerTeamId || x.awayTeamId === playerTeamId)
      );
      let opponentId =
        playerFixture?.homeTeamId === playerTeamId
          ? playerFixture?.awayTeamId
          : playerFixture?.homeTeamId;
      selectedOpponentTeam = teams.find((x) => x.id === opponentId)!;
      showModal = true;
    } catch (error) {
      toastStore.show("Error loading gameweek detail.", "error");
      console.error("Error loading gameweek detail:", error);
    }
  }

  function closeDetailModal() {
    showModal = false;
  }
</script>

{#if isLoading}
  <LoadingIcon />
{:else}
  {#if showModal}
    <FantasyPlayerDetailModal
      playerTeam={selectedTeam}
      opponentTeam={selectedOpponentTeam}
      seasonName={activeSeasonName}
      {showModal}
      {closeDetailModal}
      gameweekData={selectedGameweekData}
    />
  {/if}

  <div class="container-fluid mt-4">
    <div class="flex flex-col space-y-4">
      <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
        <div class="flex items-center ml-4">
          <div class="flex items-center mr-8">
            <button
              class="text-2xl rounded fpl-button px-3 py-1"
              on:click={() => changeGameweek(-1)}
              disabled={selectedGameweek === 1}
            >
              &lt;
            </button>

            <select
              class="p-2 fpl-dropdown text-sm md:text-xl text-center"
              bind:value={selectedGameweek}
            >
              {#each gameweeks as gameweek}
                <option value={gameweek}>Gameweek {gameweek}</option>
              {/each}
            </select>

            <button
              class="text-2xl rounded fpl-button px-3 py-1 ml-1"
              on:click={() => changeGameweek(1)}
              disabled={selectedGameweek === 38}
            >
              &gt;
            </button>
          </div>
        </div>
      </div>
      <div class="flex flex-col space-y-4 mt-4 text-lg">
        <div class="overflow-x-auto flex-1">
          <div
            class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
          >
            <div class="w-1/6 text-center mx-4">Pos</div>
            <div class="w-3/6 px-4">Player</div>
            <div class="w-1/6 text-center">Points</div>
            <div class="w-1/6 text-center">&nbsp;</div>
          </div>
          {#if gameweekData.length > 0}
            {#each gameweekData as playerGameweek}
              <div
                class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer"
              >
                <div class="w-1/6 text-center">
                  {getPositionAbbreviation(playerGameweek.player.position)}
                </div>
                <div class="w-3/6 text-center">
                  <a href={`/player?id=${playerGameweek.player.id}`}>
                    {playerGameweek.player.firstName.length > 2
                      ? playerGameweek.player.firstName.substring(0, 1) + "."
                      : ""}
                    {playerGameweek.player.lastName}</a
                  >
                </div>
                <div class="w-1/6 text-center">{playerGameweek.points}</div>
                <div class="w-1/6 text-center">
                  <button on:click={() => showDetailModal(playerGameweek)}>
                    <span class="flex items-center">
                      <ViewDetailsIcon className="w-6 mr-2" />View Details
                    </span>
                  </button>
                </div>
              </div>
            {/each}
          {:else}
            <p class="w-100 p-4">No data.</p>
          {/if}
        </div>
      </div>
    </div>
  </div>
{/if}
