<script lang="ts">
  import { onMount } from "svelte";
  import { toastsError } from "$lib/stores/toasts-store";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { systemStore } from "$lib/stores/system-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type { ClubDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";

  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedGameweek: number;
  let gameweeks = Array.from(
    { length: $systemStore?.calculationGameweek ?? 1 },
    (_, i) => i + 1
  );
  let tableData: any[] = [];

  onMount(async () => {
    try {
      await teamStore.sync();
      if ($teamStore.length == 0) return;
      await systemStore.sync();
      await fixtureStore.sync($systemStore?.calculationSeasonId ?? 1);
      selectedGameweek = $systemStore?.calculationGameweek ?? 1;

      fixturesWithTeams = $fixtureStore.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeClubId),
        awayTeam: getTeamFromId(fixture.awayClubId),
      }));
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching league table." },
        err: error,
      });
      console.error("Error fetching league table:", error);
    } finally {
    }
  });

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): ClubDTO | undefined {
    return $teamStore.find((team) => team.id === teamId);
  }
</script>

<div class="page-header-wrapper flex">
  <div class="content-panel">
    <div class="flex-grow flex flex-col items-center">
      <p class="content-panel-header">Clubs</p>
      
        {#each $teamStore as team}
          <p>{team.name}</p>
        {/each}
    </div>
  </div>
</div>
