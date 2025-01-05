<script lang="ts">
  import { onMount } from "svelte";
  import { type Writable } from "svelte/store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { playerStore } from "$lib/stores/player-store";
  import { formatUnixDateToReadable, formatUnixTimeToTime, getCountdownTime } from "$lib/utils/helpers";
  import type { PickTeamDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

  import { seasonStore } from "$lib/stores/season-store";
  import PageHeader from "../shared/panels/page-header.svelte";
  import { leagueStore } from "$lib/stores/league-store";
  import ContentPanel from "../shared/panels/content-panel.svelte";
  import HeaderContentPanel from "../shared/panels/header-content-panel.svelte";
  import HeaderCountdownPanel from "../shared/panels/header-countdown-panel.svelte";
 
  export let fantasyTeam: Writable<PickTeamDTO | undefined>;
  export let teamValue: Writable<number>;
  
  let isLoading = true;
  let activeSeason = "-";
  let activeGameweek = 1;
  let nextFixtureDate = "-";
  let nextFixtureTime = "-";
  let countdownTime: { days: number; hours: number; minutes: number; };

  onMount(async () => {
    
    let foundSeason = $seasonStore.find(x => x.id == $leagueStore!.activeSeasonId);
    if(foundSeason){
      activeSeason = foundSeason.name;
    }
    activeGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek;
    updateTeamValue();
    setCountdownTimer();
    isLoading = false;
  });

  async function setCountdownTimer() {
    let gameweekFixtures = $fixtureStore.filter(x => x.gameweek == ($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek))
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

<PageHeader>
  <ContentPanel>
    <HeaderContentPanel header="Gameweek" content={`${activeGameweek}`} footer={activeSeason} loading={false} />
    <div class="vertical-divider"></div>
    <HeaderCountdownPanel header="Kick Off" footer={`${nextFixtureDate} | ${nextFixtureTime}`} {countdownTime} loading={false} />    
    <div class="vertical-divider"></div>
    <HeaderContentPanel header="Players" content={`£${$fantasyTeam?.playerIds.filter((x) => x > 0).length}/11`} footer="Selected" loading={false} />
  </ContentPanel>
  <ContentPanel>
    <HeaderContentPanel header="Team Value" content={`£${$teamValue.toFixed(2)}m`} footer="GBP" loading={false} />
    <div class="vertical-divider"></div>
    <HeaderContentPanel header="Bank Balance" content={`£${($fantasyTeam ? $fantasyTeam?.bankQuarterMillions  / 4 : 300).toFixed(2)}m`} footer="GBP" loading={false} />
    <div class="vertical-divider"></div>
    <HeaderContentPanel header="Transfers" content={`${(!$fantasyTeam || $fantasyTeam.firstGameweek || $fantasyTeam.transferWindowGameweek == $leagueStore!.unplayedGameweek) ? "Unlimited" : $fantasyTeam.transfersAvailable}`} footer="Available" loading={false} />
  </ContentPanel>
</PageHeader>