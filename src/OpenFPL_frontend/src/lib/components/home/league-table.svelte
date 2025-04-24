<script lang="ts">
    import { onMount } from "svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { leagueStore } from "$lib/stores/league-store";
    import { clubStore } from "$lib/stores/club-store";
    import { fixtureStore } from "$lib/stores/fixture-store";
    import { toasts } from "$lib/stores/toasts-store";
    import { getFixturesWithTeams, updateTableData } from "../../utils/helpers";
    import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";
    import LocalSpinner from "../shared/local-spinner.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
    
    let isLoading = $state(true);
    let selectedSeasonId = $state(0);
    let selectedGameweek = $state(1);
    let fixturesWithTeams: FixtureWithClubs[] = $state([]);
    let tableData: any[] = $state([]);
    
    onMount(async () => {
        try{
            await storeManager.syncStores();
            selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.completedGameweek : $leagueStore!.activeGameweek ?? 1;
            selectedSeasonId = $leagueStore?.activeSeasonId ?? 0;
            fixturesWithTeams = getFixturesWithTeams($clubStore, $fixtureStore);
            if ($fixtureStore.length > 0 && $clubStore.length > 0) {
                tableData = updateTableData(fixturesWithTeams, $clubStore, selectedGameweek);
            }
        } catch {
            toasts.addToast({type: 'error', message: 'Error loading active season information'});
        } finally {
            isLoading = false;
        }
    });
  </script>
  {#if isLoading}
    <LocalSpinner />
    <p class="pb-4 mb-4 text-center">Getting League Table for Gameweek {selectedGameweek}</p>
  {:else}
    <div class="flex flex-col gap-4 sm:flex-row sm:gap-8">
      <GameweekFilter {selectedGameweek} />
    </div>
  
    <div class="flex flex-col">
      <div class="flex-1 overflow-x-auto">
        <div class="flex justify-between px-2 py-4 border border-gray-700 bg-light-gray">
          <div class="w-2/12 text-center">Pos</div>
          <div class="w-6/12">Team</div>
          <div class="w-1/12">P</div>
          <div class="hidden w-1/12 text-center sm:flex">W</div>
          <div class="hidden w-1/12 text-center sm:flex">D</div>
          <div class="hidden w-1/12 text-center sm:flex">L</div>
          <div class="hidden w-1/12 text-center sm:flex">GF</div>
          <div class="hidden w-1/12 text-center sm:flex">GA</div>
          <div class="w-1/12">GD</div>
          <div class="w-1/12">PTS</div>
        </div>
  
        {#each tableData as team, idx}
          <div class="flex justify-between px-2 py-4 border-b border-gray-700 cursor-pointer">
            <div class="w-2/12 text-center">{idx + 1}</div>
            <a class="flex items-center justify-start w-6/12" href={`/club?id=${team.id}`}>
              <BadgeIcon club={team} className="w-6 h-6 mr-2" />
              {team.friendlyName}
            </a>
            <div class="w-1/12">{team.played}</div>
            <div class="hidden w-1/12 sm:flex">{team.wins}</div>
            <div class="hidden w-1/12 sm:flex">{team.draws}</div>
            <div class="hidden w-1/12 sm:flex">{team.losses}</div>
            <div class="hidden w-1/12 sm:flex">{team.goalsFor}</div>
            <div class="hidden w-1/12 sm:flex">{team.goalsAgainst}</div>
            <div class="w-1/12">{team.goalsFor - team.goalsAgainst}</div>
            <div class="w-1/12">{team.points}</div>
          </div>
        {/each}
        {#if Object.entries(tableData).length == 0}
          <p class="px-4 py-4">No table data.</p>
        {/if}
      </div>
    </div>
  {/if}