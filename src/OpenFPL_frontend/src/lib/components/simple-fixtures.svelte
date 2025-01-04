<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import { convertFixtureStatus, formatUnixTimeToTime, getFixturesWithTeams, getGameweeks, reduceFilteredFixtures } from "../utils/helpers";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import GameweekFilter from "./shared/filters/gameweek-filter.svelte";
  import { writable } from "svelte/store";

  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedGameweek = writable(1);
  let gameweeks = getGameweeks(Number(process.env.TOTAL_GAMEWEEKS));
  
  $: filteredFixtures = fixturesWithTeams.filter(
    ({ fixture }) => fixture.gameweek === $selectedGameweek
  );

  $: groupedFixtures = reduceFilteredFixtures(filteredFixtures);

  onMount(async () => {
    await storeManager.syncStores();
    $selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1;
    fixturesWithTeams = getFixturesWithTeams($clubStore, $fixtureStore);
  });

  const changeGameweek = (delta: number) => {
    $selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), $selectedGameweek + delta));
  };
</script>

<div class="bg-panel">
  <div>
    <div class="flex items-center justify-between py-2 bg-light-gray">
      <h1 class="mx-4 m-2 side-panel-header">Fixtures</h1>
    </div>
    <GameweekFilter {selectedGameweek} {gameweeks} {changeGameweek} leagueStatus={$leagueStore!} />
    <div>
      {#each Object.entries(groupedFixtures) as [date, fixtures]}
        <div class="flex items-center justify-between border-b border-gray-700 py-2 bg-light-gray">
          <h2 class="ml-4">{date}</h2>
        </div>
        {#each fixtures as { fixture, homeTeam, awayTeam }}
          <div class={`flex items-center justify-between py-2 border-b border-gray-700
              ${ convertFixtureStatus(fixture.status) < 3 ? "text-gray-400" : "text-white" }`}
          >
            <div class="flex w-full items-center space-x-10 mx-4 xs:mx-8">
              <div class="flex flex-col w-3/6 min-w-[100px] md:min-w-[200px]">
                <a class="my-1 flex items-center" href={`/club?id=${fixture.homeClubId}`}>
                  <BadgeIcon club={homeTeam} className="w-4 mr-1" />
                  {homeTeam ? homeTeam.friendlyName : ""}
                </a>
                <a class="my-1 flex items-center" href={`/club?id=${fixture.awayClubId}`}>
                  <BadgeIcon club={awayTeam} className="w-4 mr-1" />
                  {awayTeam ? awayTeam.friendlyName : ""}
                </a>
              </div>
              <div class="flex flex-col w-1/6 items-center justify-center">
                <span>{convertFixtureStatus(fixture.status) < 3 ? "-" : fixture.homeGoals}</span>
                <span>{convertFixtureStatus(fixture.status) < 3 ? "-" : fixture.awayGoals}</span>
              </div>
              <div class="flex flex-col w-2/6">
                <span class="md:ml-0">{formatUnixTimeToTime(fixture.kickOff)}</span>
              </div>
            </div>
          </div>
        {/each}
      {/each}
    </div>
  </div>
</div>