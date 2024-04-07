<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { authStore } from "$lib/stores/auth.store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { teamStore } from "$lib/stores/team-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { managerStore } from "$lib/stores/manager-store";
  import {
    formatUnixDateToReadable,
    formatUnixDateToSmallReadable,
    formatUnixTimeToTime,
    getCountdownTime,
  } from "../lib/utils/Helpers";
  import type {
    LeaderboardEntry,
    ClubDTO,
  } from "../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import Layout from "./Layout.svelte";
  import FixturesComponent from "$lib/components/fixtures.svelte";
  import GamweekPointsComponents from "$lib/components/gameweek-points.svelte";
  import LeaderboardsComponent from "$lib/components/leaderboards.svelte";
  import LeagueTableComponent from "$lib/components/league-table.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { Spinner } from "@dfinity/gix-components";
  import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";
  import OpenFplIcon from "$lib/icons/OpenFPLIcon.svelte";

  let activeTab: string = "fixtures";
  let managerCount = 0;
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";
  let nextFixtureDate = "-";
  let nextFixtureDateSmall = "-";
  let nextFixtureTime = "-";
  let weeklyLeader: LeaderboardEntry;
  let nextFixtureHomeTeam: ClubDTO | undefined = undefined;
  let nextFixtureAwayTeam: ClubDTO | undefined = undefined;
  let isLoggedIn = false;
  let isLoading = true;

  onMount(async () => {
    try {
      await authStore.sync();
      await systemStore.sync();
      await teamStore.sync();
      await fixtureStore.sync($systemStore?.calculationSeasonId ?? 1);

      if ($teamStore.length == 0) return;
      if ($fixtureStore.length == 0) return;

      await weeklyLeaderboardStore.sync(
        $systemStore?.calculationSeasonId ?? 1,
        $systemStore?.calculationGameweek ?? 1
      );

      authStore.subscribe((store) => {
        isLoggedIn = store.identity !== null && store.identity !== undefined;
      });

      managerCount = await managerStore.getTotalManagers();

      if ($teamStore.length == 0) {
        return [];
      }

      let nextFixture = await fixtureStore.getNextFixture();

      nextFixtureHomeTeam = await teamStore.getTeamById(
        nextFixture ? nextFixture.homeClubId : 0
      );
      nextFixtureAwayTeam = await teamStore.getTeamById(
        nextFixture ? nextFixture.awayClubId : 0
      );
      nextFixtureDate = formatUnixDateToReadable(
        nextFixture ? Number(nextFixture.kickOff) : 0
      );
      nextFixtureDateSmall = formatUnixDateToSmallReadable(
        nextFixture ? Number(nextFixture.kickOff) : 0
      );
      nextFixtureTime = formatUnixTimeToTime(
        nextFixture ? Number(nextFixture.kickOff) : 0
      );

      let countdownTime = getCountdownTime(
        nextFixture ? Number(nextFixture.kickOff) : 0
      );
      countdownDays = countdownTime.days.toString();
      countdownHours = countdownTime.hours.toString();
      countdownMinutes = countdownTime.minutes.toString();

      weeklyLeader = await weeklyLeaderboardStore.getLeadingWeeklyTeam(
        $systemStore?.calculationSeasonId ?? 1,
        $systemStore?.calculationGameweek ?? 1
      );
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching homepage data." },
        err: error,
      });
      console.error("Error fetching homepage data:", error);
    } finally {
      isLoading = false;
    }
  });

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  //TODO: Remove when the game begins:

  const targetDate = new Date("June 1, 2024 00:00:00").getTime();
  let countdown: string = "00d 00h 00m 00s";
  let interval: ReturnType<typeof setInterval>;

  onMount(() => {
    // Start the countdown timer
    interval = setInterval(() => {
      const now = new Date().getTime();
      const timeLeft = targetDate - now;

      if (timeLeft < 0) {
        clearInterval(interval);
        countdown = "EXPIRED";
        return;
      }

      // Time calculations for days, hours, minutes and seconds
      const days = Math.floor(timeLeft / (1000 * 60 * 60 * 24))
        .toString()
        .padStart(2, "0");
      const hours = Math.floor(
        (timeLeft % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60)
      )
        .toString()
        .padStart(2, "0");
      const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60))
        .toString()
        .padStart(2, "0");
      const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000)
        .toString()
        .padStart(2, "0");

      countdown = `${days}d ${hours}h ${minutes}m ${seconds}s`;
    }, 1000);
  });

  onDestroy(() => {
    // Clear the interval when the component is destroyed
    clearInterval(interval);
  });
</script>

<Layout>
  {#if isLoading || !$systemStore}
    <Spinner />
  {:else}
    <!-- Todo: This will be removed when the game begins -->
    <div class="flex flex-col lg:flex-row w-full mt-4">
      <div
        class="flex flex-col items-center text-center p-4 lg:p-8 rounded-lg shadow-lg bg-panel-color w-full mx-2 lg:mx-16"
      >
        <OpenFplIcon className="h-16 lg:h-64 w-auto mb-2 lg:mb-4" />
        <div class="text-xl lg:text-3xl font-bold my-2 lg:my-4">
          {countdown}
        </div>
        <h2 class="text-md lg:text-xl my-2 lg:my-4">Until OpenFPL Begins</h2>
        <div class="horizontal-divider my-2 lg:my-4" />
        <h2 class="text-md lg:text-xl">2024/25 Prize Pool:</h2>
        <h2 class="text-lg lg:text-2xl font-bold">1,875,000 $FPL</h2>
        <div class="horizontal-divider my-2 lg:my-4" />
        <div
          class="flex flex-col lg:flex-row space-y-2 lg:space-y-0 lg:space-x-4 w-full mt-2"
        >
          <a class="w-full lg:flex-grow" href="/gameplay-rules">
            <button
              class="fpl-purple-btn w-full lg:flex-grow p-2 lg:p-4 rounded-md"
              >How To Play</button
            >
          </a>
          <a class="w-full lg:flex-grow" href="/clubs">
            <button
              class="fpl-purple-btn w-full lg:flex-grow p-2 lg:p-4 rounded-md"
              >Clubs</button
            >
          </a>
          <a class="w-full lg:flex-grow" href="/governance">
            <button
              class="fpl-purple-btn w-full lg:flex-grow p-2 lg:p-4 rounded-md"
              >Proposals</button
            >
          </a>
        </div>
      </div>

      <div class="lg:w-1/4 w-full my-4 lg:my-0">
        <img alt="play" class="rounded-lg mx-auto" src="play.png" />
      </div>
    </div>
  {/if}
</Layout>