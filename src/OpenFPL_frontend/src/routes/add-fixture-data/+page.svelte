<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { page } from "$app/stores";
  import { writable } from "svelte/store";
  import type {
    PlayerDTO,
    PlayerEventData,
  } from "../../../../declarations/player_canister/player_canister.did";
  import type {
    Fixture,
    Team,
  } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { teamStore } from "$lib/stores/team-store";
  import { fixtureStore } from "$lib/stores/fixture-store";
  import PlayerEventsModal from "$lib/components/fixture-validation/player-events-modal.svelte";
  import SelectPlayersModal from "$lib/components/fixture-validation/select-players-modal.svelte";
  import ConfirmFixtureDataModal from "$lib/components/fixture-validation/confirm-fixture-data-modal.svelte";
  import ClearDraftModal from "$lib/components/fixture-validation/clear-draft-modal.svelte";
  import { toastStore } from "$lib/stores/toast-store";
  import Layout from "../Layout.svelte";
  import { replacer } from "$lib/utils/Helpers";
  import { governanceStore } from "$lib/stores/governance-store";
  import { isLoading, loadingText } from "$lib/stores/global-stores";
  import { goto } from "$app/navigation";

  $: fixtureId = Number($page.url.searchParams.get("id"));

  let teams: Team[];
  let fixtures: Fixture[];

  let unsubscribeTeams: () => void;
  let unsubscribeFixtures: () => void;

  let fixture: Fixture | null;
  let showPlayerSelectionModal = false;
  let showPlayerEventModal = false;
  let showClearDraftModal = false;
  let showConfirmDataModal = false;
  let teamPlayers = writable<PlayerDTO[] | []>([]);
  let selectedPlayers = writable<PlayerDTO[] | []>([]);
  let selectedTeam: Team;
  let selectedPlayer: PlayerDTO;
  let playerEventData = writable<PlayerEventData[] | []>([]);
  let activeTab: string = "home";

  onMount(async () => {
    await teamStore.sync();
    await fixtureStore.sync();

    unsubscribeTeams = teamStore.subscribe((value) => {
      teams = value;
    });

    unsubscribeFixtures = fixtureStore.subscribe((value) => {
      fixtures = value;
    });

    fixture = fixtures.find((x) => x.id === fixtureId) ?? null;

    const draftKey = `fixtureDraft_${fixtureId}`;
    const savedDraft = localStorage.getItem(draftKey);
    if (savedDraft) {
      const draftData = JSON.parse(savedDraft);
      playerEventData.set(draftData);
    }
  });

  onDestroy(() => {
    unsubscribeTeams?.();
    unsubscribeFixtures?.();
  });

  async function confirmFixtureData() {
    isLoading.set(true);
    loadingText.set("Saving Fixture Data");
    try {
      await governanceStore.submitFixtureData(fixtureId, $playerEventData);
      localStorage.removeItem(`fixtureDraft_${fixtureId}`);
      toastStore.show("Fixture data saved", "success");
      goto("/fixture-validation");
    } catch (error) {
      toastStore.show("Error saving fixture data.", "error");
      console.error("Error saving fixture data: ", error);
    } finally {
      isLoading.set(false);
      loadingText.set("Loading");
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
  }

  function setActiveTab(tab: string): void {
    activeTab = tab;
  }

  function getTeamFromId(teamId: number): Team | undefined {
    return teams.find((team) => team.id === teamId);
  }

  function handleEditPlayerEvents(player: PlayerDTO) {
    selectedPlayer = player;
    showPlayerEventModal = true;
  }
</script>

<Layout>
  {#if isLoading}
    <div class="flex items-center justify-center h-screen">
      <p class="text-center mt-1">Loading Fixture Data...</p>
    </div>
  {:else}
    <div class="m-4">
      <button class="fpl-button" on:click={saveDraft}>Save Draft</button>
      <div class="bg-panel rounded-lg m-4">
        <ul class="flex rounded-t-lg bg-light-gray px-4 pt-2">
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
            >
              {getTeamFromId(fixture?.homeTeamId ?? 0)?.friendlyName}</button
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
              >{getTeamFromId(fixture?.awayTeamId ?? 0)?.friendlyName}</button
            >
          </li>
        </ul>

        {#if activeTab === "home"}
          {#each $selectedPlayers.filter((x) => x.teamId === fixture?.homeTeamId) as player (player.id)}
            <div class="card player-card mb-4">
              <div class="card-header">
                <h5>{player.lastName}</h5>
                <p class="small-text mb-0 mt-0">{player.firstName}</p>
              </div>
              <div class="card-body">
                <p>
                  Events: {$playerEventData.filter(
                    (pe) => pe.playerId === player.id
                  ).length}
                </p>
                <button on:click={() => handleEditPlayerEvents(player)}
                  >Update</button
                >
              </div>
            </div>
          {/each}
        {:else if activeTab === "away"}
          {#each $selectedPlayers.filter((x) => x.teamId === fixture?.awayTeamId) as player (player.id)}
            <div class="card player-card mb-4">
              <div class="card-header">
                <h5>{player.lastName}</h5>
                <p class="small-text mb-0 mt-0">{player.firstName}</p>
              </div>
              <div class="card-body">
                <p>
                  Events: {$playerEventData.filter(
                    (pe) => pe.playerId === player.id
                  ).length}
                </p>
                <button on:click={() => handleEditPlayerEvents(player)}
                  >Update</button
                >
              </div>
            </div>
          {/each}
        {/if}
      </div>
    </div>
  {/if}
</Layout>

<SelectPlayersModal
  show={showPlayerSelectionModal}
  {teamPlayers}
  {selectedTeam}
  {selectedPlayers}
/>
<PlayerEventsModal
  show={showPlayerEventModal}
  player={selectedPlayer}
  {fixtureId}
  {playerEventData}
/>
<ConfirmFixtureDataModal
  show={showConfirmDataModal}
  onConfirm={confirmFixtureData}
/>
<ClearDraftModal show={showClearDraftModal} onConfirm={clearDraft} />
