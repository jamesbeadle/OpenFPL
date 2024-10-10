<script lang="ts">
  import { onMount } from "svelte";
  import { clubStore } from "$lib/stores/club-store";
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
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import type {
    FixtureDTO,
    ClubDTO,
    PlayerDTO,
  } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import {
    updateTableData,
    getPositionText,
    convertPlayerPosition,
  } from "../../lib/utils/helpers";
  import { Spinner } from "@dfinity/gix-components";
    import LoanedPlayers from "$lib/components/club/loaned-players.svelte";
    import { seasonStore } from "$lib/stores/season-store";
    import { storeManager } from "$lib/managers/store-manager";

  let isLoading = true;
  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedGameweek: number;
  let team: ClubDTO | null = null;
  let nextFixture: FixtureDTO | null = null;
  let nextFixtureHomeTeam: ClubDTO | null = null;
  let nextFixtureAwayTeam: ClubDTO | null = null;
  let highestScoringPlayer: PlayerDTO | null = null;

  let activeTab: string = "players";

  let seasonName = "";

  $: id = Number($page.url.searchParams.get("id"));

  onMount(async () => {
    try {
      await storeManager.syncStores();

      seasonName = $seasonStore.find(x => x.id == $systemStore?.pickTeamSeasonId)?.name ?? "";
      selectedGameweek = $systemStore?.pickTeamGameweek ?? 1;

      let teamFixtures = $fixtureStore.filter(
        (x) => x.homeClubId === id || x.awayClubId === id
      );

      fixturesWithTeams = teamFixtures
        .sort((a, b) => Number(a.kickOff) - Number(b.kickOff))
        .map((fixture) => ({
          fixture,
          homeTeam: getTeamFromId(fixture.homeClubId),
          awayTeam: getTeamFromId(fixture.awayClubId),
        }));

      team = $clubStore.find((x) => x.id == id) ?? null;

      highestScoringPlayer = $playerStore
        .sort((a, b) => a.totalPoints - b.totalPoints)
        .sort(
          (a, b) =>
            Number(b.valueQuarterMillions) - Number(a.valueQuarterMillions)
        )[0];

      nextFixture =
        teamFixtures.find((x) => x.gameweek === selectedGameweek) ?? null;
      nextFixtureHomeTeam = getTeamFromId(nextFixture?.homeClubId ?? 0) ?? null;
      nextFixtureAwayTeam = getTeamFromId(nextFixture?.awayClubId ?? 0) ?? null;
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
  $: if (fixturesWithTeams.length > 0 && $clubStore.length > 0) {
    tableData = updateTableData(
      fixturesWithTeams,
      $clubStore,
      selectedGameweek
    );
  }

  function getTeamFromId(teamId: number): ClubDTO | undefined {
    return $clubStore.find((team) => team.id === teamId);
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  const getTeamPosition = (teamId: number) => {
    const position = tableData.findIndex((team) => team.id === teamId);
    return position !== -1 ? position + 1 : "-";
  };

  const getTeamPoints = (teamId: number) => {
    if (!tableData || tableData.length == 0) {
      return 0;
    }
    const points = tableData.find((team) => team.id === teamId).points;
    return points;
  };
</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    <div class="page-header-wrapper flex">
      <div class="content-panel">
        <div class="flex-grow flex flex-col items-center">
          <p class="content-panel-header">
            {team?.friendlyName}
          </p>
          <div class="py-2 flex space-x-4">
            <BadgeIcon
              className="h-4"
              primaryColour={team?.primaryColourHex}
              secondaryColour={team?.secondaryColourHex}
              thirdColour={team?.thirdColourHex}
            />
            <ShirtIcon
              className="h-4"
              primaryColour={team?.primaryColourHex}
              secondaryColour={team?.secondaryColourHex}
              thirdColour={team?.thirdColourHex}
            />
          </div>
          <p class="content-panel-header">
            {team?.abbreviatedName}
          </p>
        </div>
        <div class="vertical-divider" />
        <div class="flex-grow">
          <p class="content-panel-header">Players</p>
          <p class="content-panel-stat">
            {$playerStore.filter((x) => x.clubId == id).length}
          </p>
          <p class="content-panel-header">Total</p>
        </div>
        <div class="vertical-divider" />
        <div class="flex-grow">
          <p class="content-panel-header">League Position</p>
          <p class="content-panel-stat">
            {getTeamPosition(id)}
          </p>
          <p class="content-panel-header">
            {seasonName}
          </p>
        </div>
      </div>
      <div class="content-panel">
        <div class="flex-grow flex flex-col items-center">
          <p class="content-panel-header">Next Game</p>
          <div class="py-2 flex space-x-4">
            <a
              class="flex flex-col items-center justify-center"
              href={`/club?id=${
                nextFixtureHomeTeam ? nextFixtureHomeTeam.id : -1
              }`}
            >
              <BadgeIcon
                className="h-4 sm:h-6 my-2 sm:my-4"
                primaryColour={nextFixtureHomeTeam
                  ? nextFixtureHomeTeam.primaryColourHex
                  : ""}
                secondaryColour={nextFixtureHomeTeam
                  ? nextFixtureHomeTeam.secondaryColourHex
                  : ""}
                thirdColour={nextFixtureHomeTeam
                  ? nextFixtureHomeTeam.thirdColourHex
                  : ""}
              />
              <span class="content-panel-header"
                >{nextFixtureHomeTeam
                  ? nextFixtureHomeTeam.abbreviatedName
                  : ""}</span
              >
            </a>
            <a
              class="flex flex-col items-center justify-center"
              href={`/club?id=${
                nextFixtureAwayTeam ? nextFixtureAwayTeam.id : -1
              }`}
            >
              <BadgeIcon
                className="h-4 sm:h-6 my-2 sm:my-4"
                primaryColour={nextFixtureAwayTeam
                  ? nextFixtureAwayTeam.primaryColourHex
                  : ""}
                secondaryColour={nextFixtureAwayTeam
                  ? nextFixtureAwayTeam.secondaryColourHex
                  : ""}
                thirdColour={nextFixtureAwayTeam
                  ? nextFixtureAwayTeam.thirdColourHex
                  : ""}
              />
              <span class="content-panel-header"
                >{nextFixtureAwayTeam
                  ? nextFixtureAwayTeam.abbreviatedName
                  : ""}</span
              >
            </a>
          </div>
        </div>
        <div class="vertical-divider" />
        <div class="flex-grow flex flex-col">
          <p class="content-panel-header">League Points</p>
          <p class="content-panel-stat">
            {getTeamPoints(id)}
          </p>
          <p class="content-panel-header">Total</p>
        </div>

        <div class="vertical-divider" />
        <div class="flex-grow">
          <p class="content-panel-header">Most Points</p>
          {#if highestScoringPlayer?.totalPoints == 0}
            <p class="content-panel-stat">-</p>
            <p class="content-panel-header">
              - ({highestScoringPlayer?.totalPoints})
            </p>
          {:else}
            <p class="content-panel-stat">
              <a href={`/player?id=${highestScoringPlayer?.id}`}
                >{highestScoringPlayer?.lastName}</a
              >
            </p>
            <p class="content-panel-header">
              {getPositionText(
                convertPlayerPosition(
                  highestScoringPlayer?.position ?? { Goalkeeper: null }
                )
              )}
              ({highestScoringPlayer?.totalPoints})
            </p>
          {/if}
        </div>
      </div>
    </div>

    <div class="bg-panel rounded-md">
      <ul class="flex bg-light-gray border-b border-gray-700 px-2 pt-2">
        <li class={`mr-4 ${activeTab === "players" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "players" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("players")}
          >
            Players
          </button>
        </li>
        <li class={`mr-4 ${activeTab === "fixtures" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "fixtures" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("fixtures")}
          >
            Fixtures
          </button>
        </li>
        <li class={`mr-4 ${activeTab === "loaned-players" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "loaned-players" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("loaned-players")}
          >
            Loaned Players
          </button>
        </li>
      </ul>

      {#if activeTab === "players"}
        <TeamPlayers players={$playerStore.filter((x) => x.clubId == id)} />
      {:else if activeTab === "fixtures"}
        <TeamFixtures clubId={id} />
        {:else if activeTab === "loaned-players"}
          <LoanedPlayers clubId={id} />
      {/if}
    </div>
  {/if}
</Layout>
