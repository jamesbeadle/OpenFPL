<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/state";
  import { writable } from "svelte/store";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { seasonStore } from "$lib/stores/season-store";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { playerEventsStore } from "$lib/stores/player-events-store";
  import type { ClubDTO, PlayerDetailDTO, PlayerGameweekDTO } from "../../../../../external_declarations/data_canister/data_canister.did";
  import type { FixtureWithClubs } from "$lib/types/fixture-with-clubs";
  import { getFixturesWithTeams } from "$lib/utils/helpers";
  import PlayerGameweekModal from "./player-gameweek-modal.svelte";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import WidgetSpinner from "../shared/widget-spinner.svelte";
  import PlayerGameweekHistoryHeader from "./player-gameweek-history-header.svelte";
  
  let isLoading = true;
  let selectedGameweek = writable(1);
  let fixturesWithTeams: FixtureWithClubs[] = [];
  let playerDetails: PlayerDetailDTO;
  let selectedOpponent: ClubDTO | null = null;
  let selectedPlayerGameweek: PlayerGameweekDTO | null = null;
  let showModal: boolean = false;
  let seasonName = "";

  $: id = Number(page.url.searchParams.get("id"));

  onMount(async () => {
    await storeManager.syncStores();
      seasonName = await seasonStore.getSeasonName($leagueStore!.activeSeasonId ?? 0) ?? "";
      fixturesWithTeams = getFixturesWithTeams($clubStore, $fixtureStore);
      $selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore!.activeGameweek;
      let playerDetailsResult = await playerEventsStore.getPlayerDetails(id, $leagueStore!.activeSeasonId);
      playerDetails = playerDetailsResult ? playerDetailsResult : playerDetails;
      isLoading = false;
  });

  function getOpponentFromFixtureId(fixtureId: number): ClubDTO {
    let fixture = fixturesWithTeams.find((f) => f.fixture.id === fixtureId);
    let opponentId = fixture?.homeClub?.id === playerDetails.clubId ? fixture?.awayClub?.id : fixture?.homeClub?.id;
    return $clubStore.find((team) => team.id === opponentId)!;
  }

  function showDetailModal(playerDetailsDTO: PlayerGameweekDTO, opponent: ClubDTO): void {
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
  <WidgetSpinner />
{:else}
  {#if playerDetails}
  {#if showModal}
    <PlayerGameweekModal
      gameweekDetail={playerDetails.gameweeks.find(
        (x) => x.number === $selectedGameweek
      ) ?? null}
      opponentTeam={selectedOpponent}
      playerTeam={$clubStore.find((team) => team.id === playerDetails.clubId)}
      {closeDetailModal}
      bind:visible={showModal}
      playerDetail={playerDetails}
      gameweek={$selectedGameweek}
      seasonName={seasonName};
    />
    {/if}
  {/if}
  <div class="flex flex-col">
    <div class="flex-1 overflow-x-auto">
      <PlayerGameweekHistoryHeader />
      {#each playerDetails.gameweeks as gameweek}
        {@const opponent = getOpponentFromFixtureId(gameweek.fixtureId)}
        <button
          class="flex items-center justify-between w-full p-2 py-4 border-b border-gray-700 cursor-pointer"
          on:click={() => showDetailModal(gameweek, opponent)}
        >
          <div class="w-1/6 px-4 md:w-1/4">{gameweek.number}</div>
          <div class="w-2/6 px-4 md:w-1/4 md:w-1/6">
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