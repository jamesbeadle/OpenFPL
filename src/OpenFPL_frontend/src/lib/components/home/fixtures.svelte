<script lang="ts">
    import { onMount } from "svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { leagueStore } from "$lib/stores/league-store";
    import { toasts } from "$lib/stores/toasts-store";
    import { formatUnixTimeToTime, reduceFilteredFixtures } from "$lib/utils/Helpers";
    import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";
    import LocalSpinner from "../shared/global/local-spinner.svelte";
    import FixtureStatus from "../shared/badges/fixture-status.svelte";
    import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    
    let isLoading = $state(true);
    let selectedSeasonId = $state(0);
    let selectedGameweek = $state(1);
    let filteredFixtures: FixtureWithClubs[] = [];
    let mergedFixtures: FixtureWithClubs[] = [];
    let groupedFixtures: { [key: string]: FixtureWithClubs[]; } = $state({ ['']: [] });
    
    onMount(async () => {
      try{
        await storeManager.syncStores();
        selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.completedGameweek : $leagueStore!.activeGameweek ?? 1;
        selectedSeasonId = $leagueStore?.activeSeasonId ?? 0;
      } catch {
        toasts.addToast({type: 'error', message: 'Error loading active season information'});
      } finally {
        isLoading = false;
      }
    });
  
    $effect(() => {
        filteredFixtures = mergedFixtures
        .filter(x => x.fixture.gameweek === selectedGameweek)
        .sort((a, b) => Number(a.fixture.kickOff) - Number(b.fixture.kickOff));
    });

    $effect(() => {
        groupedFixtures = reduceFilteredFixtures(filteredFixtures);
    });
  
  </script>
  {#if isLoading}
    <LocalSpinner />
    <p class="pb-4 mb-4 text-center">Loading Fixture Information for Gameweek {selectedGameweek}</p>
  {:else}
    <div class="flex flex-col">
      <div class="flex flex-col gap-4 sm:flex-row sm:gap-8">
        <GameweekFilter {selectedGameweek} />
      </div>
      <div>
        {#each Object.entries(groupedFixtures) as [date, fixtures]}
            <div class="flex items-center justify-between py-4 border border-gray-700 bg-light-gray">
              <h2 class="ml-4">{date}</h2>
            </div>
            {#each fixtures as fixture}
              <div
                class={`flex flex-row items-center py-4 border-b border-gray-700  
                  ${ Object.keys(fixture.fixture.status)[0] != "Finalised" ? "text-gray-400" : "text-white" }`}
              >
  
                <div class="flex flex-col w-7/12 space-y-4 xs:w-6/12 md:w-5/12 lg:w-5/12">
                  <a class="flex flex-row items-center" href={`/club?id=${fixture.fixture.homeClubId}`}>
                    <BadgeIcon club={fixture.homeClub!} className="h-6 mr-2 ml-4" />
                    {fixture.homeClub! ? fixture.homeClub!.friendlyName : ""}
                  </a>
                  <a class="flex flex-row items-center" href={`/club?id=${fixture.fixture.awayClubId}`}>
                    <BadgeIcon club={fixture.awayClub!} className="h-6 mr-2 ml-4" />
                    {fixture.awayClub! ? fixture.awayClub.friendlyName : ""}
                  </a>
                </div>
  
                <div class="flex flex-col items-center justify-center w-5/12 space-y-4 text-center xs:w-4/12 md:w-3/12 lg:w-3/12">
                  <span>{Object.keys(fixture.fixture.status)[0] != "Finalised" ? "-" : fixture.fixture.homeGoals}</span>
                  <span>{Object.keys(fixture.fixture.status)[0] != "Finalised" ? "-" : fixture.fixture.awayGoals}</span>
                </div>
  
                <div class="hidden xs:flex xs:w-2/12 md:w-2/12 lg:w-2/12 lg:justify-center">
                  <span class="ml-4 text-left xs:ml-0">{formatUnixTimeToTime(fixture.fixture.kickOff)}</span>
                </div>
  
                <div class="hidden md:flex md:w-2/12 lg:w-2/12">
                  <FixtureStatus fixtureStatus={Object.keys(fixture.fixture.status)[0]} />
                  <span class="ml-4 text-left md:ml-0">
                    {#if Object.keys(fixture.fixture.status)[0] == "Unplayed"}Unplayed{/if}
                    {#if Object.keys(fixture.fixture.status)[0] == "Active"}Active{/if}
                    {#if Object.keys(fixture.fixture.status)[0] == "Complete"}Complete{/if}
                    {#if Object.keys(fixture.fixture.status)[0] == "Finalised"}Finalised{/if}
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