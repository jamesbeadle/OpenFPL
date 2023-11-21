<script lang="ts">
  import { onMount } from "svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { SystemService } from "$lib/services/SystemService";
  import { FixtureService } from "$lib/services/FixtureService";
  import { TeamService } from "$lib/services/TeamService";
  import { formatUnixTimeToTime } from "../../utils/Helpers";
  import type { FixtureWithTeams } from "$lib/types/FixtureWithTeams";
  const fixtureService = new FixtureService();
  const teamService = new TeamService();
  const systemService = new SystemService();

  let selectedGameweek: number = 1;
  let fixtures: FixtureWithTeams[] = [];
  let teams: Team[] = [];
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  $: filteredFixtures = fixtures.filter(
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
      const fetchedFixtures = await fixtureService.getFixtures();
      const fetchedTeams = await teamService.getTeams();

      teams = fetchedTeams;
      fixtures = fetchedFixtures.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeTeamId),
        awayTeam: getTeamFromId(fixture.awayTeamId),
      }));
      let systemState = await systemService.getSystemState();
      selectedGameweek = systemState?.activeGameweek ?? selectedGameweek;
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  });

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): Team | undefined {
    return teams.find((team) => team.id === teamId);
  }
</script>

<div class="bg-panel rounded-md m-4 flex-1">
  <div class="container-fluid">
    <div class="flex items-center justify-between py-2 bg-light-gray">
      <h1 class="mx-4 m-2 font-bold">Fixtures</h1>
    </div>
    <div class="flex items-center space-x-2 m-3 mx-4">
      <button
        class="rounded fpl-button px-2 py-1"
        on:click={() => changeGameweek(-1)}
        disabled={selectedGameweek === 1}
      >
        &lt;
      </button>

      <select
        class="p-2 fpl-dropdown text-center"
        bind:value={selectedGameweek}
      >
        {#each gameweeks as gameweek}
          <option value={gameweek}>Gameweek {gameweek}</option>
        {/each}
      </select>

      <button
        class="rounded fpl-button px-2 py-1"
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
            class="flex items-center justify-between border border-gray-700 py-2 bg-light-gray"
          >
            <h2 class="date-header ml-4 text-xs">{date}</h2>
          </div>
          {#each fixtures as { fixture, homeTeam, awayTeam }}
            <div
              class={`flex items-center justify-between py-2 border-b border-gray-700  ${
                fixture.status === 0 ? "text-gray-400" : "text-white"
              }`}
            >
              <div class="flex items-center w-1/2 ml-4">
                <div class="flex w-1/2 space-x-4 justify-center">
                  <div class="w-8 items-center justify-center">
                    <a href={`/club/${fixture.homeTeamId}`}>
                      <BadgeIcon
                        primaryColour={homeTeam
                          ? homeTeam.primaryColourHex
                          : ""}
                        secondaryColour={homeTeam
                          ? homeTeam.secondaryColourHex
                          : ""}
                        thirdColour={homeTeam ? homeTeam.thirdColourHex : ""}
                      />
                    </a>
                  </div>
                  <span class="font-bold text-lg">v</span>
                  <div class="w-8 items-center justify-center">
                    <a href={`/club/${fixture.awayTeamId}`}>
                      <BadgeIcon
                        primaryColour={awayTeam
                          ? awayTeam.primaryColourHex
                          : ""}
                        secondaryColour={awayTeam
                          ? awayTeam.secondaryColourHex
                          : ""}
                        thirdColour={awayTeam ? awayTeam.thirdColourHex : ""}
                      />
                    </a>
                  </div>
                </div>
                <div class="flex w-1/2 md:justify-center">
                  <span class="text-sm ml-4 md:ml-0 text-left"
                    >{formatUnixTimeToTime(Number(fixture.kickOff))}</span
                  >
                </div>
              </div>
              <div class="flex items-center space-x-10 w-1/2 md:justify-center">
                <div
                  class="flex flex-col min-w-[120px] md:min-w-[200px] text-xs 3xl:text-base"
                >
                  <a class="my-1" href={`/club/${fixture.homeTeamId}`}
                    >{homeTeam ? homeTeam.friendlyName : ""}</a
                  >
                  <a class="my-1" href={`/club/${fixture.awayTeamId}`}
                    >{awayTeam ? awayTeam.friendlyName : ""}</a
                  >
                </div>
                <div class="flex flex-col items-center text-xs">
                  <span>{fixture.status === 0 ? "-" : fixture.homeGoals}</span>
                  <span>{fixture.status === 0 ? "-" : fixture.awayGoals}</span>
                </div>
              </div>
            </div>
          {/each}
        </div>
      {/each}
    </div>
  </div>
</div>
