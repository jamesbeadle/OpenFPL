<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/state";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { seasonStore } from "$lib/stores/season-store";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";
  import { getFixturesWithTeams } from "$lib/utils/helpers";
  import PlayerGameweekModal from "./player-gameweek-modal.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import PlayerGameweekHistoryHeader from "./player-gameweek-history-header.svelte";
  import LocalSpinner from "../shared/global/local-spinner.svelte";
  import type { Club, PlayerDetails, PlayerGameweek } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  let isLoading = $state(true);
  let selectedGameweek = $state(1);
  let fixturesWithTeams: FixtureWithClubs[] = [];
  let playerDetails: PlayerDetails | undefined = $state(undefined);
  let selectedOpponent: Club | null = $state(null);
  let selectedPlayerGameweek: PlayerGameweek | null = $state(null);
  let showModal: boolean = $state(false);
  let seasonName = $state("");
  let id = Number(page.url.searchParams.get("id"));

  onMount(async () => {
    await storeManager.syncStores();
      seasonName = await seasonStore.getSeasonName($leagueStore!.activeSeasonId ?? 0) ?? "";
      fixturesWithTeams = getFixturesWithTeams($clubStore, $fixtureStore);
      selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek;
      let playerDetailsResult = await playerEventsStore.getPlayerDetails(id, $leagueStore!.activeSeasonId);
      playerDetails = playerDetailsResult ? playerDetailsResult : playerDetails;
      isLoading = false;
  });

  function getOpponentFromFixtureId(fixtureId: number): Club {
    let fixture = fixturesWithTeams.find((f) => f.fixture.id === fixtureId);
    let opponentId = fixture?.homeClub?.id === playerDetails!.player.clubId ? fixture?.awayClub?.id : fixture?.homeClub?.id;
    return $clubStore.find((team) => team.id === opponentId)!;
  }

  function showDetailModal(playerDetailsDTO: PlayerGameweek, opponent: Club): void {
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
  <LocalSpinner />
{:else}
  {#if playerDetails}
  {#if showModal}
    <PlayerGameweekModal
      gameweekDetail={playerDetails.player.gameweeks.find(
        (x) => x.number === selectedGameweek
      ) ?? null}
      opponentTeam={selectedOpponent}
      playerTeam={$clubStore.find((team) => team.id === playerDetails!.player.clubId)}
      {closeDetailModal}
      visible={showModal}
      playerDetail={playerDetails}
      gameweek={selectedGameweek}
      {seasonName}
    />
    {/if}
  {/if}
  <div class="flex flex-col">
    <div class="flex-1 overflow-x-auto">
      <PlayerGameweekHistoryHeader />
      {#each playerDetails!.player.gameweeks as gameweek}
        {@const opponent = getOpponentFromFixtureId(gameweek.fixtureId)}
        <button
          class="flex items-center justify-between w-full p-2 py-4 border-b border-gray-700 cursor-pointer"
          onclick={() => showDetailModal(gameweek, opponent)}
        >
          <div class="w-1/6 px-4 md:w-1/4">{gameweek.number}</div>
          <div class="w-2/6 px-4 md:w-1/4">
            <div class="flex items-center">
              <BadgeIcon className="w-6 mr-2" club={opponent!} /> {opponent?.friendlyName}
            </div>
          </div>
          <div class="w-1/6 px-4 md:w-1/4">{gameweek.points}</div>
          <div class="flex items-center w-2/6 px-4 md:w-1/4">
            <span class="flex items-center">
              <ViewDetailsIcon className="w-6 mr-2" />View Details
            </span>
          </div>
        </button>
      {/each}
    </div>
  </div>
{/if}