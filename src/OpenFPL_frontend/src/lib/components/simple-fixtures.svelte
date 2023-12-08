<script lang="ts">
  import { onMount } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { systemStore } from "$lib/stores/system-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import { formatUnixTimeToTime } from "../utils/Helpers";

  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedGameweek: number;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);

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
    await teamStore.sync();
    await fixtureStore.sync();
    await systemStore.sync();
    selectedGameweek = $systemStore?.activeGameweek ?? 1;
    fixturesWithTeams = $fixtureStore.map((fixture) => ({
      fixture,
      homeTeam: getTeamFromId(fixture.homeTeamId),
      awayTeam: getTeamFromId(fixture.awayTeamId),
    }));
  });

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): Team | undefined {
    return $teamStore.find((team) => team.id === teamId);
  }
</script>

<div class="bg-panel rounded-md mt-4 flex-1">
  <div class="container-fluid">
    <div class="flex items-center justify-between py-2 bg-light-gray">
      <h1 class="mx-4 m-2 font-bold panel-header">Fixtures</h1>
    </div>
    <div class="flex items-center space-x-2 m-3 mx-4">
      <button
        class={`${
          selectedGameweek === 1 ? "bg-gray-500" : "fpl-button"
        } text-xs xs:text-sm sm:text-base rounded px-3 md:px-4 py-1`}
        on:click={() => changeGameweek(-1)}
        disabled={selectedGameweek === 1}
      >
        &lt;
      </button>

      <select
        class="p-2 fpl-dropdown text-xs sm:text-sm md:text-base text-center mx-0 md:mx-2 min-w-[100px]"
        bind:value={selectedGameweek}
      >
        {#each gameweeks as gameweek}
          <option value={gameweek}>Gameweek {gameweek}</option>
        {/each}
      </select>

      <button
        class={`${
          selectedGameweek === 38 ? "bg-gray-500" : "fpl-button"
        } text-xs xs:text-sm sm:text-base rounded px-3 md:px-4 py-1 ml-1`}
        on:click={() => changeGameweek(1)}
        disabled={selectedGameweek === 38}
      >
        &gt;
      </button>
    </div>
    <div>
      {#each Object.entries(groupedFixtures) as [date, fixtures]}
        <div>
          <div
            class="flex items-center justify-between border-b border-gray-700 py-2 bg-light-gray"
          >
            <h2 class="date-header ml-4 text-xs">{date}</h2>
          </div>
          {#each fixtures as { fixture, homeTeam, awayTeam }}
            <div
              class={`flex items-center justify-between py-2 border-b border-gray-700  
              ${fixture.status < 3 ? "text-gray-400" : "text-white"}`}
            >
              <div class="flex items-center space-x-10 w-1/2 md:justify-center mx-2">
                <div class="flex flex-col min-w-[120px] md:min-w-[200px] text-xs 3xl:text-base">
                  <a class="my-1 flex items-center" href={`/club?id=${fixture.homeTeamId}`}>
                    <BadgeIcon
                        className="w-4 mr-1"
                        primaryColour={homeTeam ? homeTeam.primaryColourHex : ""}
                        secondaryColour={homeTeam ? homeTeam.secondaryColourHex : ""}
                        thirdColour={homeTeam ? homeTeam.thirdColourHex : ""}
                      />
                    {homeTeam ? homeTeam.friendlyName : ""}
                  </a>
                  <a class="my-1 flex items-center" href={`/club?id=${fixture.awayTeamId}`}>
                    <BadgeIcon
                    className="w-4 mr-1"
                    primaryColour={awayTeam ? awayTeam.primaryColourHex : ""}
                    secondaryColour={awayTeam ? awayTeam.secondaryColourHex: ""}
                    thirdColour={awayTeam ? awayTeam.thirdColourHex : ""}
                    />
                    {awayTeam ? awayTeam.friendlyName : ""}
                  </a>
                </div>
                <div class="flex flex-col items-center text-xs">
                  <span>{fixture.status < 3 ? "-" : fixture.homeGoals}</span>
                  <span>{fixture.status < 3 ? "-" : fixture.awayGoals}</span>
                </div>
              </div>
            </div>
          {/each}
        </div>
      {/each}
    </div>
  </div>
</div>
