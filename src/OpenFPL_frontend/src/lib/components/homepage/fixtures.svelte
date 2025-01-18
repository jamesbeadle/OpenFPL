<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { formatUnixTimeToTime, getFixturesWithTeams, getGameweeks, reduceFilteredFixtures } from "../../utils/helpers";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import { writable } from "svelte/store";
  import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
  import FixtureStatus from "./fixture-status.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";

  let isLoading = true;
  let gameweeks = getGameweeks(Number(process.env.TOTAL_GAMEWEEKS));
  let selectedGameweek = writable(1);
  let fixturesWithTeams: FixtureWithTeams[] = [];

  $: filteredFixtures = fixturesWithTeams.filter(({ fixture }) => fixture.gameweek === $selectedGameweek);
  $: groupedFixtures = reduceFilteredFixtures(filteredFixtures)

  onMount(async () => {
    await storeManager.syncStores();
    $selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1;
    fixturesWithTeams = getFixturesWithTeams($clubStore, $fixtureStore);
    isLoading = false;
  });

  const changeGameweek = (delta: number) => {
    $selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), $selectedGameweek + delta));
  };

</script>
{#if isLoading}
  <WidgetSpinner />
{:else}
  <div class="flex flex-col">
    <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
      <GameweekFilter {selectedGameweek} {gameweeks} {changeGameweek}/>
    </div>
    <div>
      {#each Object.entries(groupedFixtures) as [date, fixtures]}
          <div class="flex items-center justify-between border border-gray-700 py-4 bg-light-gray">
            <h2 class="ml-4">{date}</h2>
          </div>
          {#each fixtures as { fixture, homeTeam, awayTeam }}
            <div
              class={`flex flex-row items-center py-2 border-b border-gray-700  
                ${ Object.keys(fixture.status)[0] != "Finalised" ? "text-gray-400" : "text-white" }`}
            >

              <div class="flex flex-col w-7/12 xs:w-6/12 md:w-5/12 lg:w-5/12 space-y-2">
                <a class="flex flex-row items-center" href={`/club?id=${fixture.homeClubId}`}>
                  <BadgeIcon club={homeTeam!} className="h-6 mr-2 ml-4" />
                  {homeTeam ? homeTeam.friendlyName : ""}
                </a>
                <a class="flex flex-row items-center" href={`/club?id=${fixture.awayClubId}`}>
                  <BadgeIcon club={awayTeam!} className="h-6 mr-2 ml-4" />
                  {awayTeam ? awayTeam.friendlyName : ""}
                </a>
              </div>

              <div class="flex w-5/12 xs:w-4/12 md:w-3/12 lg:w-3/12 flex-col text-center items-center justify-center">
                <span>{Object.keys(fixture.status)[0] != "Finalised" ? "-" : fixture.homeGoals}</span>
                <span>{Object.keys(fixture.status)[0] != "Finalised" ? "-" : fixture.awayGoals}</span>
              </div>

              <div class="hidden xs:flex xs:w-2/12 md:w-2/12 lg:w-2/12 lg:justify-center">
                <span class="ml-4 xs:ml-0 text-left">{formatUnixTimeToTime(fixture.kickOff)}</span>
              </div>

              <div class="hidden md:flex md:w-2/12 lg:w-2/12">
                <FixtureStatus fixtureStatus={Object.keys(fixture.status)[0]} />

                <span class="ml-4 md:ml-0 text-left">
                  {#if Object.keys(fixture.status)[0] == "Unplayed"}Unplayed{/if}
                  {#if Object.keys(fixture.status)[0] == "Active"}Active{/if}
                  {#if Object.keys(fixture.status)[0] == "Complete"}Complete{/if}
                  {#if Object.keys(fixture.status)[0] == "Finalised"}Finalised{/if}
                </span>
              </div>
            </div>
          {/each}
      {/each}
      {#if Object.entries(groupedFixtures).length == 0}
        <p class="px-4 mb-4">Fixtures for the season have not been announced.</p>
      {/if}
    </div>
  </div>
{/if}