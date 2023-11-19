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
    import { formatUnixTimeToTime } from "../../utils/Helpers";
  
    type FixtureWithTeams = {
      fixture: Fixture;
      homeTeam: Team | undefined;
      awayTeam: Team | undefined;
    };
    const fixtureService = new FixtureService();
    const teamService = new TeamService();
    const systemService = new SystemService();

    export let clubId: number | null = null;
  
    let fixtures: FixtureWithTeams[] = [];
    let teams: Team[] = [];
    $: filteredFixtures = fixtures.filter(({ fixture }) =>
        (clubId == null || fixture.homeTeamId === clubId || fixture.awayTeamId === clubId)
    );
  
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
        
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    });
  
    function getTeamFromId(teamId: number): Team | undefined {
      return teams.find((team) => team.id === teamId);
    }
  </script>
  
  <div class="container-fluid mt-4">
    <div class="flex flex-col space-y-4">
      <div>
        {#each filteredFixtures as { fixture, homeTeam, awayTeam }}
          <div class={`flex items-center justify-between py-2 border-b border-gray-700  ${
            fixture.status === 0 ? "text-gray-400" : "text-white"
          }`}
          >
            <div class="flex items-center w-1/2 ml-4">
              <div class="flex w-1/2 space-x-4 justify-center">
                <div class="w-10 items-center justify-center">
                  <a href={`/club/${fixture.homeTeamId}`}>
                    <BadgeIcon
                      primaryColour={homeTeam
                        ? homeTeam.primaryColourHex
                        : ""}
                      secondaryColour={homeTeam
                        ? homeTeam.secondaryColourHex
                        : ""}
                      thirdColour={homeTeam ? homeTeam.thirdColourHex : ""}
                    />
                  </a>
                </div>
                <span class="font-bold text-lg">v</span>
                <div class="w-10 items-center justify-center">
                  <a href={`/club/${fixture.awayTeamId}`}>
                    <BadgeIcon
                      primaryColour={awayTeam
                        ? awayTeam.primaryColourHex
                        : ""}
                      secondaryColour={awayTeam
                        ? awayTeam.secondaryColourHex
                        : ""}
                      thirdColour={awayTeam ? awayTeam.thirdColourHex : ""}
                    />
                  </a>
                </div>
              </div>
              <div class="flex w-1/2 md:justify-center">
                <span class="text-sm md:text-lg ml-4 md:ml-0 text-left"
                  >{formatUnixTimeToTime(Number(fixture.kickOff))}</span
                >
              </div>
            </div>
            <div class="flex items-center space-x-10 w-1/2 md:justify-center">
              <div class='flex flex-col min-w-[120px] md:min-w-[300px] text-xs md:text-lg'>
                <a href={`/club/${fixture.homeTeamId}`}
                  >{homeTeam ? homeTeam.friendlyName : ""}</a
                >
                <a href={`/club/${fixture.awayTeamId}`}
                  >{awayTeam ? awayTeam.friendlyName : ""}</a
                >
              </div>
              <div class='flex flex-col min-w-[120px] md:min-w-[300px] text-xs md:text-lg'>
                <span>{fixture.status === 0 ? "-" : fixture.homeGoals}</span>
                <span>{fixture.status === 0 ? "-" : fixture.awayGoals}</span>
              </div>
            </div>
          </div>
        {/each}
      </div>
    </div>
  </div>
  