<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import {
    convertFixtureStatus,
    formatUnixDateToReadable,
    formatUnixDateToSmallReadable,
    formatUnixTimeToTime,
  } from "../utils/helpers";
  import type { ClubDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
    import { storeManager } from "$lib/managers/store-manager";

  export let clubId: number | null = null;

  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedFixtureType = -1;

  $: filteredFixtures =
    selectedFixtureType === -1
      ? fixturesWithTeams
          .filter(
            ({ fixture }) =>
              clubId === null ||
              fixture.homeClubId === clubId ||
              fixture.awayClubId === clubId
          )
          .sort((a, b) => a.fixture.gameweek - b.fixture.gameweek)
      : selectedFixtureType === 0
      ? fixturesWithTeams
          .filter(
            ({ fixture }) => clubId === null || fixture.homeClubId === clubId
          )
          .sort((a, b) => a.fixture.gameweek - b.fixture.gameweek)
      : fixturesWithTeams
          .filter(
            ({ fixture }) => clubId === null || fixture.awayClubId === clubId
          )
          .sort((a, b) => a.fixture.gameweek - b.fixture.gameweek);

  onMount(async () => {
    try {
      await storeManager.syncStores();

      fixturesWithTeams = $fixtureStore.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeClubId),
        awayTeam: getTeamFromId(fixture.awayClubId),
      }));
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching team fixtures." },
        err: error,
      });
      console.error("Error fetching team fixtures:", error);
    } finally {
    }
  });

  function getTeamFromId(teamId: number): ClubDTO | undefined {
    return $clubStore.find((team) => team.id === teamId);
  }
</script>

<div class="flex flex-col space-y-4">
  <div>
    <div class="flex p-4">
      <div class="flex items-center">
        <p>Type:</p>
        <select
          class="px-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
          bind:value={selectedFixtureType}
        >
          <option value={-1}>All</option>
          <option value={0}>Home</option>
          <option value={1}>Away</option>
        </select>
      </div>
    </div>
    <div
      class="flex justify-between p-2 border-b border-gray-700 py-4 bg-light-gray px-4"
    >
      <div class="hidden md:flex flex-grow w-1/6 md:ml-4">Gameweek</div>
      <div class="md:hidden flex-grow w-1/6 md:ml-4">GW</div>
      <div class="flex-grow w-1/3">Game</div>
      <div class="flex-grow w-1/3">Date</div>
      <div class="hidden md:flex flex-grow w-1/4 text-center">Time</div>
      <div class="flex-grow w-1/3">Teams</div>
      <div class="flex-grow w-1/6 md:w-1/4 md:mr-4">Result</div>
    </div>

    {#each filteredFixtures as { fixture, homeTeam, awayTeam }}
      <div
        class={`flex items-center justify-between border-b border-gray-700 p-2 px-4  
        ${
          convertFixtureStatus(fixture.status) === 0
            ? "text-gray-400"
            : "text-white"
        }`}
      >
        <div class="w-1/6 md:ml-4">{fixture.gameweek}</div>
        <div class="w-1/3 flex">
          <div class="w-5 md:w-10 items-center justify-center mr-1 md:mr-4">
            <a href={`/club?id=${fixture.homeClubId}`}>
              <BadgeIcon
                primaryColour={homeTeam ? homeTeam.primaryColourHex : ""}
                secondaryColour={homeTeam ? homeTeam.secondaryColourHex : ""}
                thirdColour={homeTeam ? homeTeam.thirdColourHex : ""}
              />
            </a>
          </div>
          <span>v</span>
          <div class="w-5 md:w-10 items-center justify-center ml-1 md:ml-4">
            <a href={`/club?id=${fixture.awayClubId}`}>
              <BadgeIcon
                primaryColour={awayTeam ? awayTeam.primaryColourHex : ""}
                secondaryColour={awayTeam ? awayTeam.secondaryColourHex : ""}
                thirdColour={awayTeam ? awayTeam.thirdColourHex : ""}
              />
            </a>
          </div>
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
            <a href={`/club?id=${fixture.homeClubId}`}
              >{homeTeam ? homeTeam.friendlyName : ""}</a
            >
            <a href={`/club?id=${fixture.awayClubId}`}
              >{awayTeam ? awayTeam.friendlyName : ""}</a
            >
          </div>
        </div>
        <div class="w-1/6 md:w-1/4 md:mr-4">
          <div class="flex flex-col">
            <span
              >{convertFixtureStatus(fixture.status) === 0
                ? "-"
                : fixture.homeGoals}</span
            >
            <span
              >{convertFixtureStatus(fixture.status) === 0
                ? "-"
                : fixture.awayGoals}</span
            >
          </div>
        </div>
      </div>
    {/each}
  </div>
</div>
