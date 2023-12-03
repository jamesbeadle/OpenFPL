<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { page } from "$app/stores";
  import { goto } from "$app/navigation";
  import { writable } from "svelte/store";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import { loadingText } from "$lib/stores/global-stores";
  import type {
    PlayerDTO,
    PlayerEventData,
  } from "../../../../declarations/player_canister/player_canister.did";
  import type {
    Fixture,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { replacer } from "$lib/utils/Helpers";
  import Layout from "../Layout.svelte";
  import PlayerEventsModal from "$lib/components/fixture-validation/player-events-modal.svelte";
  import SelectPlayersModal from "$lib/components/fixture-validation/select-players-modal.svelte";
  import ConfirmFixtureDataModal from "$lib/components/fixture-validation/confirm-fixture-data-modal.svelte";
  import ClearDraftModal from "$lib/components/fixture-validation/clear-draft-modal.svelte";
  import { playerStore } from "$lib/stores/player-store";
  import LoadingIcon from "$lib/icons/LoadingIcon.svelte";

  $: fixtureId = Number($page.url.searchParams.get("id"));

  let teams: Team[] = [];
  let players: PlayerDTO[] = [];
  let fixture: Fixture | null;
  let homeTeam: Team | null;
  let awayTeam: Team | null;

  let showPlayerSelectionModal = false;
  let showPlayerEventModal = false;
  let showClearDraftModal = false;
  let showConfirmDataModal = false;

  let teamPlayers = writable<PlayerDTO[] | []>([]);
  let selectedPlayers = writable<PlayerDTO[] | []>([]);

  let selectedTeam: Team | null = null;
  let selectedPlayer: PlayerDTO | null = null;
  let playerEventData = writable<PlayerEventData[] | []>([]);
  let activeTab: string = "home";

  let isSubmitDisabled: boolean = true;
  $: isSubmitDisabled =
    $playerEventData.length == 0 ||
    $playerEventData.filter((x) => x.eventType == 0).length !=
      $selectedPlayers.length;

  let isLoading = true;

  onMount(async () => {
    try {
      await teamStore.sync();
      await fixtureStore.sync();
      await playerStore.sync();

      teamStore.subscribe((value) => {
        teams = value;
      });

      playerStore.subscribe((value) => {
        players = value;
      });

      fixtureStore.subscribe((value) => {
        fixture = value.find((x) => x.id == fixtureId)!;
        homeTeam = teams.find((x) => x.id == fixture?.homeTeamId)!;
        awayTeam = teams.find((x) => x.id == fixture?.awayTeamId)!;
        selectedTeam = homeTeam;
        teamPlayers.set(players.filter((x) => x.teamId == selectedTeam?.id));
      });

      const draftKey = `fixtureDraft_${fixtureId}`;
      const savedDraft = localStorage.getItem(draftKey);
      if (savedDraft) {
        const draftData = JSON.parse(savedDraft);
        let draftEventData = draftData.playerEventData;
        if (draftEventData) {
          playerEventData.set(draftEventData);
          updateSelectedPlayers();
        }
      }
    } catch (error) {
      toastsError({
        msg: { text: "Error fetching fixture information." },
        err: error,
      });
      console.error("Error fetching fixture information.", error);
    } finally {
      isLoading = false;
    }
  });

  onDestroy(() => {});

  async function confirmFixtureData() {
    isLoading = true;
    $loadingText = "Saving Fixture Data";
    try {
      await governanceStore.submitFixtureData(fixtureId, $playerEventData);
      localStorage.removeItem(`fixtureDraft_${fixtureId}`);
      toastsShow({
        text: "Fixture data saved.",
        level: "success",
        duration: 2000,
      });
      goto("/fixture-validation");
    } catch (error) {
      toastsError({
        msg: { text: "Error saving fixture data." },
        err: error,
      });
      console.error("Error saving fixture data: ", error);
    } finally {
      isLoading = false;
      $loadingText = "Loading";
    }
  }

  function updateSelectedPlayers() {
    const uniquePlayerIds = new Set(
      $playerEventData.map((event) => event.playerId)
    );
    const selectedPlayerObjects = players.filter((player) =>
      uniquePlayerIds.has(player.id)
    );
    selectedPlayers.set(selectedPlayerObjects);
  }

  function saveDraft() {
    const draftData = {
      playerEventData: $playerEventData,
    };
    const draftKey = `fixtureDraft_${fixtureId}`;
    localStorage.setItem(draftKey, JSON.stringify(draftData, replacer));
    toastsShow({
      text: "Draft saved.",
      level: "success",
      duration: 2000,
    });
  }

  function clearDraft() {
    playerEventData = writable<PlayerEventData[] | []>([]);
    localStorage.removeItem(`fixtureDraft_${fixtureId}`);
    toastsShow({
      text: "Draft cleared.",
      level: "success",
      duration: 2000,
    });
    closeConfirmClearDraftModal();
  }

  async function setActiveTab(tab: string) {
    await playerStore.sync();
    selectedTeam = tab === "home" ? homeTeam : awayTeam;
    teamPlayers.set(players.filter((x) => x.teamId == selectedTeam?.id));
    activeTab = tab;
  }

  function handleEditPlayerEvents(player: PlayerDTO) {
    selectedPlayer = player;
    showPlayerEventModal = true;
  }

  function closeEventPlayerEventsModal(): void {
    showPlayerEventModal = false;
    selectedPlayer = null;
  }

  function showSelectPlayersModal(): void {
    showPlayerSelectionModal = true;
  }

  function closeSelectPlayersModal(): void {
    showPlayerSelectionModal = false;
  }

  function showConfirmClearDraftModal(): void {
    showClearDraftModal = true;
  }

  function closeConfirmClearDraftModal(): void {
    showClearDraftModal = false;
  }
</script>

<Layout>
  {#if isLoading}
    <LoadingIcon />
  {:else}
    <div class="container-fluid mx-4 md:mx-16 mt-4 bg-panel">
      <div class="flex flex-col text-xs md:text-base mt-4">
        <div class="flex flex-row space-x-2 p-4">
          <button class="fpl-button px-4 py-2" on:click={showSelectPlayersModal}
            >Select Players</button
          >
          <button class="fpl-button px-4 py-2" on:click={saveDraft}
            >Save Draft</button
          >
          <button
            class="fpl-button px-4 py-2"
            on:click={showConfirmClearDraftModal}>Clear Draft</button
          >
        </div>
        <div class="flex w-full">
          <ul class="flex bg-light-gray px-4 pt-2 w-full mt-4">
            <li
              class={`mr-4 text-xs md:text-base ${
                activeTab === "home" ? "active-tab" : ""
              }`}
            >
              <button
                class={`p-2 ${
                  activeTab === "home" ? "text-white" : "text-gray-400"
                }`}
                on:click={() => setActiveTab("home")}
                >{homeTeam?.friendlyName}</button
              >
            </li>
            <li
              class={`mr-4 text-xs md:text-base ${
                activeTab === "away" ? "active-tab" : ""
              }`}
            >
              <button
                class={`p-2 ${
                  activeTab === "away" ? "text-white" : "text-gray-400"
                }`}
                on:click={() => setActiveTab("away")}
                >{awayTeam?.friendlyName}</button
              >
            </li>
          </ul>
        </div>
        <div class="flex w-full flex-col">
          <div
            class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer w-full"
          >
            <div class="w-1/6 px-4">Player</div>
            <div class="w-1/6 px-4">Position</div>
            <div class="w-1/6 px-4">Events</div>
            <div class="w-1/6 px-4">Start</div>
            <div class="w-1/6 px-4">End</div>
            <div class="w-1/6 px-4">&nbsp;</div>
          </div>
          {#if activeTab === "home"}
            {#each $selectedPlayers.filter((x) => x.teamId === fixture?.homeTeamId) as player (player.id)}
              <div
                class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer w-full"
              >
                <div class="w-1/6 px-4">
                  {`${
                    player.firstName.length > 0
                      ? player.firstName.charAt(0) + "."
                      : ""
                  } ${player.lastName}`}
                </div>
                {#if player.position == 0}<div class="w-1/6 px-4">GK</div>{/if}
                {#if player.position == 1}<div class="w-1/6 px-4">DF</div>{/if}
                {#if player.position == 2}<div class="w-1/6 px-4">MF</div>{/if}
                {#if player.position == 3}<div class="w-1/6 px-4">FW</div>{/if}
                <div class="w-1/6 px-4">
                  Events:
                  {$playerEventData?.length > 0 &&
                  $playerEventData?.filter((e) => e.playerId === player.id)
                    .length
                    ? $playerEventData?.filter((e) => e.playerId === player.id)
                        .length
                    : 0}
                </div>
                <div class="w-1/6 px-4">
                  {$playerEventData &&
                  $playerEventData?.length > 0 &&
                  $playerEventData?.find(
                    (e) => e.playerId === player.id && e.eventType == 0
                  )
                    ? $playerEventData?.find(
                        (e) => e.playerId === player.id && e.eventType == 0
                      )?.eventStartMinute
                    : "-"}
                </div>
                <div class="w-1/6 px-4">
                  {$playerEventData &&
                  $playerEventData?.length > 0 &&
                  $playerEventData?.find(
                    (e) => e.playerId === player.id && e.eventType == 0
                  )
                    ? $playerEventData?.find(
                        (e) => e.playerId === player.id && e.eventType == 0
                      )?.eventEndMinute
                    : "-"}
                </div>
                <div class="w-1/6 px-4">
                  <button
                    on:click={() => handleEditPlayerEvents(player)}
                    class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
                  >
                    Update Events
                  </button>
                </div>
              </div>
            {/each}
          {/if}
          {#if activeTab === "away"}
            {#each $selectedPlayers.filter((x) => x.teamId === fixture?.awayTeamId) as player (player.id)}
              <div
                class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer w-full"
              >
                <div class="w-1/6 px-4">
                  {`${
                    player.firstName.length > 0
                      ? player.firstName.charAt(0) + "."
                      : ""
                  } ${player.lastName}`}
                </div>
                {#if player.position == 0}<div class="w-1/6 px-4">GK</div>{/if}
                {#if player.position == 1}<div class="w-1/6 px-4">DF</div>{/if}
                {#if player.position == 2}<div class="w-1/6 px-4">MF</div>{/if}
                {#if player.position == 3}<div class="w-1/6 px-4">FW</div>{/if}
                <div class="w-1/6 px-4">
                  Events:
                  {$playerEventData?.length > 0 &&
                  $playerEventData?.filter((e) => e.playerId === player.id)
                    .length
                    ? $playerEventData?.filter((e) => e.playerId === player.id)
                        .length
                    : 0}
                </div>
                <div class="w-1/6 px-4">
                  {$playerEventData &&
                  $playerEventData?.length > 0 &&
                  $playerEventData?.find(
                    (e) => e.playerId === player.id && e.eventType == 0
                  )
                    ? $playerEventData?.find((e) => e.playerId === player.id)
                        ?.eventStartMinute
                    : "-"}
                </div>
                <div class="w-1/6 px-4">
                  {$playerEventData &&
                  $playerEventData?.length > 0 &&
                  $playerEventData?.find(
                    (e) => e.playerId === player.id && e.eventType == 0
                  )
                    ? $playerEventData?.find((e) => e.playerId === player.id)
                        ?.eventEndMinute
                    : "-"}
                </div>
                <div class="w-1/6 px-4">
                  <button
                    on:click={() => handleEditPlayerEvents(player)}
                    class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
                  >
                    Update Events
                  </button>
                </div>
              </div>
            {/each}
          {/if}
        </div>
        <div class="flex w-full m-4">
          <h1>Summary</h1>
        </div>
        <div class="flex flex-row w-full m-4">
          <div class="text-sm font-medium flex-grow">
            Appearances: {$playerEventData.filter((x) => x.eventType == 0)
              .length}
          </div>
          <div class="text-sm font-medium flex-grow">
            Goals: {$playerEventData.filter((x) => x.eventType == 1).length}
          </div>
          <div class="text-sm font-medium flex-grow">
            Own Goals: {$playerEventData.filter((x) => x.eventType == 10)
              .length}
          </div>
          <div class="text-sm font-medium flex-grow">
            Assists: {$playerEventData.filter((x) => x.eventType == 2).length}
          </div>
          <div class="text-sm font-medium flex-grow">
            Keeper Saves: {$playerEventData.filter((x) => x.eventType == 4)
              .length}
          </div>
          <div class="text-sm font-medium flex-grow">
            Yellow Cards: {$playerEventData.filter((x) => x.eventType == 8)
              .length}
          </div>
          <div class="text-sm font-medium flex-grow">
            Red Cards: {$playerEventData.filter((x) => x.eventType == 9).length}
          </div>
          <div class="text-sm font-medium flex-grow">
            Penalties Saved: {$playerEventData.filter((x) => x.eventType == 6)
              .length}
          </div>
          <div class="text-sm font-medium flex-grow">
            Penalties Missed: {$playerEventData.filter((x) => x.eventType == 7)
              .length}
          </div>
        </div>

        <div class="items-center mt-3 flex space-x-4">
          <button
            class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
            px-4 py-2 text-white text-base font-medium rounded-md w-full shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-300`}
            on:click={confirmFixtureData}
            disabled={isSubmitDisabled}>Submit Event Data</button
          >
        </div>
      </div>
    </div>
  {/if}
</Layout>

{#if selectedTeam}
  <SelectPlayersModal
    show={showPlayerSelectionModal}
    {teamPlayers}
    {selectedTeam}
    {selectedPlayers}
    closeModal={closeSelectPlayersModal}
  />
{/if}

{#if selectedPlayer}
  <PlayerEventsModal
    show={showPlayerEventModal}
    player={selectedPlayer}
    {fixtureId}
    {playerEventData}
    closeModal={closeEventPlayerEventsModal}
  />
{/if}

<ConfirmFixtureDataModal
  show={showConfirmDataModal}
  onConfirm={confirmFixtureData}
/>

<ClearDraftModal
  closeModal={closeConfirmClearDraftModal}
  show={showClearDraftModal}
  onConfirm={clearDraft}
/>
