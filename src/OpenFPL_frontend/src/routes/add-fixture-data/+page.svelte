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
    
    onMount(async () => {
        let playerService = new PlayerService();
        players = await playerService.getPlayers();

        let teamService = new TeamService();
        teams = await teamService.getTeams();

        let systemService = new SystemService();
        systemState = await systemService.getSystemState();

        let fixtureService = new FixtureService();
        fixtures = await fixtureService.getFixtures();
        fixture = fixtures.find(x => x.id == fixtureId) ?? null;

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
        console.error("Error saving fixture data: ", error);
      }
    }

    function clearDraft(){
      playerEventData = writable<PlayerEventData[] | []>([]);
      localStorage.removeItem(`fixtureDraft_${fixtureId}`);
    }

  </script>
  
  {#if isLoading}
    <div class="flex items-center justify-center h-screen">
      <p class='text-center mt-1'>Loading Fixture Data...</p>
    </div>
  {:else}
    <div class="container mx-auto my-5">

    </div>
  {/if}
  
  <SelectPlayersModal show={showPlayerSelectionModal} {teamPlayers} {selectedTeam} {selectedPlayers}  />
  <PlayerEventsModal show={showPlayerEventModal} player={selectedPlayer} {fixtureId} {playerEventData} />
  <ConfirmFixtureDataModal show={showConfirmDataModal} onConfirm={confirmFixtureData} />
  <ClearDraftModal show={showClearDraftModal} onConfirm={clearDraft} />
