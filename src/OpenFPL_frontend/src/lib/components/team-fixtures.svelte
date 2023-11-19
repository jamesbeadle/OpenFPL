<script lang="ts">
    import { onMount } from "svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type {
      Fixture,
      Team,
    } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { FixtureService } from "$lib/services/FixtureService";
    import { TeamService } from "$lib/services/TeamService";
    import { formatUnixDateToReadable, formatUnixTimeToTime } from "../../utils/Helpers";
  
    type FixtureWithTeams = {
      fixture: Fixture;
      homeTeam: Team | undefined;
      awayTeam: Team | undefined;
    };
    const fixtureService = new FixtureService();
    const teamService = new TeamService();

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
        
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    });
  
    function getTeamFromId(teamId: number): Team | undefined {
      return teams.find((team) => team.id === teamId);
    }
  </script>
  
  <div class="container-fluid">
    <div class="flex flex-col space-y-4">
      <div>
        <div class='flex justify-between p-2 border border-gray-700 py-4 bg-light-gray px-4'>
          <div class="flex-grow w-1/6">Gameweek</div>
          <div class="flex-grow w-1/3 text-center">Game</div>
          <div class="flex-grow w-1/3">Date</div>
          <div class="flex-grow w-1/4 text-center">Time</div>
          <div class="flex-grow w-1/3">Teams</div>
          <div class="flex-grow w-1/4">Result</div>
        </div>
      
        {#each filteredFixtures as { fixture, homeTeam, awayTeam }}
          <div class={`flex items-center justify-between border-b border-gray-700 p-2 px-4 ${
            fixture.status === 0 ? "text-gray-400" : "text-white"}`}>
              <div class="w-1/6">{fixture.gameweek}</div>
              <div class="w-1/3 flex justify-center">  
                <div class="w-10 items-center justify-center mr-4">
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
                <div class="w-10 items-center justify-center ml-4">
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
              
              <div class="w-1/3">{formatUnixDateToReadable(Number(fixture.kickOff))}</div>
              <div class="w-1/4 text-center">{formatUnixTimeToTime(Number(fixture.kickOff))}</div>
              <div class="w-1/3">
                <div class='flex flex-col text-xs md:text-lg'>
                  <a href={`/club/${fixture.homeTeamId}`}>{homeTeam ? homeTeam.friendlyName : ""}</a>
                  <a href={`/club/${fixture.awayTeamId}`}>{awayTeam ? awayTeam.friendlyName : ""}</a>
                </div>
              </div>
              <div class="w-1/4">
                <div class='flex flex-col text-xs md:text-lg'>
                  <span>{fixture.status === 0 ? "-" : fixture.homeGoals}</span>
                  <span>{fixture.status === 0 ? "-" : fixture.awayGoals}</span>
                </div>
              </div>
          </div>
        {/each}
      </div>
    </div>
  </div>
  