<script lang="ts">
  import { onMount } from "svelte";
  import type { Writable } from "svelte/store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import {
    formatUnixDateToReadable,
    formatUnixTimeToTime,
    getCountdownTime,
  } from "../../../lib/utils/Helpers";
  import type { PickTeamDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  let activeSeason: string;
  let activeGameweek: number;
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let teamValue = 0;

  export let fantasyTeam: Writable<PickTeamDTO | null>;
  export let transfersAvailable: Writable<number>;
  export let bankBalance: Writable<number>;

  let isLoading = true;

  onMount(() => {
    activeSeason = $systemStore?.pickTeamSeasonName ?? "-";
    activeGameweek = $systemStore?.pickTeamGameweek ?? 1;
    try {
      loadData();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching header data." },
        err: error,
      });
      console.error("Error fetching header data:", error);
    } finally {
      isLoading = false;
    }
  });

  async function loadData() {
    let nextFixture = await fixtureStore.getNextFixture();
    nextFixtureDate = formatUnixDateToReadable(Number(nextFixture?.kickOff));
    nextFixtureTime = formatUnixTimeToTime(Number(nextFixture?.kickOff));

    let countdownTime = getCountdownTime(Number(nextFixture?.kickOff));
    countdownDays = countdownTime.days.toString();
    countdownHours = countdownTime.hours.toString();
    countdownMinutes = countdownTime.minutes.toString();
    isLoading = false;
  }
</script>

<div class="hidden xl:flex page-header-wrapper">
  <div class="content-panel lg:w-1/2">
    <div class="flex-grow mb-4 xl:mb-0">
      <p class="content-panel-header">Gameweek</p>
      <p class="content-panel-stat">
        {activeGameweek}
      </p>
      <p class="content-panel-header">
        {activeSeason}
      </p>
    </div>

    <div class="vertical-divider" />

    <div class="flex-grow mb-4 xl:mb-0">
      <p class="content-panel-header mt-4 xl:mt-0">Kick Off:</p>
      <div class="flex">
        <p class="content-panel-stat">
          {countdownDays}<span class="countdown-text">d</span>
          : {countdownHours}<span class="countdown-text">h</span>
          : {countdownMinutes}<span class="countdown-text">m</span>
        </p>
      </div>
      <p class="content-panel-header">
        {nextFixtureDate} | {nextFixtureTime}
      </p>
    </div>

    <div class="vertical-divider" />

    <div class="flex-grow mb-0 mt-4 xl:mt-0">
      <p class="content-panel-header">Players</p>
      <p class="content-panel-stat">
        {$fantasyTeam?.playerIds.filter((x) => x > 0).length}/11
      </p>
      <p class="content-panel-header">Selected</p>
    </div>
  </div>

  <div class="content-panel lg:w-1/2">
    <div class="flex-grow mb-4 xl:mb-0">
      <p class="content-panel-header">Team Value</p>
      <p class="content-panel-stat">
        £{teamValue.toFixed(2)}m
      </p>
      <p class="content-panel-header">GBP</p>
    </div>

    <div class="vertical-divider" />

    <div class="flex-grow mb-4 xl:mb-0 mt-4 xl:mt-0">
      <p class="content-panel-header">Bank Balance</p>
      <p class="content-panel-stat">
        £{($bankBalance / 4).toFixed(2)}m
      </p>
      <p class="content-panel-header">GBP</p>
    </div>

    <div class="vertical-divider" />

    <div class="flex-grow mb-4 xl:mb-0 mt-4 xl:mt-0">
      <p class="content-panel-header">Transfers</p>
      <p class="content-panel-stat">
        {$transfersAvailable === Infinity ? "Unlimited" : $transfersAvailable}
      </p>
      <p class="content-panel-header">Available</p>
    </div>
  </div>
</div>
