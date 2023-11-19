<script lang="ts">
  import { onMount } from "svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import type {
    Fixture,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { SystemService } from "$lib/services/SystemService";
  import { FixtureService } from "$lib/services/FixtureService";
  import { TeamService } from "$lib/services/TeamService";
  import type { TeamStats } from "$lib/types/TeamStats";

  type FixtureWithTeams = {
    fixture: Fixture;
    homeTeam: Team | undefined;
    awayTeam: Team | undefined;
  };
  const fixtureService = new FixtureService();
  const teamService = new TeamService();
  const systemService = new SystemService();

  let selectedGameweek: number = 1;
  let fixtures: FixtureWithTeams[] = [];
  let teams: Team[] = [];
  let gameweeks = Array.from({ length: 38 }, (_, i) => i + 1);
  
  let tableData: any[] = [];


  onMount(async () => {
    try {
      const fetchedFixtures = await fixtureService.getFixturesData(
        localStorage.getItem("fixtures_hash") ?? ""
      );
      const fetchedTeams = await teamService.getTeamsData(
        localStorage.getItem("teams_hash") ?? ""
      );

      teams = fetchedTeams;
      fixtures = fetchedFixtures.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeTeamId),
        awayTeam: getTeamFromId(fixture.awayTeamId),
      }));
      let systemState = await systemService.getSystemState(
        localStorage.getItem("system_state_hash") ?? ""
      );
      selectedGameweek = systemState.activeGameweek;
    } catch (error) {
      console.error("Error fetching data:", error);
    }
  });

  const initTeamData = (teamId: number, table: Record<number, TeamStats>) => {
    if (!table[teamId]) {
      const team = teams.find(t => t.id === teamId);
      if (team) {
        table[teamId] = {
          ...team,
          played: 0,
          wins: 0,
          draws: 0,
          losses: 0,
          goalsFor: 0,
          goalsAgainst: 0,
          points: 0
        };
      }
    }
  };


  const updateTableData = () => {
  let tempTable: Record<number, TeamStats> = {};

  // Initialize data for all teams
  teams.forEach(team => initTeamData(team.id, tempTable));

  // Process each fixture and update team statistics
  const relevantFixtures = fixtures.filter(fixture => fixture.fixture.status === 3 && fixture.fixture.gameweek <= selectedGameweek);

  relevantFixtures.forEach(({ fixture, homeTeam, awayTeam }) => {
    if (!homeTeam || !awayTeam) return;

    initTeamData(homeTeam.id, tempTable);
    initTeamData(awayTeam.id, tempTable);

    const homeStats = tempTable[homeTeam.id];
    const awayStats = tempTable[awayTeam.id];

    homeStats.played++;
    awayStats.played++;

    homeStats.goalsFor += fixture.homeGoals;
    homeStats.goalsAgainst += fixture.awayGoals;
    awayStats.goalsFor += fixture.awayGoals;
    awayStats.goalsAgainst += fixture.homeGoals;

    if (fixture.homeGoals > fixture.awayGoals) {
      homeStats.wins++;
      homeStats.points += 3;
      awayStats.losses++;
    } else if (fixture.homeGoals === fixture.awayGoals) {
      homeStats.draws++;
      awayStats.draws++;
      homeStats.points += 1;
      awayStats.points += 1;
    } else {
      awayStats.wins++;
      awayStats.points += 3;
      homeStats.losses++;
    }
  });

  // Sort teams by points, goal difference, goals for, and goals against
  tableData = Object.values(tempTable).sort((a, b) => {
    const goalDiffA = a.goalsFor - a.goalsAgainst;
    const goalDiffB = b.goalsFor - b.goalsAgainst;

    if (b.points !== a.points) return b.points - a.points;
    if (goalDiffB !== goalDiffA) return goalDiffB - goalDiffA;
    if (b.goalsFor !== a.goalsFor) return b.goalsFor - a.goalsFor;
    return a.goalsAgainst - b.goalsAgainst;
  });
};


  // Reactive statement to update the league table
  $: if (fixtures.length > 0 && teams.length > 0) {
    updateTableData();
  }


  const changeGameweek = (delta: number) => {
    selectedGameweek = Math.max(1, Math.min(38, selectedGameweek + delta));
  };

  function getTeamFromId(teamId: number): Team | undefined {
    return teams.find((team) => team.id === teamId);
  }

</script>

<div class="container-fluid mt-4">
  <div class="flex flex-col space-y-4">
    <div class="flex flex-col sm:flex-row gap-4 sm:gap-8">
      <div class="flex items-center space-x-2 ml-4">
        <button
          class="text-2xl rounded fpl-button px-2 py-1"
          on:click={() => changeGameweek(-1)}
          disabled={selectedGameweek === 1}
        >
          &lt;
        </button>

        <select
          class="p-2 fpl-dropdown text-sm md:text-xl text-center"
          bind:value={selectedGameweek}
        >
          {#each gameweeks as gameweek}
            <option value={gameweek}>Gameweek {gameweek}</option>
          {/each}
        </select>

        <button
          class="text-2xl rounded fpl-button px-2 py-1"
          on:click={() => changeGameweek(1)}
          disabled={selectedGameweek === 38}
        >
          &gt;
        </button>
      </div>

      <div class="overflow-x-auto">
        <!-- Table Header -->
        <div class='flex justify-between bg-gray-200 p-2'>
          <div class="w-12 text-center">Pos</div>
          <div class="flex-1 text-center">Team</div>
          <div class="w-12 text-center">P</div>
          <div class="w-12 text-center">W</div>
          <div class="w-12 text-center">D</div>
          <div class="w-12 text-center">L</div>
          <div class="w-12 text-center">GF</div>
          <div class="w-12 text-center">GA</div>
          <div class="w-12 text-center">GD</div>
          <div class="w-12 text-center">PTS</div>
        </div>
  
        <!-- Table Rows -->
        {#each tableData as team, idx}
          <div class="flex justify-between items-center p-2 hover:bg-gray-100 cursor-pointer">
              <div class="w-12 text-center">{idx + 1}</div>
              <div class="flex-1 flex items-center justify-start space-x-2">
                <a href={`/club?id=${team.id}`}>
                  
                  <BadgeIcon
                  primaryColour={team.primaryColourHex}
                  secondaryColour={team.secondaryColourHex}
                  thirdColour={team.thirdColourHex}
                  className='w-6 h-6'
                />
                {team.friendlyName}
                </a>
              </div>
              <div class="w-12 text-center">{team.played}</div>
              <div class="w-12 text-center">{team.wins}</div>
              <div class="w-12 text-center">{team.draws}</div>
              <div class="w-12 text-center">{team.losses}</div>
              <div class="w-12 text-center">{team.goalsFor}</div>
              <div class="w-12 text-center">{team.goalsAgainst}</div>
              <div class="w-12 text-center">{team.goalsFor - team.goalsAgainst}</div>
              <div class="w-12 text-center">{team.points}</div>
              
          </div>
        {/each}
      </div>
    </div>
  </div>
</div>
