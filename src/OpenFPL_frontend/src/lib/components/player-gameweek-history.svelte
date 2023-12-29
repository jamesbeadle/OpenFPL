<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { systemStore } from "$lib/stores/system-store";
  import { toastsError } from "$lib/stores/toasts-store";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import PlayerGameweekModal from "./player-gameweek-modal.svelte";
  import type { ClubId } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import { Spinner } from "@dfinity/gix-components";

  let isLoading = true;
  let selectedGameweek: number;
  let selectedSeason: Season | null = null;
  let fixturesWithTeams: FixtureWithTeams[] = [];
  let playerDetails: PlayerDeta;
  let selectedOpponent: Team | null = null;
  let opponentCache = new Map<number, Team>();
  let selectedPlayerGameweek: PlayerGameweekDTO | null = null;
  let showModal: boolean = false;

  $: id = Number($page.url.searchParams.get("id"));

  onMount(async () => {
    try {
      await teamStore.sync();
      await fixtureStore.sync();
      await systemStore.sync();
      await playerEventsStore.sync;
      selectedGameweek = $systemStore?.activeGameweek ?? 1;
      selectedSeason = $systemStore?.activeSeason ?? null;

      fixturesWithTeams = $fixtureStore.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeTeamId),
        awayTeam: getTeamFromId(fixture.awayTeamId),
      }));

      playerDetails = await playerEventsStore.getPlayerDetails(
        id,
        $systemStore?.activeSeason.id ?? 0
      );
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching player gameweek history." },
        err: error,
      });
      console.error("Error fetching player gameweek history:", error);
    } finally {
      isLoading = false;
    }
  });

  function getTeamFromId(teamId: number): Team | undefined {
    return $teamStore.find((team) => team.id === teamId);
  }

  function getOpponentFromFixtureId(fixtureId: number): Team {
    if (opponentCache.has(fixtureId)) {
      return opponentCache.get(fixtureId)!;
    }

    let fixture = fixturesWithTeams.find((f) => f.fixture.id === fixtureId);
    let opponentId =
      fixture?.homeTeam?.id === playerDetails.clubId
        ? fixture?.awayTeam?.id
        : fixture?.homeTeam?.id;

    let opponent = $teamStore.find((team) => team.id === opponentId);

    if (!opponent) {
      return {
        id: 0,
        secondaryColourHex: "",
        name: "",
        friendlyName: "",
        thirdColourHex: "",
        abbreviatedName: "",
        shirtType: 0,
        primaryColourHex: "",
      };
    }

    opponentCache.set(fixtureId, opponent);
    return opponent;
  }

  function showDetailModal(
    playerDetailsDTO: PlayerGameweekDTO,
    opponent: ClubId
  ): void {
    selectedPlayerGameweek = playerDetailsDTO;
    selectedOpponent = opponent;
    showModal = true;
  }

  function closeDetailModal(): void {
    selectedPlayerGameweek = null;
    showModal = false;
  }
</script>

{#if isLoading}
  <Spinner />
{:else}
  {#if playerDetails}
    <PlayerGameweekModal
      gameweekDetail={playerDetails.gameweeks.find(
        (x) => x.number === selectedGameweek
      ) ?? null}
      opponentTeam={selectedOpponent}
      playerTeam={getTeamFromId(playerDetails.clubId) ?? null}
      {closeDetailModal}
      visible={showModal}
      playerDetail={playerDetails}
      gameweek={selectedGameweek}
      seasonName={selectedSeason?.name}
    />
  {/if}
  <div class="flex flex-col space-y-4 mt-4">
    <div class="overflow-x-auto flex-1">
      <div
        class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
      >
        <div class="w-1/4 hidden md:flex px-4">Gameweek</div>
        <div class="w-1/6 md:hidden px-4">GW</div>
        <div class="w-2/6 md:w-1/4 px-4">Opponent</div>
        <div class="md:w-1/4 hidden md:flex px-4">Points</div>
        <div class="w-1/6 md:w-1/4 md:hidden px-4">Pts</div>
        <div class="w-2/6 md:w-1/4 px-4">&nbsp;</div>
      </div>

      {#each playerDetails.gameweeks as gameweek}
        {@const opponent = getOpponentFromFixtureId(gameweek.fixtureId)}
        <button
          class="w-full flex items-center justify-between p-2 py-4 border-b border-gray-700 cursor-pointer"
          on:click={() => showDetailModal(gameweek, opponent)}
        >
          <div class="w-1/6 md:w-1/4 px-4">{gameweek.number}</div>
          <div class="w-2/6 md:w-1/4 md:w-1/6 px-4">
            <div class="flex items-center">
              <BadgeIcon
                className="w-6 mr-2"
                primaryColour={opponent?.primaryColourHex}
                secondaryColour={opponent?.secondaryColourHex}
                thirdColour={opponent?.thirdColourHex}
              />
              {opponent?.friendlyName}
            </div>
          </div>
          <div class="w-1/6 md:w-1/4 px-4">{gameweek.points}</div>
          <div class="w-2/6 md:w-1/4 px-4 flex items-center">
            <span class="flex items-center">
              <ViewDetailsIcon className="w-6 mr-2" />View Details
            </span>
          </div>
        </button>
      {/each}
    </div>
  </div>
{/if}
