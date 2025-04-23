<script lang="ts">
  import { onMount } from "svelte";
  import { writable } from "svelte/store";
  import { leagueStore } from "$lib/stores/league-store";
  import { seasonStore } from "$lib/stores/season-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { clubStore } from "$lib/stores/club-store";
  import { playerStore } from "$lib/stores/player-store";
  import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";
  import HeaderContentPanel from "$lib/components/shared/panels/header-content-panel.svelte";
  import HeaderFixturePanel from "$lib/components/shared/panels/header-fixture-panel.svelte";
  import { getFixturesWithTeams, updateTableData } from "$lib/utils/helpers";
  import ClubBrandPanel from "./club-brand-panel.svelte";
  import PageHeader from "../shared/panels/page-header.svelte";
  import ContentPanel from "../shared/panels/content-panel.svelte";
  import LocalSpinner from "../shared/local-spinner.svelte";
  import type { Club, Fixture, Player, ClubId } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  
  interface Props {
    club: Club;
  }
  let { club }: Props = $props();

  let isLoading = true;
  let nextFixture: Fixture | null;
  let nextFixtureHomeTeam: Club | undefined;
  let nextFixtureAwayTeam: Club | undefined;
  let fixturesWithTeams: FixtureWithClubs[] = [];
  let selectedGameweek = writable(1);
  let tableData: any[] = [];
  let highestScoringPlayer: Player | null = null;
  let seasonName = "";

  $: if (fixturesWithTeams.length > 0 && $clubStore.length > 0) {
    tableData = updateTableData(fixturesWithTeams, $clubStore, $selectedGameweek);
  }

  onMount(async () => {
      club = $clubStore.find((x) => x.id == clubId)!;
      seasonName = $seasonStore.find(x => x.id == $leagueStore!.activeSeasonId)?.name ?? "";
      $selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek ?? 1;

      let teamFixtures = $fixtureStore.filter((x) => x.homeClubId === clubId || x.awayClubId === clubId);
      fixturesWithTeams = getFixturesWithTeams($clubStore, teamFixtures);
      
      highestScoringPlayer = $playerStore.filter(x => x.clubId == clubId)
        .sort((a, b) => Number(b.valueQuarterMillions) - Number(a.valueQuarterMillions))[0];

      nextFixture = teamFixtures.find((x) => x.gameweek === $selectedGameweek) ?? null;
      nextFixtureHomeTeam = $clubStore.find((team) => team.id === nextFixture?.homeClubId);
      nextFixtureAwayTeam = $clubStore.find((team) => team.id === nextFixture?.awayClubId);
      isLoading = false;
  });

  const getTeamPosition = (teamId: number) => {
      const position = tableData.findIndex((team) => team.id === teamId);
      return position !== -1 ? position + 1 : "-";
  };

  const getTeamPoints = (teamId: number) => {
      if (!tableData || tableData.length == 0) { return 0; }
      const points = tableData.find((team) => team.id === teamId).points;
      return points;
  };
</script>

<PageHeader>
  {#if isLoading}
    <LocalSpinner />
  {:else}
    <ContentPanel>
      <ClubBrandPanel {club} />
      <div class="vertical-divider"></div>
      <HeaderContentPanel header="Players" content={$playerStore.filter((x) => x.clubId == clubId).length.toString()} footer="Total" loading={false} />
      <div class="vertical-divider"></div>
      <HeaderContentPanel header="League Position" content={getTeamPosition(clubId).toString()} footer={seasonName} loading={false} />
    </ContentPanel>
    <ContentPanel>
      <HeaderFixturePanel header="Next Game" {nextFixtureAwayTeam} {nextFixtureHomeTeam} />
      <div class="vertical-divider"></div>
      <HeaderContentPanel header="League Points" content={getTeamPoints(clubId).toString()} footer="Total" loading={false} />
      <div class="vertical-divider"></div>
      <HeaderContentPanel header="Most Valuable Player" content={highestScoringPlayer?.lastName ?? "-"} footer={Object.keys(highestScoringPlayer?.position ?? { Goalkeeper: null })[0].toString()} loading={false} />
    </ContentPanel>
  {/if}
</PageHeader>