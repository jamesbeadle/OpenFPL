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
  import type {
    Season,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import type {
    PlayerDetailDTO,
    PlayerGameweekDTO,
  } from "../../../../declarations/player_canister/player_canister.did";
  import { playerEventsStore } from "$lib/stores/player-events-store";
    import { Spinner } from "@dfinity/gix-components";

  let isLoading = true;
  let selectedGameweek: number;
  let selectedSeason: Season | null = null;
  let fixturesWithTeams: FixtureWithTeams[] = [];
  let playerDetails: PlayerDetailDTO;
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
      fixture?.homeTeam?.id === playerDetails.teamId
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
    opponent: Team
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
      playerTeam={getTeamFromId(playerDetails.teamId) ?? null}
      {closeDetailModal}
      visible={showModal}
      playerDetail={playerDetails}
      gameweek={selectedGameweek}
      seasonName={selectedSeason?.name}
    />
  {/if}
  <div class="flex flex-col space-y-4 text-lg mt-4">
    <div class="overflow-x-auto flex-1">
      <div
        class="flex justify-between p-2 border border-gray-700 py-4 bg-light-gray"
      >
        <div class="w-1/4 px-4">Gameweek</div>
        <div class="w-1/4 px-4">Opponent</div>
        <div class="w-1/4 px-4">Points</div>
        <div class="w-1/4 px-4">&nbsp;</div>
      </div>

      {#each playerDetails.gameweeks as gameweek}
        {@const opponent = getOpponentFromFixtureId(gameweek.fixtureId)}
        <div
          class="flex items-center justify-between p-2 py-4 border-b border-gray-700 cursor-pointer"
        >
          <div class="w-1/4 px-4">{gameweek.number}</div>
          <div class="w-1/4 px-4">
            <a class="flex items-center" href={`/club?id=${opponent?.id}`}>
              <BadgeIcon
                className="w-6 mr-2"
                primaryColour={opponent?.primaryColourHex}
                secondaryColour={opponent?.secondaryColourHex}
                thirdColour={opponent?.thirdColourHex}
              />
              {opponent?.friendlyName}</a
            >
          </div>
          <div class="w-1/4 px-4">{gameweek.points}</div>
          <div class="w-1/4 px-4 flex items-center">
            <button on:click={() => showDetailModal(gameweek, opponent)}>
              <span class="flex items-center">
                <ViewDetailsIcon className="w-6 mr-2" />View Details
              </span>
            </button>
          </div>
        </div>
      {/each}
    </div>
  </div>
{/if}
