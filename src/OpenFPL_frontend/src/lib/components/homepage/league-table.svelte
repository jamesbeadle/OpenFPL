<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { getFixturesWithTeams, getGameweeks, updateTableData } from "../../utils/helpers";
  import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import { writable } from "svelte/store";
  import GameweekFilter from "../shared/filters/gameweek-filter.svelte";

  let fixturesWithTeams: FixtureWithClubs[] = [];
  let selectedGameweek = writable(1);
  let gameweeks: number[];
  let tableData: any[] = [];
  let isLoading = true;

  onMount(async () => {
    await storeManager.syncStores();
    gameweeks = getGameweeks($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1);
    $selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1;
    fixturesWithTeams = getFixturesWithTeams($clubStore, $fixtureStore);
    isLoading = false;
  });

  $: if ($fixtureStore.length > 0 && $clubStore.length > 0) {
    tableData = updateTableData(fixturesWithTeams, $clubStore, $selectedGameweek);
  }

  const changeGameweek = (delta: number) => {
    $selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), $selectedGameweek + delta));
  };
</script>
{#if isLoading}
  <WidgetSpinner />
{:else}
  <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
    <GameweekFilter {selectedGameweek} {gameweeks} {changeGameweek} />
  </div>

  <div class="flex flex-col">
    <div class="overflow-x-auto flex-1">
      <div class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray">
        <div class="w-2/12 text-center">Pos</div>
        <div class="w-6/12">Team</div>
        <div class="w-1/12">P</div>
        <div class="hidden sm:flex w-1/12 text-center">W</div>
        <div class="hidden sm:flex w-1/12 text-center">D</div>
        <div class="hidden sm:flex w-1/12 text-center">L</div>
        <div class="hidden sm:flex w-1/12 text-center">GF</div>
        <div class="hidden sm:flex w-1/12 text-center">GA</div>
        <div class="w-1/12">GD</div>
        <div class="w-1/12">PTS</div>
      </div>

      {#each tableData as team, idx}
        <div class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer">
          <div class="w-2/12 text-center">{idx + 1}</div>
          <a class="w-6/12 flex items-center justify-start" href={`/club?id=${team.id}`}>
            <BadgeIcon club={team} className="w-6 h-6 mr-2" />
            {team.friendlyName}
          </a>
          <div class="w-1/12">{team.played}</div>
          <div class="hidden sm:flex w-1/12">{team.wins}</div>
          <div class="hidden sm:flex w-1/12">{team.draws}</div>
          <div class="hidden sm:flex w-1/12">{team.losses}</div>
          <div class="hidden sm:flex w-1/12">{team.goalsFor}</div>
          <div class="hidden sm:flex w-1/12">{team.goalsAgainst}</div>
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