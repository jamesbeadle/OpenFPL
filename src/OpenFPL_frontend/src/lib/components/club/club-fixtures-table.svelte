<script lang="ts">
    import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";

    import {
      convertFixtureStatus,
      formatUnixDateToReadable,
      formatUnixDateToSmallReadable,
      formatUnixTimeToTime
    } from "$lib/utils/Helpers";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";

    interface Props {
        filteredFixtures: FixtureWithClubs[];
    }
    let { filteredFixtures } : Props = $props();

</script>

<div class="flex justify-between p-2 border-b border-gray-700 py-4 bg-light-gray px-4">
    <div class="hidden md:flex flex-grow w-1/6 md:ml-4">Gameweek</div>
    <div class="md:hidden flex-grow w-1/6 md:ml-4">GW</div>
    <div class="flex-grow w-1/3">Game</div>
    <div class="flex-grow w-1/3">Date</div>
    <div class="hidden md:flex flex-grow w-1/4 text-center">Time</div>
    <div class="flex-grow w-1/3">Teams</div>
    <div class="flex-grow w-1/6 md:w-1/4 md:mr-4">Result</div>
</div>

{#each filteredFixtures as { fixture, homeClub, awayClub }}
    <div class={`flex items-center justify-between border-b border-gray-700 p-2 px-4  
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