<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { seasonStore } from "$lib/stores/season-store";
  import { clubStore } from "$lib/stores/club-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
  import ViewDetailsIcon from "$lib/icons/ViewDetailsIcon.svelte";
  import PlayerGameweekModal from "./player-gameweek-modal.svelte";
  import type {
    ClubDTO,
    LeagueStatus,
    PlayerDetailDTO,
    PlayerGameweekDTO,
  } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import type { FixtureWithTeams } from "$lib/types/fixture-with-teams";
  import { playerEventsStore } from "$lib/stores/player-events-store";
    import { storeManager } from "$lib/managers/store-manager";
    import { leagueStore } from "$lib/stores/league-store";
    import { toasts } from "$lib/stores/toasts-store";
    import WidgetSpinner from "../shared/widget-spinner.svelte";

  let isLoading = true;
  let leagueStatus: LeagueStatus;
  let selectedGameweek: number;
  let fixturesWithTeams: FixtureWithTeams[] = [];
  let playerDetails: PlayerDetailDTO;
  let selectedOpponent: ClubDTO | null = null;
  let opponentCache = new Map<number, ClubDTO>();
  let selectedPlayerGameweek: PlayerGameweekDTO | null = null;
  let showModal: boolean = false;
  let seasonName = "";

  $: id = Number($page.url.searchParams.get("id"));

  onMount(async () => {
    try {
      await storeManager.syncStores();
      if(!$leagueStore){
        return
      };
      leagueStatus = $leagueStore;
      seasonName = await seasonStore.getSeasonName(leagueStatus.activeSeasonId ?? 0) ?? "";
      selectedGameweek = leagueStatus.activeGameweek == 0 ? leagueStatus.unplayedGameweek : leagueStatus.activeGameweek ?? 1;

      fixturesWithTeams = $fixtureStore.map((fixture) => ({
        fixture,
        homeTeam: getTeamFromId(fixture.homeClubId),
        awayTeam: getTeamFromId(fixture.awayClubId),
      }));

      playerDetails = await playerEventsStore.getPlayerDetails(
        id,
        leagueStatus.activeSeasonId ?? 1
      );
    } catch (error) {
      toasts.addToast({
        message:"Error fetching player gameweek history.",
        type: "error"
      });
      console.error("Error fetching player gameweek history:", error);
    } finally {
      isLoading = false;
    }
  });

  function getTeamFromId(teamId: number): ClubDTO | undefined {
    return $clubStore.find((team) => team.id === teamId);
  }

  function getOpponentFromFixtureId(fixtureId: number): ClubDTO {
    if (opponentCache.has(fixtureId)) {
      return opponentCache.get(fixtureId)!;
    }

    let fixture = fixturesWithTeams.find((f) => f.fixture.id === fixtureId);
    let opponentId =
      fixture?.homeTeam?.id === playerDetails.clubId
        ? fixture?.awayTeam?.id
        : fixture?.homeTeam?.id;

    let opponent = $clubStore.find((team) => team.id === opponentId);

    if (!opponent) {
      return {
        id: 0,
        secondaryColourHex: "",
        name: "",
        friendlyName: "",
        thirdColourHex: "",
        abbreviatedName: "",
        shirtType: { Filled: null },
        primaryColourHex: "",
      };
    }

    opponentCache.set(fixtureId, opponent);
    return opponent;
  }

  function showDetailModal(
    playerDetailsDTO: PlayerGameweekDTO,
    opponent: ClubDTO
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
  <WidgetSpinner />
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
      seasonName={seasonName};
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
