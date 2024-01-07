<script lang="ts">
  import { onMount } from "svelte";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type {
    ClubDTO,
    FixtureDTO,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import {
    convertFixtureStatus,
    formatUnixTimeToTime,
    getFixtureStatusText,
  } from "../../utils/Helpers";
  import UpdateFixtureModal from "./update-fixture-modal.svelte";

  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedFixture: FixtureDTO | null;

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

  let showUpdateModal = false;
  let isLoading = true;

  onMount(async () => {
    try {
      await teamStore.sync();
      if ($teamStore.length == 0) return;
      await fixtureStore.sync();
      await systemStore.sync();

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
    } finally {
      isLoading = false;
    }
  });

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): ClubDTO | undefined {
    return $teamStore.find((team) => team.id === teamId);
  }

  function openUpdateModal(fixture: FixtureDTO) {
    selectedFixture = fixture;
    showUpdateModal = true;
  }

  function closeUpdateModal() {
    selectedFixture = null;
    showUpdateModal = false;
  }
</script>

{#if selectedFixture}
  <UpdateFixtureModal
    visible={showUpdateModal}
    closeModal={closeUpdateModal}
    cancelModal={closeUpdateModal}
    fixture={selectedFixture}
  />
{/if}

<div class="flex flex-col space-y-4">
  <div class="flex flex-col sm:flex-row gap-4 sm:gap-8 mt-4">
    <div class="flex items-center space-x-2 ml-4">
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
          class="flex items-center justify-between border-b border-gray-700 py-4 bg-light-gray"
        >
          <h2 class="ml-4">{date}</h2>
        </div>
        {#each fixtures as { fixture, homeTeam, awayTeam }}
          <div
            class={`flex items-center justify-between py-2 border-b border-gray-700  ${
              convertFixtureStatus(fixture.status) === 0
                ? "text-gray-400"
                : "text-white"
            }`}
          >
            <div class="flex items-center w-1/2 ml-4">
              <div class="flex w-1/2 space-x-4 justify-center">
                <div class="w-10 items-center justify-center">
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
                <div class="w-10 items-center justify-center">
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
              <div class="flex w-1/2 lg:justify-center">
                <span class="text-sm ml-4 md:ml-0 text-left"
                  >{formatUnixTimeToTime(Number(fixture.kickOff))}</span
                >
              </div>
              <div class="flex w-1/2 lg:justify-center">
                <span class="text-sm ml-4 md:ml-0 text-left"
                  >{getFixtureStatusText(
                    convertFixtureStatus(fixture.status)
                  )}</span
                >
              </div>
            </div>
            <div class="flex items-center space-x-10 w-1/2 lg:justify-center">
              <div
                class="flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px]"
              >
                <a href={`/club?id=${fixture.homeClubId}`}
                  >{homeTeam ? homeTeam.friendlyName : ""}</a
                >
                <a href={`/club?id=${fixture.awayClubId}`}
                  >{awayTeam ? awayTeam.friendlyName : ""}</a
                >
              </div>
              <div
                class="flex flex-col min-w-[200px] lg:min-w-[120px] lg:min-w-[200px]"
              >
                <span
                  >{convertFixtureStatus(fixture.status) === 0
                    ? "-"
                    : fixture.homeGoals}</span
                >
                <span
                  >{convertFixtureStatus(fixture.status) === 0
                    ? "-"
                    : fixture.awayGoals}</span
                >
              </div>
              <div class="flex flex-col">
                <button
                  on:click={() => openUpdateModal(fixture)}
                  class="deault-button fpl-button">Edit</button
                >
              </div>
            </div>
          </div>
        {/each}
      </div>
    {/each}
  </div>
</div>
