<script lang="ts">
    import { onMount} from 'svelte';
    import { page } from "$app/stores";
    import { get, writable } from "svelte/store";
    import type { PlayerDTO, PlayerEventData } from '../../../../declarations/player_canister/player_canister.did';
    import type { Fixture, SystemState, Team } from '../../../../declarations/OpenFPL_backend/OpenFPL_backend.did';
    import { PlayerService } from '$lib/services/PlayerService';
    import { TeamService } from '$lib/services/TeamService';
    import { SystemService } from '$lib/services/SystemService';
    import { FixtureService } from '$lib/services/FixtureService';
    import PlayerEventsModal from '$lib/components/fixture-validation/player-events-modal.svelte';
    import SelectPlayersModal from '$lib/components/fixture-validation/select-players-modal.svelte';
    import ConfirmFixtureDataModal from '$lib/components/fixture-validation/confirm-fixture-data-modal.svelte';
    import ClearDraftModal from '$lib/components/fixture-validation/clear-draft-modal.svelte';
    import { GovernanceService } from '$lib/services/GovernanceService';
    import { redirect } from '@sveltejs/kit';
    import { toastStore } from '$lib/stores/toast';
    import Layout from '../Layout.svelte';
    import { replacer } from '$lib/utils/Helpers';
  
    $: fixtureId = Number($page.url.searchParams.get("id"));
    let teams: Team[];
    let players: PlayerDTO[];
    let fixtures: Fixture[];
    let systemState: SystemState | null;
    let isLoading = true;
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
        let playerService = new PlayerService();
        players = await playerService.getPlayers();

        let teamService = new TeamService();
        teams = await teamService.getTeams();

        let systemService = new SystemService();
        systemState = await systemService.getSystemState();

        let fixtureService = new FixtureService();
        fixtures = await fixtureService.getFixtures();
        fixture = fixtures.find(x => x.id === fixtureId) ?? null;

        const draftKey = `fixtureDraft_${fixtureId}`;
        const savedDraft = localStorage.getItem(draftKey);
        if (savedDraft) {
            const draftData = JSON.parse(savedDraft);
            playerEventData.set(draftData);
        }
    });

    async function confirmFixtureData(){
      try {
        await new GovernanceService().submitFixtureData(fixtureId, get(playerEventData));
        localStorage.removeItem(`fixtureDraft_${fixtureId}`);
        throw redirect(307, '/fixture-validation');
      } catch (error) {
        toastStore.show("Error saving fixture data.", "error");
        console.error("Error saving fixture data: ", error);
      }
    }

    function saveDraft() {
        const draftData = {
            playerEventData: get(playerEventData),
        };
        const draftKey = `fixtureDraft_${fixtureId}`;
        localStorage.setItem(draftKey, JSON.stringify(draftData, replacer));
        toastStore.show("Draft saved.", "success");
    }

    function clearDraft(){
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
    <p class='text-center mt-1'>Loading Fixture Data...</p>
  </div>
  {:else}
    <div class="m-4">
      <button class="fpl-button" on:click={saveDraft}>Save Draft</button>
      <div class="bg-panel rounded-lg m-4">
        <ul class="flex rounded-lg bg-light-gray px-4 pt-2">
          <li class={`mr-4 text-xs md:text-lg ${ activeTab === "home" ? "active-tab" : "" }`}>
            <button class={`p-2 ${ activeTab === "home" ? "text-white" : "text-gray-400" }`}
              on:click={() => setActiveTab("home")}>{getTeamFromId(fixture?.homeTeamId ?? 0)?.friendlyName}</button>
          </li>
          <li class={`mr-4 text-xs md:text-lg ${ activeTab === "away" ? "active-tab" : "" }`}>
            <button class={`p-2 ${  activeTab === "away" ? "text-white" : "text-gray-400" }`}
            on:click={() => setActiveTab("away")}>{getTeamFromId(fixture?.awayTeamId ?? 0)?.friendlyName}</button>
          </li>
        </ul>

        {#if activeTab === "home"}
          {#each $selectedPlayers.filter(x => x.teamId === fixture?.homeTeamId) as player (player.id)}
            <div class="card player-card mb-4">
              <div class="card-header">
                  <h5>{player.lastName}</h5>
                  <p class='small-text mb-0 mt-0'>{player.firstName}</p>
              </div>
              <div class="card-body">
                <p>Events: {($playerEventData.filter(pe => pe.playerId === player.id).length)}</p>
                <button on:click={() => handleEditPlayerEvents(player)}>Update</button>
              </div>
            </div>
          {/each}
        {:else if activeTab === "away"}
          {#each $selectedPlayers.filter(x => x.teamId === fixture?.awayTeamId) as player (player.id)}
              <div class="card player-card mb-4">
                <div class="card-header">
                    <h5>{player.lastName}</h5>
                    <p class='small-text mb-0 mt-0'>{player.firstName}</p>
                </div>
                <div class="card-body">
                  <p>Events: {($playerEventData.filter(pe => pe.playerId === player.id).length)}</p>
                  <button on:click={() => handleEditPlayerEvents(player)}>Update</button>
                </div>
              </div>
            {/each}
        {/if}
      </div>
    </div>
  {/if}

</Layout>

<SelectPlayersModal show={showPlayerSelectionModal} {teamPlayers} {selectedTeam} {selectedPlayers}  />
<PlayerEventsModal show={showPlayerEventModal} player={selectedPlayer} {fixtureId} {playerEventData} />
<ConfirmFixtureDataModal show={showConfirmDataModal} onConfirm={confirmFixtureData} />
<ClearDraftModal show={showClearDraftModal} onConfirm={clearDraft} />
