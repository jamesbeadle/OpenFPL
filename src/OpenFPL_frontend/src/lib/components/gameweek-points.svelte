<script lang="ts">
  import { onMount } from "svelte";

  import { teamStore } from "$lib/stores/team-store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { authStore } from "$lib/stores/auth.store";

  import { getPositionAbbreviation } from "$lib/utils/Helpers";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { Principal } from "@dfinity/principal";

  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import FantasyPlayerDetailModal from "./fantasy-player-detail-modal.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  let isLoading = true;
  let selectedGameweek: number = $systemStore?.focusGameweek ?? 1;
  let gameweeks = Array.from(
    { length: $systemStore?.activeGameweek ?? 1 },
    (_, i) => i + 1
  );
  let showModal = false;

  let gameweekData: GameweekData[] = [];
  let selectedTeam: Team;
  let selectedOpponentTeam: Team;
  let selectedGameweekData: GameweekData;
  let activeSeasonName: string;

  onMount(async () => {
    try {
      await teamStore.sync();
      await systemStore.sync();
      await fixtureStore.sync();
      await authStore.sync();
      await playerEventsStore.sync();

      await loadGameweekPoints($authStore?.identity?.getPrincipal());
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching gameweek points." },
        err: error,
      });
      console.error("Error fetching gameweek points:", error);
    } finally {
      isLoading = false;
    }
  });

  $: if ($authStore?.identity?.getPrincipal()) {
    loadGameweekPoints($authStore?.identity?.getPrincipal());
  }

  async function loadGameweekPoints(principal: Principal | undefined | null) {
    if (!principal) {
      return;
    }
    let fantasyTeam = await managerStore.getFantasyTeamForGameweek(
      principal?.toText(),
      selectedGameweek
    );
    gameweekData = await playerEventsStore.getGameweekPlayers(
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
      selectedTeam = $teamStore.find((x) => x.id === playerTeamId)!;

      let playerFixture = $fixtureStore.find(
        (x) =>
          x.gameweek === gameweekData.gameweek &&
          (x.homeTeamId === playerTeamId || x.awayTeamId === playerTeamId)
      );
      let opponentId =
        playerFixture?.homeTeamId === playerTeamId
          ? playerFixture?.awayTeamId
          : playerFixture?.homeTeamId;
      selectedOpponentTeam = $teamStore.find((x) => x.id === opponentId)!;
      showModal = true;
    } catch (error) {
      toastsError({
        msg: { text: "Error loading gameweek detail." },
        err: error,
      });
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
      visible={showModal}
      {closeDetailModal}
      gameweekData={selectedGameweekData}
    />
  {/if}

  <div class="container-fluid mt-4 mb-4">
    <div class="flex flex-col space-y-4 text-xs md:text-base">
      <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
        <div class="flex items-center ml-4">
          <div class="flex items-center mr-8">
            <button
              class={`${
                selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
              } text-base sm:text-xs md:text-base rounded px-3 sm:px-2 px-3 py-1`}
              on:click={() => changeGameweek(-1)}
              disabled={selectedGameweek === 1}
            >
              &lt;
            </button>

            <select
              class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]"
              bind:value={selectedGameweek}
            >
              {#each gameweeks as gameweek}
                <option value={gameweek}>Gameweek {gameweek}</option>
              {/each}
            </select>

            <button
              class={`${
                selectedGameweek === $systemStore?.activeGameweek
                  ? "bg-gray-500"
                  : "fpl-button"
              } text-base sm:text-xs md:text-base rounded px-3 sm:px-2 px-3 py-1 ml-1`}
              on:click={() => changeGameweek(1)}
              disabled={selectedGameweek === $systemStore?.activeGameweek}
            >
              &gt;
            </button>
          </div>
        </div>
      </div>
      <div class="flex flex-col space-y-4 mt-4 text-lg text-xs md:text-base">
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
                    {playerGameweek.player.firstName.length > 0
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
