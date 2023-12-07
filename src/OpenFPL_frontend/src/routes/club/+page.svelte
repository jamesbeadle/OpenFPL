<script lang="ts">
  import { onMount } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { playerStore } from "$lib/stores/player-store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import Layout from "../Layout.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { page } from "$app/stores";
  import TeamPlayers from "$lib/components/team-players.svelte";
  import TeamFixtures from "$lib/components/team-fixtures.svelte";
  import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import type {
    Fixture,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { updateTableData, getPositionText } from "../../lib/utils/Helpers";
  import { Spinner } from "@dfinity/gix-components";

  let isLoading = true;
  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedGameweek: number;
  let team: Team | null = null;
  let nextFixture: Fixture | null = null;
  let nextFixtureHomeTeam: Team | null = null;
  let nextFixtureAwayTeam: Team | null = null;
  let highestScoringPlayer: PlayerDTO | null = null;

  let activeTab: string = "players";

  $: id = Number($page.url.searchParams.get("id"));

  onMount(async () => {
    try {
      await teamStore.sync();
      await fixtureStore.sync();
      await systemStore.sync();
      await playerStore.sync();
      selectedGameweek = $systemStore?.activeGameweek ?? 1;

      let teamFixtures = $fixtureStore.filter(
        (x) => x.homeTeamId === id || x.awayTeamId === id
      );

      fixturesWithTeams = teamFixtures.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeTeamId),
        awayTeam: getTeamFromId(fixture.awayTeamId),
      }));

      highestScoringPlayer = $playerStore
        .sort((a, b) => a.totalPoints - b.totalPoints)
        .sort((a, b) => Number(b.value) - Number(a.value))[0];

      nextFixture =
        teamFixtures.find((x) => x.gameweek === selectedGameweek) ?? null;
      nextFixtureHomeTeam = getTeamFromId(nextFixture?.homeTeamId ?? 0) ?? null;
      nextFixtureAwayTeam = getTeamFromId(nextFixture?.awayTeamId ?? 0) ?? null;
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching club details." },
        err: error,
      });
      console.error("Error fetching club details:", error);
    } finally {
      isLoading = false;
    }
  });

  let tableData: any[] = [];
  $: if (fixturesWithTeams.length > 0 && $teamStore.length > 0) {
    tableData = updateTableData(
      fixturesWithTeams,
      $teamStore,
      selectedGameweek
    );
  }

  function getTeamFromId(teamId: number): Team | undefined {
    return $teamStore.find((team) => team.id === teamId);
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  const getTeamPosition = (teamId: number) => {
    const position = tableData.findIndex((team) => team.id === teamId);
    return position !== -1 ? position + 1 : "Not found";
  };

  const getTeamPoints = (teamId: number) => {
    const points = tableData.find((team) => team.id === teamId).points;
    return points;
  };
</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <div class="m-4">
      <div class="flex flex-col md:flex-row">
        <div
          class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex-grow flex flex-col items-center">
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              {team?.friendlyName}
            </p>
            <div class="py-2 flex space-x-4">
              <BadgeIcon
                className="h-10"
                primaryColour={team?.primaryColourHex}
                secondaryColour={team?.secondaryColourHex}
                thirdColour={team?.thirdColourHex}
              />
              <ShirtIcon
                className="h-10"
                primaryColour={team?.primaryColourHex}
                secondaryColour={team?.secondaryColourHex}
                thirdColour={team?.thirdColourHex}
              />
            </div>
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              {team?.abbreviatedName}
            </p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              Players
            </p>
            <p
              class="text-xs xs:text-sm sm:text-2xl md:text-3xl lg:text-4xl mt-2 mb-2 font-bold"
            >
              {$playerStore.filter((x) => x.teamId == id).length}
            </p>
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">Total</p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              League Position
            </p>
            <p
              class="text-xs xs:text-sm sm:text-2xl md:text-3xl lg:text-4xl mt-2 mb-2 font-bold"
            >
              {getTeamPosition(id)}
            </p>
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              {$systemStore?.activeSeason.name}
            </p>
          </div>
        </div>
        <div
          class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              League Points
            </p>
            <p
              class="text-xs xs:text-sm sm:text-2xl md:text-3xl lg:text-4xl mt-2 mb-2 font-bold"
            >
              {getTeamPoints(id)}
            </p>
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">Total</p>
          </div>
          <div
            class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />

          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              Next Game:
            </p>
            <div class="flex justify-center mb-2 mt-2">
              <div class="flex justify-center items-center">
                <div class="w-10 ml-4 mr-4">
                  <a href={`/club?id=${nextFixtureHomeTeam?.id}`}>
                    <BadgeIcon
                      primaryColour={nextFixtureHomeTeam?.primaryColourHex}
                      secondaryColour={nextFixtureHomeTeam?.secondaryColourHex}
                      thirdColour={nextFixtureHomeTeam?.thirdColourHex}
                    />
                  </a>
                </div>
                <div class="w-v ml-1 mr-1 flex justify-center">
                  <p class="text-xs mt-2 mb-2 font-bold">v</p>
                </div>
                <div class="w-10 ml-4">
                  <a href={`/club?id=${nextFixtureAwayTeam?.id}`}>
                    <BadgeIcon
                      primaryColour={nextFixtureAwayTeam?.primaryColourHex}
                      secondaryColour={nextFixtureAwayTeam?.secondaryColourHex}
                      thirdColour={nextFixtureAwayTeam?.thirdColourHex}
                    />
                  </a>
                </div>
              </div>
            </div>
            <div class="flex justify-center">
              <div class="w-10 ml-4 mr-4">
                <p
                  class="text-gray-300 text-xxs xs:text-sm sm:text-base text-center"
                >
                  <a href={`/club?id=${nextFixtureHomeTeam?.id}`}>
                    {nextFixtureHomeTeam?.abbreviatedName}
                  </a>
                </p>
              </div>
              <div class="w-v ml-2 mr-2" />
              <div class="w-10 ml-4">
                <p
                  class="text-gray-300 text-xxs xs:text-sm sm:text-base text-center"
                >
                  <a href={`/club?id=${nextFixtureAwayTeam?.id}`}>
                    {nextFixtureAwayTeam?.abbreviatedName}
                  </a>
                </p>
              </div>
            </div>
          </div>
          <div
            class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />
          <div class="flex-grow">
            <p
              class="text-gray-300 text-xxs xs:text-sm sm:text-base mt-4 md:mt-0"
            >
              Highest Scoring Player
            </p>
            <p
              class="text-xs xs:text-sm sm:text-2xl md:text-3xl lg:text-4xl mt-2 mb-2 font-bold"
            >
              <a href={`/player?id=${highestScoringPlayer?.id}`}
                >{highestScoringPlayer?.lastName}</a
              >
            </p>
            <p class="text-gray-300 text-xxs xs:text-sm sm:text-base">
              {getPositionText(highestScoringPlayer?.position ?? 0)}
              ({highestScoringPlayer?.totalPoints})
            </p>
          </div>
        </div>
      </div>
    </div>

    <div class="m-4">
      <div class="bg-panel rounded-md m-4">
        <ul class="flex bg-light-gray border-b border-gray-700 px-4 pt-2">
          <li
            class={`mr-4 text-xs md:text-base ${
              activeTab === "players" ? "active-tab" : ""
            }`}
          >
            <button
              class={`p-2 ${
                activeTab === "players" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("players")}
            >
              Players
            </button>
          </li>
          <li
            class={`mr-4 text-xs md:text-base ${
              activeTab === "fixtures" ? "active-tab" : ""
            }`}
          >
            <button
              class={`p-2 ${
                activeTab === "fixtures" ? "text-white" : "text-gray-400"
              }`}
              on:click={() => setActiveTab("fixtures")}
            >
              Fixtures
            </button>
          </li>
        </ul>

        {#if activeTab === "players"}
          <TeamPlayers players={$playerStore.filter((x) => x.teamId == id)} />
        {:else if activeTab === "fixtures"}
          <TeamFixtures clubId={id} />
        {/if}
      </div>
    </div>
  {/if}
</Layout>
