<script lang="ts">
  import { onMount } from "svelte";
  import Layout from "../Layout.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { Fixture, Season, Team  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { SystemService } from "$lib/services/SystemService";
  import { FixtureService } from "$lib/services/FixtureService";
  import { TeamService } from "$lib/services/TeamService";
  import { page } from "$app/stores";
  import TeamPlayers from "$lib/components/team-players.svelte";
  import TeamFixtures from "$lib/components/team-fixtures.svelte";
  import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
  import { PlayerService } from "$lib/services/PlayerService";
  import type { PlayerDTO } from "../../../../declarations/player_canister/player_canister.did";
  import { getPositionText } from "../../lib/utils/Helpers";
  import type { FixtureWithTeams } from "$lib/types/FixtureWithTeams";
  import { updateTableData } from "../../lib/utils/Helpers";
  import { toastStore } from "$lib/stores/toast";

  let selectedGameweek: number = 1;
  let selectedSeason: Season;
  let fixtures: FixtureWithTeams[] = [];
  let teams: Team[] = [];
  let team: Team | null = null;
  let players: PlayerDTO[] = [];
  let nextFixture: Fixture | null = null;
  let nextFixtureHomeTeam: Team | null = null;
  let nextFixtureAwayTeam: Team | null = null;
  let highestScoringPlayer: PlayerDTO | null = null;

  let progress = 0;
  let isLoading = true;
  let activeTab: string = "players";

  $: id = Number($page.url.searchParams.get("id"));

  onMount(async () => {
    try {

      const fixtureService = new FixtureService();
      const teamService = new TeamService();
      const systemService = new SystemService();
      const playersService = new PlayerService();

      await systemService.updateSystemStateData();
      await fixtureService.updateFixturesData();
      await teamService.updateTeamsData();
      await playersService.updatePlayersData();
      await playersService.updatePlayerEventsData();

      const fetchedFixtures = await fixtureService.getFixtures();
      const fetchedTeams = await teamService.getTeams();
      const fetchedPlayers = await playersService.getPlayers();

      teams = fetchedTeams;
      team = fetchedTeams.find((x) => x.id == id) ?? null;

      let teamFixtures = fetchedFixtures.filter(
        (x) => x.homeTeamId == id || x.awayTeamId == id
      );

      fixtures = teamFixtures.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeTeamId),
        awayTeam: getTeamFromId(fixture.awayTeamId),
      }));
      players = fetchedPlayers.filter((player) => player.teamId == id);
      highestScoringPlayer = players
        .sort((a, b) => a.totalPoints - b.totalPoints)
        .sort((a, b) => Number(b.value) - Number(a.value))[0];
      let systemState = await systemService.getSystemState();
      selectedGameweek = systemState?.activeGameweek ?? selectedGameweek;
      selectedSeason = systemState?.activeSeason ?? selectedSeason;
      nextFixture =
        teamFixtures.find((x) => x.gameweek == selectedGameweek) ?? null;
      nextFixtureHomeTeam = getTeamFromId(nextFixture?.homeTeamId ?? 0) ?? null;
      nextFixtureAwayTeam = getTeamFromId(nextFixture?.awayTeamId ?? 0) ?? null;

      isLoading = false;
    } catch (error) {
      toastStore.show("Error fetching club details.", "error");
      console.error("Error fetching club details:", error);
    }
  });

  let tableData: any[] = [];
  $: if (fixtures.length > 0 && teams.length > 0) {
    tableData = updateTableData(fixtures, teams, selectedGameweek);
  }

  function getTeamFromId(teamId: number): Team | undefined {
    return teams.find((team) => team.id === teamId);
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
    <LoadingIcon {progress} />
  {:else}
    <div class="m-4">
      <div class="flex flex-col md:flex-row">
        <div
          class="flex justify-start items-center text-white space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex-grow flex flex-col items-center">
            <p class="text-gray-300 text-xs">{team?.friendlyName}</p>
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
            <p class="text-gray-300 text-xs">{team?.abbreviatedName}</p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">Players</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {players.length}
            </p>
            <p class="text-gray-300 text-xs">Total</p>
          </div>
          <div
            class="flex-shrink-0 w-px bg-gray-400 self-stretch"
            style="min-width: 2px; min-height: 50px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs">League Position</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {getTeamPosition(id)}
            </p>
            <p class="text-gray-300 text-xs">{selectedSeason.name}</p>
          </div>
        </div>
        <div
          class="flex flex-col md:flex-row justify-start md:items-center text-white space-x-0 md:space-x-4 flex-grow m-4 bg-panel p-4 rounded-md"
        >
          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xs">League Points</p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              {getTeamPoints(id)}
            </p>
            <p class="text-gray-300 text-xs">Total</p>
          </div>
          <div
            class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />

          <div class="flex-grow mb-4 md:mb-0">
            <p class="text-gray-300 text-xs">Next Game:</p>
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
                <p class="text-gray-300 text-xs text-center">
                  <a
                    class="text-gray-300 text-xs text-center"
                    href={`/club?id=${nextFixtureHomeTeam?.id}`}
                    >{nextFixtureHomeTeam?.abbreviatedName}</a
                  >
                </p>
              </div>
              <div class="w-v ml-2 mr-2" />
              <div class="w-10 ml-4">
                <p class="text-gray-300 text-xs text-center">
                  <a
                    class="text-gray-300 text-xs text-center"
                    href={`/club?id=${nextFixtureAwayTeam?.id}`}
                    >{nextFixtureAwayTeam?.abbreviatedName}</a
                  >
                </p>
              </div>
            </div>
          </div>
          <div
            class="h-px bg-gray-400 w-full md:w-px md:h-full md:self-stretch"
            style="min-height: 2px; min-width: 2px;"
          />
          <div class="flex-grow">
            <p class="text-gray-300 text-xs mt-4 md:mt-0">
              Highest Scoring Player
            </p>
            <p class="text-2xl sm:text-3xl md:text-4xl mt-2 mb-2 font-bold">
              <a href={`/player?id=${highestScoringPlayer?.id}`}
                >{highestScoringPlayer?.lastName}</a
              >
            </p>
            <p class="text-gray-300 text-xs">
              {getPositionText(highestScoringPlayer?.position ?? 0)}
              ({highestScoringPlayer?.totalPoints})
            </p>
          </div>
        </div>
      </div>
    </div>

    <div class="m-4">
      <div class="bg-panel rounded-md m-4">
        <ul class="flex bg-light-gray px-4 pt-2">
          <li
            class={`mr-4 text-xs md:text-lg ${
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
            class={`mr-4 text-xs md:text-lg ${
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
          <TeamPlayers {players} />
        {:else if activeTab === "fixtures"}
          <TeamFixtures clubId={id} />
        {/if}
      </div>
    </div>
  {/if}
</Layout>
