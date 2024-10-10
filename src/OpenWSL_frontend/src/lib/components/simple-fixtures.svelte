<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { systemStore } from "$lib/stores/system-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { ClubDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import { convertFixtureStatus, formatUnixTimeToTime } from "../utils/helpers";
    import { storeManager } from "$lib/managers/store-manager";

  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedGameweek: number;
  let gameweeks = Array.from({ length: Number(process.env.TOTAL_GAMEWEEKS) }, (_, i) => i + 1);

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
    await storeManager.syncStores();
    selectedGameweek = $systemStore?.calculationGameweek ?? 1;
    fixturesWithTeams = $fixtureStore.map((fixture) => ({
      fixture,
      homeTeam: getTeamFromId(fixture.homeClubId),
      awayTeam: getTeamFromId(fixture.awayClubId),
    }));
  });

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): ClubDTO | undefined {
    return $clubStore.find((team) => team.id === teamId);
  }
</script>

<div class="bg-panel rounded-md">
  <div>
    <div class="flex items-center justify-between py-2 bg-light-gray">
      <h1 class="mx-4 m-2 side-panel-header">Fixtures</h1>
    </div>
    <div class="flex items-center space-x-2 m-3 mx-4">
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
          selectedGameweek === Number(process.env.TOTAL_GAMEWEEKS) ? "bg-gray-500" : "fpl-button"
        } default-button ml-1`}
        on:click={() => changeGameweek(1)}
        disabled={selectedGameweek === Number(process.env.TOTAL_GAMEWEEKS)}
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
            <h2 class="ml-4">{date}</h2>
          </div>
          {#each fixtures as { fixture, homeTeam, awayTeam }}
            <div
              class={`flex items-center justify-between py-2 border-b border-gray-700
              ${
                convertFixtureStatus(fixture.status) < 3
                  ? "text-gray-400"
                  : "text-white"
              }`}
            >
              <div class="flex w-full items-center space-x-10 mx-4 xs:mx-8">
                <div class="flex flex-col w-3/6 min-w-[100px] md:min-w-[200px]">
                  <a
                    class="my-1 flex items-center"
                    href={`/club?id=${fixture.homeClubId}`}
                  >
                    <BadgeIcon
                      className="w-4 mr-1"
                      primaryColour={homeTeam ? homeTeam.primaryColourHex : ""}
                      secondaryColour={homeTeam
                        ? homeTeam.secondaryColourHex
                        : ""}
                      thirdColour={homeTeam ? homeTeam.thirdColourHex : ""}
                    />
                    {homeTeam ? homeTeam.friendlyName : ""}
                  </a>
                  <a
                    class="my-1 flex items-center"
                    href={`/club?id=${fixture.awayClubId}`}
                  >
                    <BadgeIcon
                      className="w-4 mr-1"
                      primaryColour={awayTeam ? awayTeam.primaryColourHex : ""}
                      secondaryColour={awayTeam
                        ? awayTeam.secondaryColourHex
                        : ""}
                      thirdColour={awayTeam ? awayTeam.thirdColourHex : ""}
                    />
                    {awayTeam ? awayTeam.friendlyName : ""}
                  </a>
                </div>
                <div class="flex flex-col w-1/6 items-center justify-center">
                  <span
                    >{convertFixtureStatus(fixture.status) < 3
                      ? "-"
                      : fixture.homeGoals}</span
                  >
                  <span
                    >{convertFixtureStatus(fixture.status) < 3
                      ? "-"
                      : fixture.awayGoals}</span
                  >
                </div>
                <div class="flex flex-col w-2/6">
                  <span class="md:ml-0"
                    >{formatUnixTimeToTime(fixture.kickOff)}</span
                  >
                </div>
              </div>
            </div>
          {/each}
        </div>
      {/each}
    </div>
  </div>
</div>
