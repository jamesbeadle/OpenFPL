<script lang="ts">
  import { onMount } from "svelte";

  import { clubStore } from "$lib/stores/club-store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { managerStore } from "$lib/stores/manager-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { authStore } from "$lib/stores/auth.store";

  import {
    convertPlayerPosition,
    getPositionAbbreviation,
  } from "$lib/utils/helpers";
  import type { GameweekData } from "$lib/interfaces/GameweekData";
  import type { ClubDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import FantasyPlayerDetailModal from "./fantasy-player-detail-modal.svelte";
    import LocalSpinner from "./local-spinner.svelte";
    import { seasonStore } from "../stores/season-store";
    import { storeManager } from "$lib/managers/store-manager";

  let isLoading = true;
  let selectedGameweek: number;
  let gameweeks: number[];
  let showModal = false;

  let gameweekData: GameweekData[] = [];
  let selectedTeam: ClubDTO;
  let selectedOpponentTeam: ClubDTO;
  let selectedGameweekData: GameweekData;
  let activeSeasonName: string;

  onMount(async () => {
    try {
      await storeManager.syncStores();
      activeSeasonName = await seasonStore.getSeasonName($systemStore?.calculationSeasonId ?? 0) ?? "";
      gameweeks = Array.from(
        { length: $systemStore?.calculationGameweek ?? 1 },
        (_, i) => i + 1
      );
      selectedGameweek = $systemStore?.calculationGameweek ?? 1;
      let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
      if(principal == ""){
        return;
      }
      await loadGameweekPoints(principal);
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

  $: if (selectedGameweek && $authStore?.identity?.getPrincipal()) {
    let principal = $authStore?.identity?.getPrincipal().toText() ?? "";
    if(principal != ""){
      loadGameweekPoints(principal);
    }
  }

  async function loadGameweekPoints(principal: string) {
    if (!principal) {
      return;
    }

    let fantasyTeam = await managerStore.getFantasyTeamForGameweek(
      principal,
      $systemStore?.calculationSeasonId ?? 1,
      selectedGameweek
    );

    if (!fantasyTeam) {
      return;
    }
    
    let unsortedData = await playerEventsStore.getGameweekPlayers(
      fantasyTeam,
      1, //TODO SET FROM DROPDOWN
      selectedGameweek
    );

    gameweekData = unsortedData.sort((a, b) => b.points - a.points);
  }

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), selectedGameweek + delta));
  };

  async function showDetailModal(gameweekData: GameweekData) {
    try {
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
  <LocalSpinner />
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

  <div class="flex flex-col space-y-4">
    <div class="flex flex-col sm:flex-row gap-4 sm:gap-8 lg:px-4">
      <div class="flex items-center ml-4">
        <div class="flex items-center mr-8">
          <button
            class={`${
              selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
            } default-button`}
            on:click={() => changeGameweek(-1)}
            disabled={selectedGameweek === 1}
          >
            &lt;
          </button>

          <select
            class="p-2 fpl-dropdown my-4 min-w-[100px]"
            bind:value={selectedGameweek}
          >
            {#each gameweeks as gameweek}
              <option value={gameweek}>Gameweek {gameweek}</option>
            {/each}
          </select>

          <button
            class={`${
              selectedGameweek === $systemStore?.calculationGameweek
                ? "bg-gray-500"
                : "fpl-button"
            } default-button ml-1`}
            on:click={() => changeGameweek(1)}
            disabled={selectedGameweek === $systemStore?.calculationGameweek}
          >
            &gt;
          </button>
        </div>
      </div>
    </div>
    <div class="flex flex-col space-y-4 mt-4">
      <div class="overflow-x-auto flex-1">
        <div
          class="flex justify-between border-b border-t border-gray-700 p-4 bg-light-gray lg:px-8"
        >
          <div class="w-2/12 xs:w-2/12">Pos</div>
          <div class="w-6/12 xs:w-4/12">Player</div>
          <div class="w-3/12 xs:w-3/12">Points</div>
          <div class="w-2/12 xs:w-3/12">&nbsp;</div>
        </div>
        {#if gameweekData.length > 0}
          {#each gameweekData as playerGameweek}
            <button
              class="flex justify-between p-4 border-b border-gray-700 cursor-pointer lg:px-8 w-full"
              on:click={() => showDetailModal(playerGameweek)}
            >
              <div class="w-2/12 xs:w-2/12">
                {getPositionAbbreviation(
                  convertPlayerPosition(playerGameweek.player.position)
                )}
              </div>
              <div class="w-6/12 xs:w-4/12">
                <a href={`/player?id=${playerGameweek.player.id}`}>
                  {playerGameweek.player.firstName.length > 0
                    ? playerGameweek.player.firstName.substring(0, 1) + "."
                    : ""}
                  {playerGameweek.player.lastName}</a
                >
              </div>
              <div class="w-3/12 xs:w-3/12">{playerGameweek.points}</div>
              <div
                class="w-2/12 xs:w-3/12 flex items-center justify-center xs:justify-start"
              >
                <span class="flex items-center">
                  <ViewDetailsIcon className="w-5 xs:w-6 lg:w-7" /><span
                    class="hidden xs:flex ml-1 lg:ml-2">View Details</span
                  >
                </span>
              </div>
            </button>
          {/each}
        {:else}
          <p class="w-full p-4">You have no data for the selected gameweek.</p>
        {/if}
      </div>
    </div>
  </div>
{/if}
