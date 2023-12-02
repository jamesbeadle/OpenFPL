<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { page } from "$app/stores";
  import { goto } from "$app/navigation";
  import { writable } from "svelte/store";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import { governanceStore } from "$lib/stores/governance-store";
  import { toastStore } from "$lib/stores/toast-store";
  import { isLoading, loadingText } from "$lib/stores/global-stores";
  import type { PlayerDTO, PlayerEventData } from "../../../../declarations/player_canister/player_canister.did";
  import type { Fixture, Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { replacer } from "$lib/utils/Helpers";
  import Layout from "../Layout.svelte";
  import PlayerEventsModal from "$lib/components/fixture-validation/player-events-modal.svelte";
  import SelectPlayersModal from "$lib/components/fixture-validation/select-players-modal.svelte";
  import ConfirmFixtureDataModal from "$lib/components/fixture-validation/confirm-fixture-data-modal.svelte";
  import ClearDraftModal from "$lib/components/fixture-validation/clear-draft-modal.svelte";
  import { playerStore } from "$lib/stores/player-store";
  
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
  let selectedPlayer: PlayerDTO | null = null;;
  let playerEventData = writable<PlayerEventData[] | []>([]);
  let activeTab: string = "home";

  onMount(async () => {
    $isLoading = true;
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
        fixture = value.find(x => x.id == fixtureId)!;
        homeTeam = teams.find(x => x.id == fixture?.homeTeamId)!;
        awayTeam = teams.find(x => x.id == fixture?.awayTeamId)!;
        selectedTeam = homeTeam;
        teamPlayers.set(players.filter(x => x.teamId == selectedTeam?.id));
      });

      const draftKey = `fixtureDraft_${fixtureId}`;
      const savedDraft = localStorage.getItem(draftKey);
      if (savedDraft) {
        const draftData = JSON.parse(savedDraft);
        let draftEventData = draftData.playerEventData[0];
        if(draftEventData){
          playerEventData.set(draftEventData);
        }
      }
    } catch (error) {
      toastStore.show("Error fetching fixture validation list.", "error");
      console.error("Error fetching fixture validation list.", error);
    } finally {
      $isLoading = false;
    }

  });

  onDestroy(() => {});

  async function confirmFixtureData() {
      $isLoading = true;
      $loadingText = "Saving Fixture Data";
    try {
      await governanceStore.submitFixtureData(fixtureId, $playerEventData);
      localStorage.removeItem(`fixtureDraft_${fixtureId}`);
      toastStore.show("Fixture data saved", "success");
      goto("/fixture-validation");
    } catch (error) {
      toastStore.show("Error saving fixture data.", "error");
      console.error("Error saving fixture data: ", error);
    } finally {
      $isLoading = false;
      $loadingText = "Loading";
    }
  }

  function saveDraft() {
    const draftData = {
      playerEventData: $playerEventData,
    };
    const draftKey = `fixtureDraft_${fixtureId}`;
    localStorage.setItem(draftKey, JSON.stringify(draftData, replacer));
    toastStore.show("Draft saved.", "success");
  }

  function clearDraft() {
    playerEventData = writable<PlayerEventData[] | []>([]);
    localStorage.removeItem(`fixtureDraft_${fixtureId}`);
    toastStore.show("Draft cleared.", "success");
    closeConfirmClearDraftModal();
  }

  async function setActiveTab(tab: string) {
    await playerStore.sync();
    selectedTeam = tab === 'home' ? homeTeam : awayTeam;
    teamPlayers.set(players.filter(x => x.teamId == selectedTeam?.id));
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

  function closeSelectPlayersModal(): void{
    showPlayerSelectionModal = false;
  }

  function showConfirmClearDraftModal(): void {
    showClearDraftModal = true;
  }

  function closeConfirmClearDraftModal(): void{
    showClearDraftModal = false;
  }

</script>

<Layout>
  <div class="container-fluid mx-4 md:mx-16 mt-4 bg-panel">
    <div class="flex flex-col text-xs md:text-base mt-4">
      <div class="flex flex-row space-x-2 p-4">
        <button class="fpl-button px-4 py-2" on:click={showSelectPlayersModal}>Select Players</button>
        <button class="fpl-button px-4 py-2" on:click={saveDraft}>Save Draft</button>
        <button class="fpl-button px-4 py-2" on:click={showConfirmClearDraftModal}>Clear Draft</button>
      </div>
      {#if !$isLoading}
        <div class="flex w-full">
          <ul class="flex bg-light-gray px-4 pt-2 w-full mt-4">
            <li class={`mr-4 text-xs md:text-base ${ activeTab === "home" ? "active-tab" : "" }`}>
              <button class={`p-2 ${ activeTab === "home" ? "text-white" : "text-gray-400"}`}
                on:click={() => setActiveTab("home")}>{homeTeam?.friendlyName}</button>
            </li>
            <li class={`mr-4 text-xs md:text-base ${ activeTab === "away" ? "active-tab" : ""}`}>
              <button class={`p-2 ${ activeTab === "away" ? "text-white" : "text-gray-400" }`}
                on:click={() => setActiveTab("away")}>{awayTeam?.friendlyName}</button>
            </li>
          </ul>
        </div>
      <div class="flex w-full flex-col">
        <div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer w-full">
          <div class="w-1/6 px-4">Player</div>
          <div class="w-1/6 px-4">Position</div>
          <div class="w-1/6 px-4">Events</div>
          <div class="w-1/6 px-4">Start</div>
          <div class="w-1/6 px-4">End</div>
          <div class="w-1/6 px-4">&nbsp;</div>
        </div>
        {#if activeTab === "home"}
          {#each $selectedPlayers.filter((x) => x.teamId === fixture?.homeTeamId) as player (player.id)}
              <div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer w-full">
                <div class="w-1/6 px-4">{`${ player.firstName.length > 0 ? player.firstName.charAt(0) + "." : "" } ${player.lastName}`}</div>
                {#if player.position == 0}<div class="w-1/6 px-4">GK</div>{/if}
                {#if player.position == 1}<div class="w-1/6 px-4">DF</div>{/if}
                {#if player.position == 2}<div class="w-1/6 px-4">MF</div>{/if}
                {#if player.position == 3}<div class="w-1/6 px-4">FW</div>{/if}
                <div class="w-1/6 px-4">Events: 
                  {$playerEventData?.length > 0 && $playerEventData?.filter(e => e.playerId === player.id).length ? $playerEventData?.filter(e => e.playerId === player.id).length : 0}
                </div>
                <div class="w-1/6 px-4">
                  {$playerEventData && $playerEventData?.length > 0 && $playerEventData?.find(e => e.playerId === player.id && e.eventType == 0) ? 
                    $playerEventData?.find(e => e.playerId === player.id)?.eventStartMinute : '-'}
                </div>
                <div class="w-1/6 px-4">
                  {$playerEventData && $playerEventData?.length > 0 && $playerEventData?.find(e => e.playerId === player.id && e.eventType == 0) ? 
                    $playerEventData?.find(e => e.playerId === player.id)?.eventEndMinute : '-'}
                </div>
                <div class="w-1/6 px-4">
                  <button on:click={() => handleEditPlayerEvents(player)} class="text-base sm:text-xs md:text-base rounded fpl-button px-3 sm:px-2 px-3 py-1 ml-1">
                    Update Events
                  </button>
                </div>
              </div>
          {/each}
        {/if}
      </div>
      {/if}
    </div>
  </div>  
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

<ClearDraftModal show={showClearDraftModal} onConfirm={clearDraft} />
