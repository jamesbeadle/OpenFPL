<script lang="ts">
    import { onMount} from 'svelte';
    import { page } from "$app/stores";
    import { writable } from "svelte/store";
    import type { PlayerDTO, PlayerEventData } from '../../../../declarations/player_canister/player_canister.did';
    import type { Fixture, SystemState, Team } from '../../../../declarations/OpenFPL_backend/OpenFPL_backend.did';
    import { PlayerService } from '$lib/services/PlayerService';
    import { TeamService } from '$lib/services/TeamService';
    import { SystemService } from '$lib/services/SystemService';
    import { FixtureService } from '$lib/services/FixtureService';
    import PlayerEventsModal from '$lib/components/player-events-modal.svelte';
    import SelectPlayersModal from '$lib/components/select-players-modal.svelte';
    import ConfirmFixtureDataModal from '$lib/components/confirm-fixture-data-modal.svelte';
    import ClearDraftModal from '$lib/components/clear-draft-modal.svelte';
    import { GovernanceService } from '$lib/services/GovernanceService';
  
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
    let playerEventData: PlayerEventData[] = [];

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
    });

    function confirmFixtureData(){
      let governanceService = new GovernanceService();
      governanceService.submitFixtureData(fixtureId, playerEventData);
    }

    function cancelConfirm(){

    }

    function clearDraft(){

    }

    function cancelClear(){

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
  
  <SelectPlayersModal show={showPlayerSelectionModal} {teamPlayers} closeModal={() => showPlayerSelectionModal = false} {selectedTeam} {selectedPlayers}  />
  <PlayerEventsModal show={showPlayerEventModal} player={selectedPlayer} {fixtureId} />
  <ConfirmFixtureDataModal show={showConfirmDataModal} onConfirm={confirmFixtureData} onHide={cancelConfirm} />
  <ClearDraftModal show={showClearDraftModal} onConfirm={clearDraft} onHide={cancelClear} />
