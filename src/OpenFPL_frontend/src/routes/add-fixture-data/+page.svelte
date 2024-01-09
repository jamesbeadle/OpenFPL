<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { goto } from "$app/navigation";
  import { writable } from "svelte/store";
  import { systemStore } from "$lib/stores/system-store";
  import { teamStore } from "$lib/stores/team-store";
  import { playerStore } from "$lib/stores/player-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { toastsError, toastsShow } from "$lib/stores/toasts-store";
  import {
    replacer,
    convertEvent,
    convertPlayerPosition,
  } from "$lib/utils/Helpers";
  import type {
    FixtureDTO,
    ClubDTO,
    PlayerDTO,
    PlayerEventData,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  
  import Layout from "../Layout.svelte";
  import PlayerEventsModal from "$lib/components/fixture-validation/player-events-modal.svelte";
  import SelectPlayersModal from "$lib/components/fixture-validation/select-players-modal.svelte";
  import ConfirmFixtureDataModal from "$lib/components/fixture-validation/confirm-fixture-data-modal.svelte";
  import ClearDraftModal from "$lib/components/fixture-validation/clear-draft-modal.svelte";
  import { Spinner, busyStore } from "@dfinity/gix-components";
  import BadgeIcon from "$lib/icons/BadgeIcon.svelte";

  let players: PlayerDTO[] = [];
  let fixture: FixtureDTO | null;
  let homeTeam: ClubDTO | null;
  let awayTeam: ClubDTO | null;

  let showPlayerSelectionModal = false;
  let showPlayerEventModal = false;
  let showClearDraftModal = false;
  let showConfirmDataModal = false;

  let teamPlayers = writable<PlayerDTO[] | []>([]);
  let selectedPlayers = writable<PlayerDTO[] | []>([]);

  let selectedTeam: ClubDTO | null = null;
  let selectedPlayer: PlayerDTO | null = null;
  let playerEventData = writable<PlayerEventData[] | []>([]);
  let activeTab: string = "home";
  let homeGoalsText = "";
  let awayGoalsText = "";
  let homeAssistsText = "";
  let awayAssistsText = "";

  let isLoading = true;
  
  $: fixtureId = Number($page.url.searchParams.get("id"));

  $: isSubmitDisabled =
    $playerEventData.length == 0 ||
    $playerEventData.filter((x) => convertEvent(x.eventType) == 0).length !=
      $selectedPlayers.length;


  onMount(async () => {
    try {
      await systemStore.sync();
      await teamStore.sync();
      if ($teamStore.length == 0) return;
      await fixtureStore.sync();
      await playerStore.sync();

      let teams = $teamStore;
      if (teams.length == 0) {
        return;
      }

      playerStore.subscribe((value) => {
        players = value;
      });

      fixtureStore.subscribe((value) => {
        fixture = value.find((x) => x.id == fixtureId)!;
        homeTeam = teams.find((x) => x.id == fixture?.homeClubId)!;
        awayTeam = teams.find((x) => x.id == fixture?.awayClubId)!;
        selectedTeam = homeTeam;
        teamPlayers.set(players.filter((x) => x.clubId == selectedTeam?.id));
      });
      loadDraft(fixtureId);
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

  function loadDraft(fixtureId: number) {
    const draftKey = `fixtureDraft_${fixtureId}`;
    const savedDraft = localStorage.getItem(draftKey);
    if (savedDraft) {
      const draftData = JSON.parse(savedDraft);

      let draftEventData = draftData.playerEventData;
      if (draftEventData) {
        playerEventData.set(draftEventData);
      }

      let allPlayers = draftData.allPlayers;
      if (allPlayers) {
        updateSelectedPlayers(allPlayers, draftEventData);
      }
    }
  }

  async function confirmFixtureData() {
    busyStore.startBusy({
      initiator: "confirm-data",
      text: "Saving fixture data...",
    });

    try {
      await governanceStore.submitFixtureData(
        $systemStore?.calculationSeasonId ?? 0,
        $systemStore?.calculationGameweek ?? 0,
        fixtureId,
        $playerEventData
      );
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
      showConfirmDataModal = false;
      busyStore.stopBusy("confirm-data");
    }
  }

  function updateSelectedPlayers(
    allPlayers: PlayerDTO[],
    playerEvents: PlayerEventData[]
  ): void {
    const playerEventMap = new Map<number, PlayerEventData[]>();
    playerEvents.forEach((event) => {
      if (!playerEventMap.has(event.playerId)) {
        playerEventMap.set(event.playerId, []);
      }
      playerEventMap.get(event.playerId)?.push(event);
    });

    selectedPlayers.set(allPlayers);
    playerEventData.set(playerEvents);
  }

  function saveDraft() {
    let uniquePlayerIds = new Set();
    $playerEventData.forEach((event) => {
      uniquePlayerIds.add(event.playerId);
    });

    let playersFromEvents = Array.from(uniquePlayerIds);

    const draftData = {
      playersFromEvents: playersFromEvents,
      playerEventData: $playerEventData,
    };
    const draftKey = `fixtureDraft_${fixtureId}`;
    localStorage.setItem(draftKey, JSON.stringify(draftData, replacer));
    toastsShow({
      text: "Draft saved.",
      level: "success",
      duration: 2000,
    });
    busyStore.stopBusy("save-draft");
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
    teamPlayers.set(players.filter((x) => x.clubId == selectedTeam?.id));
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

  function displayConfirmDataModal(): void {
    showConfirmDataModal = true;
  }

  function closeConfirmDataModal(): void {
    showConfirmDataModal = false;
  }
</script>

<Layout>
  {#if isLoading}
    <Spinner />
  {:else}
    
    <div class="flex flex-row space-x-4 mb-4">
      <div class="bg-panel-color rounded-md w-1/3 flex flex-row items-center justify-center space-x-4 py-4">
        <div class="flex-col flex justify-center space-y-2">
          <BadgeIcon
            className="h-12"
            primaryColour={homeTeam?.primaryColourHex}
            secondaryColour={homeTeam?.secondaryColourHex}
            thirdColour={homeTeam?.thirdColourHex}
          />
          <p class="text-center text-sm">{homeTeam?.abbreviatedName}</p>  
        </div>
        <p class="text-4xl">0-0</p>
        <div class="flex-col flex justify-center space-y-2">
          <BadgeIcon
            className="h-12"
            primaryColour={awayTeam?.primaryColourHex}
            secondaryColour={awayTeam?.secondaryColourHex}
            thirdColour={awayTeam?.thirdColourHex}
          />
          <p class="text-center text-sm">{awayTeam?.abbreviatedName}</p>  
        </div>
        
      </div>
      <div class="bg-panel-color rounded-md w-2/3 flex flex-row space-x-4 p-4 text-gray-400 text-sm">
        <div class="w-1/2 flex-col space-y-4">
          <p>{homeTeam?.name}</p>
          <div class="flex flex-col space-y-2">
            <p>Goals: {homeGoalsText}</p>
            <p>Assists: {homeAssistsText}</p>
          </div>
        </div>
        <div class="w-1/2 flex-col space-y-4">
          <p>{awayTeam?.name}</p>
          <div class="flex flex-col space-y-2">
            <p>Goals: {awayGoalsText}</p>
            <p>Assists: {awayAssistsText}</p>
          </div>
        </div>
      </div>
    </div>


    <div class="bg-panel rounded-md">
     
      <div class="flex flex-col">
        
        <div class="flex w-full">
          <ul
            class="flex bg-light-gray px-4 pt-2 w-full border-b border-gray-700"
          >
            <li class={`mr-4 ${activeTab === "home" ? "active-tab" : ""}`}>
              <button
                class={`p-2 ${
                  activeTab === "home" ? "text-white" : "text-gray-400"
                }`}
                on:click={() => setActiveTab("home")}
                >{homeTeam?.friendlyName}</button
              >
            </li>
            <li class={`mr-4 ${activeTab === "away" ? "active-tab" : ""}`}>
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
        <div class="flex flex-row space-x-2 p-4 items-center">
          <p>Selected Players</p>
          <div class="flex-grow"></div>
          <button class="fpl-button default-button px-4 py-2 justify-end" on:click={showSelectPlayersModal}
            >Select Players</button
          >
        </div>
        <div class="flex w-full flex-col">

          <div
          class="flex flex-row items-center justify-between border border-gray-700 py-4 bg-light-gray"
        >
          <div class="w-1/6 px-4">#</div>
          <div class="w-3/6 px-4">Player</div>
          <div class="w-1/6 px-4">Events</div>
          <div class="w-1/6 px-4">Action</div>
        </div>

          {#if activeTab === "home"}
            {#each $selectedPlayers.filter((x) => x.clubId === fixture?.homeClubId) as player (player.id)}
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
                {#if convertPlayerPosition(player.position) == 0}<div
                    class="w-1/6 px-4"
                  >
                    GK
                  </div>{/if}
                {#if convertPlayerPosition(player.position) == 1}<div
                    class="w-1/6 px-4"
                  >
                    DF
                  </div>{/if}
                {#if convertPlayerPosition(player.position) == 2}<div
                    class="w-1/6 px-4"
                  >
                    MF
                  </div>{/if}
                {#if convertPlayerPosition(player.position) == 3}<div
                    class="w-1/6 px-4"
                  >
                    FW
                  </div>{/if}
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
                    (e) =>
                      e.playerId === player.id && convertEvent(e.eventType) == 0
                  )
                    ? $playerEventData?.find(
                        (e) =>
                          e.playerId === player.id &&
                          convertEvent(e.eventType) == 0
                      )?.eventStartMinute
                    : "-"}
                </div>
                <div class="w-1/6 px-4">
                  {$playerEventData &&
                  $playerEventData?.length > 0 &&
                  $playerEventData?.find(
                    (e) =>
                      e.playerId === player.id && convertEvent(e.eventType) == 0
                  )
                    ? $playerEventData?.find(
                        (e) =>
                          e.playerId === player.id &&
                          convertEvent(e.eventType) == 0
                      )?.eventEndMinute
                    : "-"}
                </div>
                <div class="w-1/6 px-4">
                  <button
                    on:click={() => handleEditPlayerEvents(player)}
                    class="rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
                  >
                    Update Events
                  </button>
                </div>
              </div>
            {/each}
            {#if $selectedPlayers.filter((x) => x.clubId === fixture?.homeClubId).length == 0}
              <p class="p-4">No players selected.</p>
            {/if}
          {/if}
          {#if activeTab === "away"}
            {#each $selectedPlayers.filter((x) => x.clubId === fixture?.awayClubId) as player (player.id)}
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
                {#if convertPlayerPosition(player.position) == 0}<div
                    class="w-1/6 px-4"
                  >
                    GK
                  </div>{/if}
                {#if convertPlayerPosition(player.position) == 1}<div
                    class="w-1/6 px-4"
                  >
                    DF
                  </div>{/if}
                {#if convertPlayerPosition(player.position) == 2}<div
                    class="w-1/6 px-4"
                  >
                    MF
                  </div>{/if}
                {#if convertPlayerPosition(player.position) == 3}<div
                    class="w-1/6 px-4"
                  >
                    FW
                  </div>{/if}
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
                    (e) =>
                      e.playerId === player.id && convertEvent(e.eventType) == 0
                  )
                    ? $playerEventData?.find((e) => e.playerId === player.id)
                        ?.eventStartMinute
                    : "-"}
                </div>
                <div class="w-1/6 px-4">
                  {$playerEventData &&
                  $playerEventData?.length > 0 &&
                  $playerEventData?.find(
                    (e) =>
                      e.playerId === player.id && convertEvent(e.eventType) == 0
                  )
                    ? $playerEventData?.find((e) => e.playerId === player.id)
                        ?.eventEndMinute
                    : "-"}
                </div>
                <div class="w-1/6 px-4">
                  <button
                    on:click={() => handleEditPlayerEvents(player)}
                    class="rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1"
                  >
                    Update Events
                  </button>
                </div>
              </div>
            {/each}
            {#if $selectedPlayers.filter((x) => x.clubId === fixture?.awayClubId).length == 0}
              <p class="p-4">No players selected.</p>
            {/if}
          {/if}




        </div>
        <div class="flex flex-row space-x-2 p-4 items-center justify-end">
          
          <div class="flex-grow"></div>
          <button class="fpl-purple-btn default-button px-4 py-2" on:click={saveDraft}
            >Save Draft</button
          >
          <button
            class="fpl-purple-btn default-button px-4 py-2"
            on:click={showConfirmClearDraftModal}>Clear Draft</button
          >
          <button
            class={`${isSubmitDisabled ? "bg-gray-500" : "fpl-purple-btn"} 
            px-4 py-2 default-button`}
            on:click={displayConfirmDataModal}
            disabled={isSubmitDisabled}>Submit Proposal</button
          >
        </div>
        
        <div class="border-b border-gray-600 mx-4"></div>

        <div class="flex flex-row w-full m-4 text-sm">
          <div class="w-1/3 border-r border-gray-600 px-4">
            <div class="flex-grow">
              Appearances: {$playerEventData.filter(
                (x) => convertEvent(x.eventType) == 0
              ).length}
            </div>
            <div class="flex-grow">
              Goals: {$playerEventData.filter(
                (x) => convertEvent(x.eventType) == 1
              ).length}
            </div>
            <div class="flex-grow">
              Own Goals: {$playerEventData.filter(
                (x) => convertEvent(x.eventType) == 10
              ).length}
            </div>
          </div>
          <div class="w-1/3 border-r border-gray-600 px-4">
            <div class="flex-grow">
              Assists: {$playerEventData.filter(
                (x) => convertEvent(x.eventType) == 2
              ).length}
            </div>
            <div class="flex-grow">
              Keeper Saves: {$playerEventData.filter(
                (x) => convertEvent(x.eventType) == 4
              ).length}
            </div>
            <div class="flex-grow">
              Yellow Cards: {$playerEventData.filter(
                (x) => convertEvent(x.eventType) == 8
              ).length}
            </div>
          </div>
          <div class="w-1/3 px-4">
            <div class="flex-grow">
              Red Cards: {$playerEventData.filter(
                (x) => convertEvent(x.eventType) == 9
              ).length}
            </div>
            <div class="flex-grow">
              Penalties Saved: {$playerEventData.filter(
                (x) => convertEvent(x.eventType) == 6
              ).length}
            </div>
            <div class="flex-grow">
              Penalties Missed: {$playerEventData.filter(
                (x) => convertEvent(x.eventType) == 7
              ).length}
            </div>
          </div>
        </div>
      </div>
    </div>
  {/if}
</Layout>

{#if selectedTeam}
  <SelectPlayersModal
    visible={showPlayerSelectionModal}
    {teamPlayers}
    {selectedTeam}
    {selectedPlayers}
    closeModal={closeSelectPlayersModal}
  />
{/if}

{#if selectedPlayer}
  <PlayerEventsModal
    visible={showPlayerEventModal}
    player={selectedPlayer}
    {fixtureId}
    {playerEventData}
    closeModal={closeEventPlayerEventsModal}
  />
{/if}

<ConfirmFixtureDataModal
  visible={showConfirmDataModal}
  onConfirm={confirmFixtureData}
  closeModal={closeConfirmDataModal}
/>

<ClearDraftModal
  closeModal={closeConfirmClearDraftModal}
  visible={showClearDraftModal}
  onConfirm={clearDraft}
/>
