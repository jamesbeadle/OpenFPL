<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import {
    convertFixtureStatus,
    formatUnixDateToReadable,
    formatUnixDateToSmallReadable,
    formatUnixTimeToTime,
    getFixturesWithTeams,
  } from "../../utils/helpers";
  import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";
  import { storeManager } from "$lib/managers/store-manager";
  import FixtureTypeFilter from "../shared/filters/fixture-type-filter.svelte";
  import TeamFixturesTableHeader from "./team-fixtures-table-header.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import LocalSpinner from "../shared/local-spinner.svelte";
  
  interface Props {
    clubId: number;
  }
  let { clubId }: Props = $props();

  let filteredFixtures: FixtureWithClubs[] = $state([]);
  let fixturesWithTeams: FixtureWithClubs[] = [];
  let selectedFixtureType = $state(-1);

  let isLoading = $state(true);

  $effect(() => {
    filteredFixtures = fixturesWithTeams
    .filter(
      ({ fixture }) => {
        if(selectedFixtureType == -1 ) { return true; }
        if(selectedFixtureType == 0 && fixture.homeClubId === clubId) { return true; }
        if(selectedFixtureType == 1 && fixture.awayClubId === clubId) { return true; }
      } 
    ).sort((a, b) => a.fixture.gameweek - b.fixture.gameweek)
  });

  onMount(async () => {
      await storeManager.syncStores();
      fixturesWithTeams = getFixturesWithTeams($clubStore, $fixtureStore);
      isLoading = false;
  });
</script>

{#if isLoading}
  <LocalSpinner />
{:else}
  <div class="flex flex-col">
    <FixtureTypeFilter {selectedFixtureType} />
    <TeamFixturesTableHeader />

    {#each filteredFixtures as { fixture, homeClub, awayClub }}
      <div
        class={`flex items-center justify-between border-b border-gray-700 p-2 px-4  
        ${ convertFixtureStatus(fixture.status) === 0 ? "text-gray-400" : "text-white" }`}
      >
        <div class="w-1/6 md:ml-4">{fixture.gameweek}</div>
        <div class="w-1/3 flex">
            <a class="flex-row items-center" href={`/club?id=${fixture.homeClubId}`}>
              <BadgeIcon club={homeClub!} className="h-6 mr-2" />
              {homeClub ? homeClub.friendlyName : ""}
            </a>
            <a class="flex-row items-center" href={`/club?id=${fixture.awayClubId}`}>
              <BadgeIcon club={awayClub!} className="h-6 mr-2" />
              {awayClub ? awayClub.friendlyName : ""}
            </a>
        </div>
        <div class="hidden md:flex w-1/3">
          {formatUnixDateToReadable(fixture.kickOff)}
        </div>
        <div class="md:hidden w-1/3">
          {formatUnixDateToSmallReadable(fixture.kickOff)}
        </div>
        <div class="hidden md:flex w-1/4 text-center">
          {formatUnixTimeToTime(fixture.kickOff)}
        </div>
        <div class="w-1/3">
          <div class="flex flex-col">
            <a href={`/club?id=${fixture.homeClubId}`}>{homeClub ? homeClub.friendlyName : ""}</a>
            <a href={`/club?id=${fixture.awayClubId}`}>{awayClub ? awayClub.friendlyName : ""}</a>
          </div>
        </div>
        <div class="w-1/6 md:w-1/4 md:mr-4">
          <div class="flex flex-col">
            <span>{convertFixtureStatus(fixture.status) === 0 ? "-" : fixture.homeGoals}</span>
            <span>{convertFixtureStatus(fixture.status) === 0 ? "-" : fixture.awayGoals}</span>
          </div>
        </div>
      </div>
    {/each}
  </div>
{/if}