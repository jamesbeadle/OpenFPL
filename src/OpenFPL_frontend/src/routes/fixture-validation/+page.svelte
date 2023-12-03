<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { toastStore } from "$lib/stores/toast-store";
  import type {
    Fixture,
    SystemState,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import Layout from "../+Layout.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  let teams: Team[];
  let allFixtures: Fixture[];
  let fixtures: Fixture[];
  let players: PlayerDTO[];
  let systemState: SystemState | null;

  let unsubscribeSystemState: () => void;
  let unsubscribeTeams: () => void;
  let unsubscribePlayers: () => void;
  let unsubscribeFixtures: () => void;

  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let currentGameweek: number;
  let currentSeason: string;

  let isLoading = true;

  onMount(async () => {
    try {
      await systemStore.sync();
      await teamStore.sync();
      await playerStore.sync();

      unsubscribeSystemState = systemStore.subscribe((value) => {
        systemState = value;
        currentSeason = systemState?.activeSeason.name ?? "";
        currentGameweek = systemState?.activeGameweek ?? 1;
      });

      unsubscribeTeams = teamStore.subscribe((value) => {
        teams = value;
      });

      unsubscribePlayers = playerStore.subscribe((value) => {
        players = value;
      });

      unsubscribeFixtures = fixtureStore.subscribe((value) => {
        allFixtures = value;
        fixtures = value.filter(
          (x) => x.gameweek == systemState?.activeGameweek
        );
      });
    } catch (error) {
      toastStore.show("Error fetching fixture validation list.", "error");
      console.error("Error fetching fixture validation list.", error);
    } finally {
      isLoading = false;
    }
  });

  onDestroy(() => {
    unsubscribeTeams?.();
    unsubscribePlayers?.();
    unsubscribeSystemState?.();
  });

  $: if (systemState && currentGameweek) {
    fixtures = allFixtures.filter((x) => x.gameweek === currentGameweek);
  }

  const changeGameweek = (delta: number) => {
    currentGameweek = Math.max(1, Math.min(38, currentGameweek + delta));
  };

  function getTeamById(teamId: number): Team {
    return teams.find((x) => x.id === teamId)!;
  }
</script>

<Layout>
  {#if isLoading}
    <LoadingIcon />
  {:else}
    <div class="container-fluid mx-4 md:mx-16 mt-4 bg-panel">
      <div class="flex flex-col space-y-4 text-xs md:text-base">
        <div class="flex p-4">
          <h1>{`Season ${currentSeason}`} - {`Gameweek ${currentGameweek}`}</h1>
        </div>
        <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
          <div
            class="flex flex-col sm:flex-row justify-between sm:items-center"
          >
            <div class="md:flex md:items-center mt-2 sm:mt-0 ml-2">
              <button
                class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
                on:click={() => changeGameweek(-1)}
                disabled={currentGameweek === 1}>&lt;</button
              >
              <select
                class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px] md:min-w-[140px]"
                bind:value={currentGameweek}
              >
                {#each gameweeks as gameweek}
                  <option value={gameweek}>Gameweek {gameweek}</option>
                {/each}
              </select>
              <button
                class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
                on:click={() => changeGameweek(1)}
                disabled={currentGameweek === 38}>&gt;</button
              >
            </div>
          </div>
        </div>
        <div class="flex flex-col space-y-4 mt-4 text-xs md:text-base">
          <div class="overflow-x-auto flex-1">
            <div
              class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
            >
              <div class="w-1/4 px-4">Home Team</div>
              <div class="w-1/4 px-4">Away Team</div>
              <div class="w-1/4 px-4">Status</div>
              <div class="w-1/4 px-4">Actions</div>
            </div>

            {#if fixtures && fixtures.length > 0}
              {#each fixtures as fixture}
                {@const homeTeam = getTeamById(fixture.homeTeamId)}
                {@const awayTeam = getTeamById(fixture.awayTeamId)}
                <div
                  class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer"
                >
                  <div class="w-1/4 px-4">{homeTeam.friendlyName}</div>
                  <div class="w-1/4 px-4">{awayTeam.friendlyName}</div>
                  {#if fixture.status == 0}<div class="w-1/4 px-4">
                      Scheduled
                    </div>{/if}
                  {#if fixture.status == 1}<div class="w-1/4 px-4">
                      Active
                    </div>{/if}
                  {#if fixture.status == 2}<div class="w-1/4 px-4">
                      Completed
                    </div>{/if}
                  {#if fixture.status == 3}<div class="w-1/4 px-4">
                      Verified
                    </div>{/if}
                  <div class="w-1/4 px-4">
                    <button
                      class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
                    >
                      <a href="/add-fixture-data?id={fixture.id}">
                        Add Fixture Data
                      </a>
                    </button>
                  </div>
                </div>
              {/each}
            {:else}
              <p class="w-100 p-4">No leaderboard data.</p>
            {/if}
          </div>
        </div>
      </div>
    </div>
  {/if}
</Layout>
