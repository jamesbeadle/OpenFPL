<script lang="ts">
  import { onMount } from "svelte";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { formatUnixDateToReadable, formatUnixTimeToTime, getCountdownTime } from "$lib/utils/Helpers";

  import { seasonStore } from "$lib/stores/season-store";
  import PageHeader from "../../shared/panels/page-header.svelte";
  import { leagueStore } from "$lib/stores/league-store";
  import ContentPanel from "../../shared/panels/content-panel.svelte";
  import HeaderContentPanel from "../../shared/panels/header-content-panel.svelte";
  import HeaderCountdownPanel from "../../shared/panels/header-countdown-panel.svelte";
  import type { TeamSetup } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { teamSetupStore } from "$lib/stores/team-setup-store";
    import LocalSpinner from "$lib/components/shared/global/local-spinner.svelte";
 
  interface Props {
    teamValue: number;
  }
  let { teamValue }: Props = $props();
  
  let isLoading = $state(true);
  let activeSeason = $state("-");
  let activeGameweek = $state(1);
  let nextFixtureDate = $state("-");
  let nextFixtureTime = $state("-");
  let countdownTime: { days: number; hours: number; minutes: number; } = $state({days: 0, hours: 0, minutes: 0});

  onMount(async () => {
    let foundSeason = $seasonStore.find(x => x.id == $leagueStore!.activeSeasonId);
    if(foundSeason){
      activeSeason = foundSeason.name;
    }
    activeGameweek = $leagueStore!.unplayedGameweek;
    setCountdownTimer();
    isLoading = false;
  });

  async function setCountdownTimer() {
    let gameweekFixtures = $fixtureStore.filter(x => x.gameweek == ($leagueStore!.unplayedGameweek))
    .sort((a, b) => Number(a.kickOff) - Number(b.kickOff));

    let earliestFixture = gameweekFixtures[0];
    
    if(!earliestFixture){
      return
    };

    let oneHourBeforeKickOff = BigInt(earliestFixture.kickOff) - BigInt(3_600 * 1_000_000_000);

    nextFixtureDate = formatUnixDateToReadable(oneHourBeforeKickOff);
    nextFixtureTime = formatUnixTimeToTime(oneHourBeforeKickOff);

    countdownTime = getCountdownTime(oneHourBeforeKickOff);
  }

</script>

<PageHeader>
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <ContentPanel>
      <HeaderContentPanel header="Gameweek" content={`${activeGameweek}`} footer={activeSeason} loading={false} />
      <div class="vertical-divider"></div>
      <HeaderCountdownPanel header="Kick Off" footer={`${nextFixtureDate} | ${nextFixtureTime}`} {countdownTime} />    
      <div class="vertical-divider"></div>
      <HeaderContentPanel header="Players" content={`${$teamSetupStore?.playerIds.filter((x) => x > 0).length}/11`} footer="Selected" loading={false} />
    </ContentPanel>
    <ContentPanel>
      <HeaderContentPanel header="Team Value" content={`£${teamValue.toFixed(2)}m`} footer="GBP" loading={false} />
      <div class="vertical-divider"></div>
      <HeaderContentPanel header="Bank Balance" content={`£${($teamSetupStore ? $teamSetupStore?.bankQuarterMillions  / 4 : 350).toFixed(2)}m`} footer="GBP" loading={false} />
      <div class="vertical-divider"></div>
      <HeaderContentPanel header="Transfers" content={`${(!$teamSetupStore || $teamSetupStore.firstGameweek || $teamSetupStore.transferWindowGameweek == $leagueStore!.unplayedGameweek) ? "Unlimited" : $teamSetupStore.transfersAvailable}`} footer="Available" loading={false} />
    </ContentPanel>
  {/if}
</PageHeader>