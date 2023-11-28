<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import type { Fixture, SystemState, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import { systemStore } from "$lib/stores/system-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { toastStore } from "$lib/stores/toast-store";

  let teams: Team[];
  let fixtures: Fixture[];
  let players: PlayerDTO[];
  let systemState: SystemState | null;

  let unsubscribeSystemState: () => void;
  let unsubscribeTeams: () => void;
  let unsubscribePlayers: () => void;
  let unsubscribeFixtures: () => void;

  let currentGameweek: number;
  let currentSeason: string;
  let isLoading = true;

  onMount(async () => {
    try {
        systemStore.sync();
        teamStore.sync();
        playerStore.sync();

        unsubscribeSystemState = systemStore.subscribe((value) => {
          systemState = value;
          currentSeason = systemState?.activeSeason.name ?? "";
        });
      
        unsubscribeTeams = teamStore.subscribe((value) => {
          teams = value;
        });
        
        unsubscribePlayers = playerStore.subscribe((value) => {
          players = value;
        });

      fixtures = await governanceStore.getValidatableFixtures();
      currentGameweek = fixtures[0].gameweek;
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

  function getTeamById(teamId: number): Team {
    return teams.find((x) => x.id === teamId)!;
  }
</script>

{#if isLoading}
  <div class="flex items-center justify-center h-screen">
    <div
      class="spinner-border animate-spin inline-block w-8 h-8 border-4 rounded-full"
      role="status"
    >
      <span class="visually-hidden">Loading...</span>
    </div>
    <p class="text-center mt-1">Loading Fixtures</p>
  </div>
{:else}
  <div class="container mx-auto my-5 flex-grow">
    <div class="card mb-3 p-4">
      <p>This view will be removed after the SNS decentralisation sale</p>
    </div>
    <div class="card custom-card mt-3 p-4">
      <div class="card-header">
        {`Season ${currentSeason}`} - {`Gameweek ${currentGameweek}`}
      </div>
      <div class="card-body">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th scope="col">#</th>
              <th scope="col">Match</th>
              <th scope="col">Status</th>
              <th scope="col">Action</th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            {#each fixtures as fixture, index (fixture.id)}
              <tr>
                <td>{index + 1}</td>
                <td
                  >{`${getTeamById(fixture.homeTeamId).name} vs ${
                    getTeamById(fixture.awayTeamId).name
                  }`}</td
                >
                <td>{fixture.status === 2 ? "Completed" : "Active"}</td>
                <td>
                  <a href={`/add-fixture-data?id=${fixture.id}`}>
                    <button class="btn btn-primary">
                      Add Player Event Data
                    </button>
                  </a>
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  </div>
{/if}
