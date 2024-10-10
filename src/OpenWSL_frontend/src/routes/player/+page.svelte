<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { playerStore } from "$lib/stores/player-store";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import {
    calculateAgeFromNanoseconds,
    convertDateToReadable,
    convertPlayerPosition,
    formatUnixDateToReadable,
    formatUnixDateToSmallReadable,
    formatUnixTimeToTime,
    getCountdownTime,
    getFlagComponent,
    getPositionText,
    updateTableData,
  } from "../../lib/utils/helpers";
  import type {
    FixtureDTO,
    ClubDTO,
    PlayerDTO,
  } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import Layout from "../Layout.svelte";
  import PlayerGameweekHistory from "$lib/components/player-gameweek-history.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import ShirtIcon from "$lib/icons/ShirtIcon.svelte";
  import { countryStore } from "$lib/stores/country-store";
    import LocalSpinner from "$lib/components/local-spinner.svelte";
    import { storeManager } from "$lib/managers/store-manager";

  $: id = Number($page.url.searchParams.get("id"));

  let selectedGameweek: number = $systemStore?.pickTeamGameweek ?? 1;
  let selectedPlayer: PlayerDTO | null = null;
  let fixturesWithTeams: FixtureWithTeams[] = [];
  let team: ClubDTO | null = null;

  let nextFixture: FixtureDTO | null = null;
  let nextFixtureHomeTeam: ClubDTO | null = null;
  let nextFixtureAwayTeam: ClubDTO | null = null;
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let nextFixtureDate = "-";
  let nextFixtureDateSmall = "-";
  let nextFixtureTime = "-";
  let activeTab: string = "history";

  let isLoading = true;

  onMount(async () => {
    try {
      
      await storeManager.syncStores();

      selectedPlayer = $playerStore.find((x) => x.id === id) ?? null;
      team = $clubStore.find((x) => x.id === selectedPlayer?.clubId) ?? null;

      if ($fixtureStore.length == 0) return;

      fixturesWithTeams = $fixtureStore.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeClubId),
        awayTeam: getTeamFromId(fixture.awayClubId),
      }));

      let teamFixtures = $fixtureStore.filter(
        (x) => x.homeClubId === team?.id || x.awayClubId === team?.id
      );

      nextFixture =
        teamFixtures.find((x) => x.gameweek === selectedGameweek) ?? null;
      nextFixtureHomeTeam = getTeamFromId(nextFixture?.homeClubId ?? 0) ?? null;
      nextFixtureAwayTeam = getTeamFromId(nextFixture?.awayClubId ?? 0) ?? null;

      nextFixtureDate = formatUnixDateToReadable(nextFixture?.kickOff ?? 0n);
      nextFixtureDateSmall = formatUnixDateToSmallReadable(nextFixture?.kickOff ?? 0n);
      nextFixtureTime = formatUnixTimeToTime(nextFixture?.kickOff ?? 0n);
      let countdownTime = getCountdownTime(nextFixture?.kickOff ?? 0n);

      countdownDays = countdownTime.days.toString();
      countdownHours = countdownTime.hours.toString();
      countdownMinutes = countdownTime.minutes.toString();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching player details." },
        err: error,
      });
      console.error("Error fetching data:", error);
    } finally {
      isLoading = false;
    }
  });

  let tableData: any[] = [];
  $: if ($fixtureStore.length > 0 && $clubStore.length > 0) {
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
</script>

<Layout>
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="page-header-wrapper flex">
      <div class="content-panel">
        <div class="flex-grow flex flex-col items-center">
          <p class="content-panel-header">
            {getPositionText(
              convertPlayerPosition(
                selectedPlayer?.position ?? { Goalkeeper: null }
              ) ?? -1
            )}
          </p>
          <div class="py-2 flex">
            <ShirtIcon
              className="h-10"
              primaryColour={team?.primaryColourHex}
              secondaryColour={team?.secondaryColourHex}
              thirdColour={team?.thirdColourHex}
            />
          </div>
          <p class="content-panel-header">
            Shirt: {selectedPlayer?.shirtNumber}
          </p>
        </div>
        <div class="vertical-divider" />
        <div class="flex-grow">
          <p class="content-panel-header">{team?.name}</p>
          <p class="content-panel-stat">
            {selectedPlayer?.totalPoints}
          </p>
          <p class="content-panel-header">Total Points</p>
        </div>
        <div class="vertical-divider" />
        <div class="flex-grow">
          <p class="content-panel-header">{selectedPlayer?.firstName}</p>
          <p class="content-panel-stat">
            {selectedPlayer?.lastName}
          </p>
          <p class="content-panel-header">
            <span class="flex flex-row items-center">
              <svelte:component
                this={getFlagComponent(selectedPlayer?.nationality ?? 0)}
                class="w-4 h-4 mr-1"
                size="100"
              />{$countryStore.find(
                (x) => x.id == selectedPlayer?.nationality
              )?.name}
            </span>
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
          <p class="content-panel-header">Kick Off:</p>
          <p class="content-panel-stat">
            {countdownDays}<span class="countdown-text">d</span>
            : {countdownHours}<span class="countdown-text">h</span>
            : {countdownMinutes}<span class="countdown-text">m</span>
          </p>
          <p class="hidden xl:flex content-panel-header">
            {nextFixtureDate} | {nextFixtureTime}
          </p>
          <p class="content-panel-header xl:hidden">
            {nextFixtureDateSmall}
          </p>
        </div>
        <div class="vertical-divider" />
        <div class="flex-grow flex flex-col">
          <p class="content-panel-header">Age</p>
          <p class="content-panel-stat">
            {calculateAgeFromNanoseconds(
              Number(selectedPlayer?.dateOfBirth ?? 0)
            )}
          </p>
          <p class="content-panel-header">
            {convertDateToReadable(Number(selectedPlayer?.dateOfBirth ?? 0))}
          </p>
        </div>
      </div>
    </div>

    <div class="bg-panel rounded-md">
      <ul class="flex bg-light-gray border-b border-gray-700 px-2 pt-2">
        <li class={`mr-4 ${activeTab === "history" ? "active-tab" : ""}`}>
          <button
            class={`p-2 ${
              activeTab === "history" ? "text-white" : "text-gray-400"
            }`}
            on:click={() => setActiveTab("history")}
          >
            Gameweek History
          </button>
        </li>
      </ul>

      {#if activeTab === "history"}
        <PlayerGameweekHistory />
      {/if}
    </div>
  {/if}
</Layout>
