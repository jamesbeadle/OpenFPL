<script lang="ts">
  import { onMount } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import {
    formatUnixDateToReadable,
    formatUnixTimeToTime,
  } from "../utils/Helpers";
  import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";

  export let clubId: number | null = null;

  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedFixtureType = -1;

  $: filteredFixtures =
    selectedFixtureType === -1
      ? fixturesWithTeams.filter(
          ({ fixture }) =>
            clubId === null ||
            fixture.homeTeamId === clubId ||
            fixture.awayTeamId === clubId
        ).sort((a,b) => a.fixture.gameweek - b.fixture.gameweek)
      : selectedFixtureType === 0
      ? fixturesWithTeams.filter(
          ({ fixture }) => clubId === null || fixture.homeTeamId === clubId
        ).sort((a,b) => a.fixture.gameweek - b.fixture.gameweek)
      : fixturesWithTeams.filter(
          ({ fixture }) => clubId === null || fixture.awayTeamId === clubId
        ).sort((a,b) => a.fixture.gameweek - b.fixture.gameweek);

  onMount(async () => {
    try {
      await teamStore.sync();
      await fixtureStore.sync();

      fixturesWithTeams = $fixtureStore.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeTeamId),
        awayTeam: getTeamFromId(fixture.awayTeamId),
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

  function getTeamFromId(teamId: number): Team | undefined {
    return $teamStore.find((team) => team.id === teamId);
  }
</script>

<div class="container-fluid">
  <div class="flex flex-col space-y-4">
    <div>
      <div class="flex p-4">
        <div class="flex items-center ml-4">
          <p class="text-sm md:text-xl mr-4">Type:</p>
          <select
            class="p-2 fpl-dropdown text-xs sm:text-sm md:text-base text-center mx-0 md:mx-2 min-w-[100px]"
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
        <div class="flex-grow w-1/6 ml-4">Gameweek</div>
        <div class="flex-grow w-1/3 text-center">Game</div>
        <div class="flex-grow w-1/3">Date</div>
        <div class="flex-grow w-1/4 text-center">Time</div>
        <div class="flex-grow w-1/3">Teams</div>
        <div class="flex-grow w-1/4 mr-4">Result</div>
      </div>

      {#each filteredFixtures as { fixture, homeTeam, awayTeam }}
        <div
          class={`flex items-center justify-between border-b border-gray-700 p-2 px-4  
          ${fixture.status === 0 ? "text-gray-400" : "text-white"}`}
        >
          <div class="w-1/6 ml-4">{fixture.gameweek}</div>
          <div class="w-1/3 flex justify-center">
            <div class="w-10 items-center justify-center mr-4">
              <a href={`/club?id=${fixture.homeTeamId}`}>
                <BadgeIcon
                  primaryColour={homeTeam ? homeTeam.primaryColourHex : ""}
                  secondaryColour={homeTeam ? homeTeam.secondaryColourHex : ""}
                  thirdColour={homeTeam ? homeTeam.thirdColourHex : ""}
                />
              </a>
            </div>
            <span class="font-bold text-lg">v</span>
            <div class="w-10 items-center justify-center ml-4">
              <a href={`/club?id=${fixture.awayTeamId}`}>
                <BadgeIcon
                  primaryColour={awayTeam ? awayTeam.primaryColourHex : ""}
                  secondaryColour={awayTeam ? awayTeam.secondaryColourHex : ""}
                  thirdColour={awayTeam ? awayTeam.thirdColourHex : ""}
                />
              </a>
            </div>
          </div>
          <div class="w-1/3">
            {formatUnixDateToReadable(Number(fixture.kickOff))}
          </div>
          <div class="w-1/4 text-center">
            {formatUnixTimeToTime(Number(fixture.kickOff))}
          </div>
          <div class="w-1/3">
            <div class="flex flex-col text-xs md:text-base">
              <a href={`/club?id=${fixture.homeTeamId}`}
                >{homeTeam ? homeTeam.friendlyName : ""}</a
              >
              <a href={`/club?id=${fixture.awayTeamId}`}
                >{awayTeam ? awayTeam.friendlyName : ""}</a
              >
            </div>
          </div>
          <div class="w-1/4 mr-4">
            <div class="flex flex-col text-xs md:text-base">
              <span>{fixture.status === 0 ? "-" : fixture.homeGoals}</span>
              <span>{fixture.status === 0 ? "-" : fixture.awayGoals}</span>
            </div>
          </div>
        </div>
      {/each}
    </div>
  </div>
</div>
