<script lang="ts">
    import { onMount } from "svelte";
    
    import { storeManager } from "$lib/managers/store-manager";
    import { clubStore } from "$lib/stores/club-store";
    import { fixtureStore } from "$lib/stores/fixture-store";

    import {
      formatUnixDateToSmallReadable,
      formatUnixTimeToTime,
      getCountdownTime,
    } from "../../utils/helpers";
    import type {
      FixtureDTO,
      ClubDTO,
      PlayerDTO,
      GameweekNumber,
    } from "../../../../../external_declarations/data_canister/data_canister.did";
    import HeaderCountdownPanel from "../shared/panels/header-countdown-panel.svelte";
    import PlayerAgePanel from "./player-age-panel.svelte";
    import HeaderFixturePanel from "../homepage/homepage-header-fixture-panel.svelte";
    import PlayerShirtPanel from "./player-shirt-panel.svelte";
    import PlayerCountryPanel from "./player-country-panel.svelte";
    import PageHeader from "../shared/panels/page-header.svelte";
    import ContentPanel from "../shared/panels/content-panel.svelte";
  
    export let player: PlayerDTO;
    export let club: ClubDTO;
    export let gameweek: GameweekNumber;
    
    let nextFixture: FixtureDTO | null = null;
    let nextFixtureHomeTeam: ClubDTO;
    let nextFixtureAwayTeam: ClubDTO;

    let countdownTime: { days: number; hours: number; minutes: number; };
  
    let isLoading = true;
  
    onMount(async () => {
      await storeManager.syncStores();
  
      if ($fixtureStore.length == 0) return;

      let teamFixtures = $fixtureStore.filter(
        (x) => x.homeClubId === club.id || x.awayClubId === club.id
      );

      nextFixture =
        teamFixtures.find((x) => x.gameweek === gameweek) ?? null;
      nextFixtureHomeTeam = $clubStore.find((team) => team.id === nextFixture?.homeClubId)!
      nextFixtureAwayTeam = $clubStore.find((team) => team.id === nextFixture?.awayClubId)!
      countdownTime = getCountdownTime(nextFixture?.kickOff ?? 0n);
      isLoading = false;
    });
</script>

<PageHeader>
  <ContentPanel>
    <PlayerShirtPanel {player} {club} />
    <div class="vertical-divider"></div>
    <PlayerCountryPanel {player} />
    <div class="vertical-divider"></div>
    <PlayerAgePanel {player} />
  </ContentPanel>
  <ContentPanel>
    {#if nextFixture}
      <HeaderFixturePanel loading={isLoading} {nextFixtureHomeTeam} {nextFixtureAwayTeam} />
      <div class="vertical-divider"></div>
      <HeaderCountdownPanel loading={isLoading} {countdownTime} header="Upcoming Fixture" footer={`${formatUnixDateToSmallReadable(nextFixture.kickOff).toString()} ${formatUnixTimeToTime(nextFixture.kickOff)}`} />
    {:else}
        <p>No fixtures for the season have been announced.</p>
    {/if}
  </ContentPanel>
</PageHeader>