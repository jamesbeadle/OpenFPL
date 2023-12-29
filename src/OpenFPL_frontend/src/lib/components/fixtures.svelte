<script lang="ts">
  import { onMount } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";

  import { formatUnixTimeToTime, getFixtureStatusText } from "../utils/Helpers";
  import type { ClubDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";

  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let selectedGameweek: number;

  let fixturesWithTeams: FixtureWithTeams[] = [];

  $: filteredFixtures = fixturesWithTeams.filter(
    ({ fixture }) => fixture.gameweek === selectedGameweek
  );

  $: groupedFixtures = filteredFixtures.reduce(
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
  );

  onMount(async () => {
    try {
      await teamStore.sync();
      await fixtureStore.sync();
      await systemStore.sync();
      selectedGameweek = $systemStore?.calculationGameweek ?? 1;
      fixturesWithTeams = $fixtureStore.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeTeamId),
        awayTeam: getTeamFromId(fixture.awayTeamId),
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
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): ClubDTO | undefined {
    return $teamStore.find((team) => team.id === teamId);
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
        class="p-2 fpl-dropdown text-center mx-0 md:mx-2 min-w-[100px]"
        bind:value={selectedGameweek}
      >
        {#each gameweeks as gameweek}
          <option value={gameweek}>Gameweek {gameweek}</option>
        {/each}
      </select>

      <button
        class={`${
          selectedGameweek === 38 ? "bg-gray-500" : "fpl-button"
        } default-button ml-1`}
        on:click={() => changeGameweek(1)}
        disabled={selectedGameweek === 38}
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
              fixture.status < 3 ? "text-gray-400" : "text-white"
            }`}
          >
            <div
              class="flex w-5/12 xs:w-4/12 md:w-3/12 lg:w-3/12 space-x-2 sm:space-x-3 lg:space-x-4 justify-center items-center"
            >
              <div class="w-5 xs:w-6 md:w-8 items-center justify-center">
                <a href={`/club?id=${fixture.homeTeamId}`}>
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
                <a href={`/club?id=${fixture.awayTeamId}`}>
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
              <a href={`/club?id=${fixture.homeTeamId}`}
                >{homeTeam ? homeTeam.friendlyName : ""}</a
              >
              <a href={`/club?id=${fixture.awayTeamId}`}
                >{awayTeam ? awayTeam.friendlyName : ""}</a
              >
            </div>

            <div class="flex w-2/12 xs:w-2/12 md:w-2/12 lg:w-1/12 flex-col">
              <span>{fixture.status < 3 ? "-" : fixture.homeGoals}</span>
              <span>{fixture.status < 3 ? "-" : fixture.awayGoals}</span>
            </div>

            <div
              class="hidden xs:flex xs:w-2/12 md:w-2/12 lg:w-3/12 lg:justify-center"
            >
              <span class="ml-4 xs:ml-0 text-left"
                >{formatUnixTimeToTime(Number(fixture.kickOff))}</span
              >
            </div>

            <div class="hidden md:flex md:w-2/12 lg:w-2/12">
              {#if fixture.status == 0}<div
                  class="w-[4px] bg-gray-400 mr-2 unplayed-divider"
                />{/if}
              {#if fixture.status == 1}<div
                  class="w-[4px] bg-gray-400 mr-2 active-divider"
                />{/if}
              {#if fixture.status == 2}<div
                  class="w-[4px] bg-gray-400 mr-2 complete-divider"
                />{/if}
              {#if fixture.status == 3}<div
                  class="w-[4px] bg-gray-400 mr-2 verified-divider"
                />{/if}

              <span class="ml-4 md:ml-0 text-left">
                {getFixtureStatusText(fixture.status)}
              </span>
            </div>
          </div>
        {/each}
      </div>
    {/each}
  </div>
</div>
