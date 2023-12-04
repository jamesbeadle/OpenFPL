<script lang="ts">
  import { onMount } from "svelte";
  import { toastsError } from "$lib/stores/toasts-store";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { systemStore } from "$lib/stores/system-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { updateTableData } from "../utils/Helpers";
  import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";

  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedGameweek: number = $systemStore?.activeGameweek ?? 1;
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  let tableData: any[] = [];

  onMount(async () => {
    try {
      await teamStore.sync();
      await fixtureStore.sync();
      await systemStore.sync();

      fixturesWithTeams = $fixtureStore.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeTeamId),
        awayTeam: getTeamFromId(fixture.awayTeamId),
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

  $: if ($fixtureStore.length > 0 && $teamStore.length > 0) {
    tableData = updateTableData(
      fixturesWithTeams,
      $teamStore,
      selectedGameweek
    );
  }

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): Team | undefined {
    return $teamStore.find((team) => team.id === teamId);
  }
</script>

<div class="container-fluid mt-4">
  <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
    <div class="flex items-center space-x-2 ml-4">
      <button
        class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1"
        on:click={() => changeGameweek(-1)}
        disabled={selectedGameweek === 1}
      >
        &lt;
      </button>

      <select
        class="p-2 fpl-dropdown text-xs md:text-base text-center mx-0 md:mx-2 min-w-[150px] sm:min-w-[100px]"
        bind:value={selectedGameweek}
      >
        {#each gameweeks as gameweek}
          <option value={gameweek}>Gameweek {gameweek}</option>
        {/each}
      </select>

      <button
        class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
        on:click={() => changeGameweek(1)}
        disabled={selectedGameweek === 38}
      >
        &gt;
      </button>
    </div>
  </div>

  <div class="flex flex-col space-y-4 mt-4 text-xs md:text-base">
    <div class="overflow-x-auto flex-1">
      <div
        class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
      >
        <div class="w-1/12 text-center mx-4">Pos</div>
        <div class="w-3/12">Team</div>
        <div class="w-1/12 text-center">P</div>
        <div class="w-1/12 text-center">W</div>
        <div class="w-1/12 text-center">D</div>
        <div class="w-1/12 text-center">L</div>
        <div class="w-1/12 text-center">GF</div>
        <div class="w-1/12 text-center">GA</div>
        <div class="w-1/12 text-center">GD</div>
        <div class="w-1/12 text-center">PTS</div>
      </div>

      {#each tableData as team, idx}
        <div
          class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer"
        >
          <div class="w-1/12 text-center mx-4">{idx + 1}</div>
          <a
            class="w-3/12 flex items-center justify-start"
            href={`/club?id=${team.id}`}
          >
            <BadgeIcon
              primaryColour={team.primaryColourHex}
              secondaryColour={team.secondaryColourHex}
              thirdColour={team.thirdColourHex}
              className="w-6 h-6 mr-2"
            />
            {team.friendlyName}
          </a>
          <div class="w-1/12 text-center">{team.played}</div>
          <div class="w-1/12 text-center">{team.wins}</div>
          <div class="w-1/12 text-center">{team.draws}</div>
          <div class="w-1/12 text-center">{team.losses}</div>
          <div class="w-1/12 text-center">{team.goalsFor}</div>
          <div class="w-1/12 text-center">{team.goalsAgainst}</div>
          <div class="w-1/12 text-center">
            {team.goalsFor - team.goalsAgainst}
          </div>
          <div class="w-1/12 text-center">{team.points}</div>
        </div>
      {/each}
    </div>
  </div>
</div>
