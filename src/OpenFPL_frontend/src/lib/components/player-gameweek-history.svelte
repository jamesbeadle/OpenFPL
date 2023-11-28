<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { page } from "$app/stores";
  import { systemStore } from "$lib/stores/system-store";
  import { toastStore } from "$lib/stores/toast-store";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";
  import PlayerGameweekModal from "./player-gameweek-modal.svelte";
  import type {
    Season,
    SystemState,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/FixtureWithTeams";
  import type {
    Fixture,
    PlayerDetailDTO,
    PlayerGameweekDTO,
  } from "../../../../declarations/player_canister/player_canister.did";
  import { playerStore } from "$lib/stores/player-store";

  let isLoading = true;
  let teams: Team[] = [];
  let fixtures: Fixture[] = [];
  let systemState: SystemState | null;
  let selectedGameweek: number = 1;
  let selectedSeason: Season | null = null;
  let fixturesWithTeams: FixtureWithTeams[] = [];
  let playerDetails: PlayerDetailDTO;
  let selectedOpponent: Team | null = null;
  let opponentCache = new Map<number, Team>();
  let selectedPlayerGameweek: PlayerGameweekDTO | null = null;
  let showModal: boolean = false;

  let unsubscribeTeams: () => void;
  let unsubscribeFixtures: () => void;
  let unsubscribeSystemState: () => void;

  $: id = Number($page.url.searchParams.get("id"));

  onMount(async () => {
    try {
      await teamStore.sync();
      await fixtureStore.sync();
      await systemStore.sync();

      unsubscribeTeams = teamStore.subscribe((value) => {
        teams = value;
      });

      unsubscribeFixtures = fixtureStore.subscribe((value) => {
        fixtures = value;
        fixturesWithTeams = fixtures.map((fixture) => ({
          fixture,
          homeTeam: getTeamFromId(fixture.homeTeamId),
          awayTeam: getTeamFromId(fixture.awayTeamId),
        }));
      });

      unsubscribeSystemState = systemStore.subscribe((value) => {
        systemState = value;
      });

      playerDetails = await playerStore.getPlayerDetails(
        id,
        systemState?.activeSeason.id ?? 0
      );
      selectedGameweek = systemState?.activeGameweek ?? selectedGameweek;
      selectedSeason = systemState?.activeSeason ?? selectedSeason;
    } catch (error) {
      toastStore.show("Error fetching player gameweek history.", "error");
      console.error("Error fetching player gameweek history:", error);
    } finally {
      isLoading = false;
    }
  });

  onDestroy(() => {
    unsubscribeTeams?.();
    unsubscribeFixtures?.();
    unsubscribeSystemState?.();
  });

  function getTeamFromId(teamId: number): Team | undefined {
    return teams.find((team) => team.id === teamId);
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

    let opponent = teams.find((team) => team.id === opponentId);

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
  <LoadingIcon />
{:else}
  {#if playerDetails}
    <PlayerGameweekModal
      gameweekDetail={playerDetails.gameweeks.find(
        (x) => x.number === selectedGameweek
      ) ?? null}
      opponentTeam={selectedOpponent}
      playerTeam={getTeamFromId(playerDetails.teamId) ?? null}
      {closeDetailModal}
      {showModal}
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
          <div class="w-1/4 px-4 flex items-center">
            <BadgeIcon
              className="w-6 mr-2"
              primaryColour={opponent?.primaryColourHex}
              secondaryColour={opponent?.secondaryColourHex}
              thirdColour={opponent?.thirdColourHex}
            />
            {opponent?.friendlyName}
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
