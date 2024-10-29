<script lang="ts">
  import { onMount } from "svelte";
  import { type Writable } from "svelte/store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { systemStore } from "$lib/stores/system-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { playerStore } from "$lib/stores/player-store";
  import { formatUnixDateToReadable, formatUnixTimeToTime, getCountdownTime } from "$lib/utils/helpers";
  import type { PickTeamDTO } from "../../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import LocalSpinner from "../local-spinner.svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { seasonStore } from "$lib/stores/season-store";
  
  let isLoading = true;
  let activeSeason = "-";
  let activeGameweek = 1;

  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  let countdownDays = "00";
  let countdownHours = "00";
  let countdownMinutes = "00";

  export let transfersAvailable: Writable<number>;  
  export let bankBalance: Writable<number>;
  export let teamValue: Writable<number>;
  
  export let fantasyTeam: Writable<PickTeamDTO | null>;

  onMount(async () => {

    await storeManager.syncStores();
    let foundSeason = $seasonStore.find(x => x.id == $systemStore?.pickTeamSeasonId);
    if(foundSeason){
      activeSeason = foundSeason.name;
    }

    if($systemStore?.pickTeamGameweek){
      activeGameweek = $systemStore?.pickTeamGameweek
    }

    try {
      updateTeamValue();
      setCountdownTimer();
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching pick team header data." },
        err: error,
      });
      console.error("Error fetching pick team header data:", error);
    } finally {
      isLoading = false;
    }
  });

  async function setCountdownTimer() {
    let gameweekFixtures = $fixtureStore.filter(x => x.gameweek == $systemStore?.pickTeamGameweek)
    .sort((a, b) => Number(a.kickOff) - Number(b.kickOff));

    let earliestFixture = gameweekFixtures[0];
    
    if(!earliestFixture){
      return
    };

    let oneHourBeforeKickOff = BigInt(earliestFixture.kickOff) - BigInt(3_600 * 1_000_000_000);

    nextFixtureDate = formatUnixDateToReadable(oneHourBeforeKickOff);
    nextFixtureTime = formatUnixTimeToTime(oneHourBeforeKickOff);

    let countdownTime = getCountdownTime(oneHourBeforeKickOff);
    countdownDays = countdownTime.days.toString();
    countdownHours = countdownTime.hours.toString();
    countdownMinutes = countdownTime.minutes.toString();
  }

  function updateTeamValue() {
    if ($fantasyTeam) {
      let totalValue = 0;
      $fantasyTeam.playerIds.forEach((id) => {
        const player = $playerStore.find((p) => p.id === id);
        if (player) {
          totalValue += player.valueQuarterMillions;
        }
      });
      
      if(totalValue > 0){
        teamValue.set(totalValue / 4);
      }
    }
  }

</script>

<div class="flex page-header-wrapper w-full">
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <div class="content-panel lg:w-1/2">


      <div class="flex-grow my-2 xl:mb-0">
        <p class="content-panel-header">Gameweek</p>
        <p class="content-panel-stat">
          {activeGameweek}
        </p>
        <p class="content-panel-header">
          {activeSeason}
        </p>
      </div>


      <div class="vertical-divider" />


      <div class="flex-grow my-2 xl:mb-0">
        <p class="content-panel-header">Kick Off:</p>
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


      <div class="flex-grow my-4 xl:mb-0">
        <p class="content-panel-header">Players</p>
        <p class="content-panel-stat">
          {$fantasyTeam?.playerIds.filter((x) => x > 0).length}/11
        </p>
        <p class="content-panel-header">Selected</p>
      </div>



    </div>

    <div class="content-panel lg:w-1/2">
      <div class="flex-grow my-4 xl:mb-0">
        <p class="content-panel-header">Team Value</p>
        <p class="content-panel-stat">
          £{$teamValue.toFixed(2)}m
        </p>
        <p class="content-panel-header">GBP</p>
      </div>

      <div class="vertical-divider" />

      <div class="flex-grow my-4 xl:mb-0">
        <p class="content-panel-header">Bank Balance</p>
        <p class="content-panel-stat">
          £{($bankBalance / 4).toFixed(2)}m
        </p>
        <p class="content-panel-header">GBP</p>
      </div>

      <div class="vertical-divider" />

      <div class="flex-grow my-4 xl:mb-0">
        <p class="content-panel-header">Transfers</p>
        <p class="content-panel-stat">
          {$transfersAvailable === Infinity ? "Unlimited" : $transfersAvailable}
        </p>
        <p class="content-panel-header">Available</p>
      </div>
    </div>
  {/if}
</div>
