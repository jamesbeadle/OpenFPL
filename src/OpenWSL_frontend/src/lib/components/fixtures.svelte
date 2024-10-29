<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import {
    formatUnixTimeToTime,
  } from "../utils/helpers";
  import type { ClubDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
    import { storeManager } from "$lib/managers/store-manager";

  let gameweeks = Array.from({ length: Number(process.env.TOTAL_GAMEWEEKS) }, (_, i) => i + 1);
  let selectedGameweek: number;

  let fixturesWithTeams: FixtureWithTeams[] = [];

  $: filteredFixtures = fixturesWithTeams.filter(
    ({ fixture }) => fixture.gameweek === selectedGameweek
  );

  $: groupedFixtures = Object.entries(
  filteredFixtures.reduce(
    (acc: { [key: string]: FixtureWithTeams[] }, fixtureWithTeams) => {
      const date = new Date(Number(fixtureWithTeams.fixture.kickOff) / 1000000);
      const dateFormatter = new Intl.DateTimeFormat("en-GB", {
        weekday: "long",
        day: "numeric",
        month: "long",
        year: "numeric",
      });
      const dateKey = dateFormatter.format(date);

      if (!acc[dateKey]) {
        acc[dateKey] = [];
      }
      acc[dateKey].push(fixtureWithTeams);
      return acc;
    },
    {} as { [key: string]: FixtureWithTeams[] }
  )
).sort(([dateA], [dateB]) => {
  const parsedDateA = new Date(dateA);
  const parsedDateB = new Date(dateB);
  return parsedDateA.getTime() - parsedDateB.getTime();
}).reduce((acc, [date, fixtures]) => {
  acc[date] = fixtures;
  return acc;
}, {} as { [key: string]: FixtureWithTeams[] });



  

  onMount(async () => {
    try {
      await storeManager.syncStores();

      selectedGameweek = $systemStore?.calculationGameweek ?? 1;
      fixturesWithTeams = $fixtureStore.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeClubId),
        awayTeam: getTeamFromId(fixture.awayClubId),
      }));
      
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching fixtures data." },
        err: error,
      });
      console.error("Error fetching fixtures data:", error);
    }
  });

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): ClubDTO | undefined {
    return $clubStore.find((team) => team.id === teamId);
  }
</script>

<div class="flex flex-col space-y-4">
  <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
    <div class="flex items-center space-x-2 ml-3">
      <button
        class={`${
          selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
        } default-button`}
        on:click={() => changeGameweek(-1)}
        disabled={selectedGameweek === 1}
      >
        &lt;
      </button>

      <select
        class="p-2 fpl-dropdown my-4 min-w-[100px]"
        bind:value={selectedGameweek}
      >
        {#each gameweeks as gameweek}
          <option value={gameweek}>Gameweek {gameweek}</option>
        {/each}
      </select>

      <button
        class={`${
          selectedGameweek === Number(process.env.TOTAL_GAMEWEEKS) ? "bg-gray-500" : "fpl-button"
        } default-button ml-1`}
        on:click={() => changeGameweek(1)}
        disabled={selectedGameweek === Number(process.env.TOTAL_GAMEWEEKS)}
      >
        &gt;
      </button>
    </div>
  </div>
  <div>
    {#each Object.entries(groupedFixtures) as [date, fixtures]}
      <div>
        <div
          class="flex items-center justify-between border border-gray-700 py-4 bg-light-gray"
        >
          <h2 class="ml-4">{date}</h2>
        </div>
        {#each fixtures as { fixture, homeTeam, awayTeam }}
          <div
            class={`flex flex-row items-center py-2 border-b border-gray-700  ${
              Object.keys(fixture.status)[0] != "Finalised"
                ? "text-gray-400"
                : "text-white"
            }`}
          >
            <div
              class="flex w-5/12 xs:w-4/12 md:w-3/12 lg:w-3/12 space-x-2 sm:space-x-3 lg:space-x-4 justify-center items-center"
            >
              <div class="w-5 xs:w-6 md:w-8 items-center justify-center">
                <a href={`/club?id=${fixture.homeClubId}`}>
                  <BadgeIcon
                    primaryColour={homeTeam ? homeTeam.primaryColourHex : ""}
                    secondaryColour={homeTeam
                      ? homeTeam.secondaryColourHex
                      : ""}
                    thirdColour={homeTeam ? homeTeam.thirdColourHex : ""}
                  />
                </a>
              </div>
              <span>v</span>
              <div class="w-5 xs:w-6 md:w-8 items-center justify-center">
                <a href={`/club?id=${fixture.awayClubId}`}>
                  <BadgeIcon
                    primaryColour={awayTeam ? awayTeam.primaryColourHex : ""}
                    secondaryColour={awayTeam
                      ? awayTeam.secondaryColourHex
                      : ""}
                    thirdColour={awayTeam ? awayTeam.thirdColourHex : ""}
                  />
                </a>
              </div>
            </div>

            <div class="flex w-5/12 xs:w-4/12 md:w-3/12 lg:w-3/12 flex-col">
              <a href={`/club?id=${fixture.homeClubId}`}
                >{homeTeam ? homeTeam.friendlyName : ""}</a
              >
              <a href={`/club?id=${fixture.awayClubId}`}
                >{awayTeam ? awayTeam.friendlyName : ""}</a
              >
            </div>

            <div class="flex w-2/12 xs:w-2/12 md:w-2/12 lg:w-1/12 flex-col">
              <span
                >{Object.keys(fixture.status)[0] != "Finalised" 
                  ? "-"
                  : fixture.homeGoals}</span
              >
              <span
                >{Object.keys(fixture.status)[0] != "Finalised"
                  ? "-"
                  : fixture.awayGoals}</span
              >
            </div>

            <div
              class="hidden xs:flex xs:w-2/12 md:w-2/12 lg:w-3/12 lg:justify-center"
            >
              <span class="ml-4 xs:ml-0 text-left"
                >{formatUnixTimeToTime(fixture.kickOff)}</span
              >
            </div>

            <div class="hidden md:flex md:w-2/12 lg:w-2/12">
              {#if Object.keys(fixture.status)[0] == "Unplayed"}<div
                  class="w-[4px] bg-gray-400 mr-2 unplayed-divider"
                />{/if}
              {#if Object.keys(fixture.status)[0] == "Active"}<div
                  class="w-[4px] bg-gray-400 mr-2 active-divider"
                />{/if}
              {#if Object.keys(fixture.status)[0] == "Complete"}<div
                  class="w-[4px] bg-gray-400 mr-2 complete-divider"
                />{/if}
              {#if Object.keys(fixture.status)[0] == "Finalised"}<div
                  class="w-[4px] bg-gray-400 mr-2 finalised-divider"
                />{/if}

              <span class="ml-4 md:ml-0 text-left">

                {#if Object.keys(fixture.status)[0] == "Unplayed"}Unplayed{/if}
                {#if Object.keys(fixture.status)[0] == "Active"}Active{/if}
                {#if Object.keys(fixture.status)[0] == "Complete"}Complete{/if}
                {#if Object.keys(fixture.status)[0] == "Finalised"}Finalised{/if}
              </span>
            </div>
          </div>
        {/each}
      </div>
    {/each}
    {#if Object.entries(groupedFixtures).length == 0}
      <p class="px-4 mb-4">Fixtures for the season have not been announced.</p>
    {/if}
  </div>
</div>
