<script lang="ts">
  import { onMount } from "svelte";
  import { toastsError } from "$lib/stores/toasts-store";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { systemStore } from "$lib/stores/system-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import { updateTableData } from "../utils/helpers";
  import type { ClubDTO } from "../../../../declarations/OpenWSL_backend/OpenWSL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
    import { storeManager } from "$lib/managers/store-manager";

  let fixturesWithTeams: FixtureWithTeams[] = [];
  let selectedGameweek: number;
  let gameweeks = Array.from(
    { length: $systemStore?.calculationGameweek ?? 1 },
    (_, i) => i + 1
  );
  let tableData: any[] = [];

  onMount(async () => {
    try {
      
      await storeManager.syncStores();
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

  $: if ($fixtureStore.length > 0 && $clubStore.length > 0) {
    tableData = updateTableData(
      fixturesWithTeams,
      $clubStore,
      selectedGameweek
    );
  }

  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(Number(process.env.TOTAL_GAMEWEEKS), selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): ClubDTO | undefined {
    return $clubStore.find((team) => team.id === teamId);
  }
</script>

<div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
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
      class="p-2 fpl-dropdown mx-0 md:mx-2 min-w-[100px]"
      bind:value={selectedGameweek}
    >
      {#each gameweeks as gameweek}
        <option value={gameweek}>Gameweek {gameweek}</option>
      {/each}
    </select>

    <button
      class={`${
        selectedGameweek === $systemStore?.calculationGameweek
          ? "bg-gray-500"
          : "fpl-button"
      } default-button ml-1`}
      on:click={() => changeGameweek(1)}
      disabled={selectedGameweek === $systemStore?.calculationGameweek}
    >
      &gt;
    </button>
  </div>
</div>

<div class="flex flex-col space-y-4 mt-4">
  <div class="overflow-x-auto flex-1">
    <div
      class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
    >
      <div class="w-2/12 text-center">Pos</div>
      <div class="w-6/12">Team</div>
      <div class="w-1/12">P</div>
      <div class="hidden sm:flex w-1/12 text-center">W</div>
      <div class="hidden sm:flex w-1/12 text-center">D</div>
      <div class="hidden sm:flex w-1/12 text-center">L</div>
      <div class="hidden sm:flex w-1/12 text-center">GF</div>
      <div class="hidden sm:flex w-1/12 text-center">GA</div>
      <div class="w-1/12">GD</div>
      <div class="w-1/12">PTS</div>
    </div>

    {#each tableData as team, idx}
      <div
        class="flex items-center justify-between py-4 border-b border-gray-700 cursor-pointer"
      >
        <div class="w-2/12 text-center">{idx + 1}</div>
        <a
          class="w-6/12 flex items-center justify-start"
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
        <div class="w-1/12">{team.played}</div>
        <div class="hidden sm:flex w-1/12">{team.wins}</div>
        <div class="hidden sm:flex w-1/12">{team.draws}</div>
        <div class="hidden sm:flex w-1/12">{team.losses}</div>
        <div class="hidden sm:flex w-1/12">{team.goalsFor}</div>
        <div class="hidden sm:flex w-1/12">{team.goalsAgainst}</div>
        <div class="w-1/12">
          {team.goalsFor - team.goalsAgainst}
        </div>
        <div class="w-1/12">{team.points}</div>
      </div>
    {/each}
    {#if Object.entries(tableData).length == 0}
      <p class="px-4 py-4">No table data.</p>
    {/if}
  </div>
</div>
