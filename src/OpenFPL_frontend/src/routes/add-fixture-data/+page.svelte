<script lang="ts">
    import { onMount} from 'svelte';
    import { page } from "$app/stores";
    import type { PlayerDTO } from '../../../../declarations/player_canister/player_canister.did';
    import type { Fixture, SystemState, Team } from '../../../../declarations/OpenFPL_backend/OpenFPL_backend.did';
    import { PlayerService } from '$lib/services/PlayerService';
    import { TeamService } from '$lib/services/TeamService';
    import { SystemService } from '$lib/services/SystemService';
    import { FixtureService } from '$lib/services/FixtureService';
  
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
      // Implement the useEffect logic from React component here
    });
  
    // Translate other functions and effects from React component
  </script>
  
  {#if isLoading}
    <div class="flex items-center justify-center h-screen">
      <!-- Spinner component -->
      <p class='text-center mt-1'>Loading Fixture Data...</p>
    </div>
  {:else}
    <div class="container mx-auto my-5">
      <!-- Rest of the component -->
      <!-- Convert Tabs and Modals using appropriate Svelte/Tailwind patterns -->
    </div>
  {/if}
  
  <PlayerSelectionModal 
    {showPlayerSelectionModal} 
  />
  <PlayerEventsModal 
    {showPlayerEventModal}
  />
  <ConfirmFixtureDataModal 
    {showConfirmDataModal}
  />
  <ConfirmClearDraftModal 
    {showClearDraftModal}
  />
