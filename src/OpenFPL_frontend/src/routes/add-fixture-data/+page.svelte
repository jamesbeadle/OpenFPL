<script lang="ts">
    import { onMount, getContext } from 'svelte';
    import PlayerEventsModal from './PlayerEventsModal.svelte';
    import PlayerSelectionModal from './SelectPlayersModal.svelte';
    import ConfirmFixtureDataModal from './ConfirmFixtureDataModal.svelte';
    import ConfirmClearDraftModal from './ConfirmClearDraftModal.svelte';
    import { open_fpl_backend } from '../../../../../declarations/OpenFPL_backend'; // Update import path as needed
  
    let fixtureId = ""; // Retrieve fixtureId from the URL
    let teams; // Initialize teams (use getContext or import as needed)
    let players; // Initialize players (use getContext or import as needed)
    let systemState; // Initialize systemState (use getContext or import as needed)
    let isLoading = true;
    let fixture;
    let showPlayerSelectionModal = false;
    // ... define other states and functions as in your React component
  
    onMount(() => {
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
    {/* Pass other required props */}
  />
  <PlayerEventsModal 
    {showPlayerEventModal}
    {/* Pass other required props */}
  />
  <ConfirmFixtureDataModal 
    {showConfirmDataModal}
    {/* Pass other required props */}
  />
  <ConfirmClearDraftModal 
    {showConfirmClearDraftModal}
    {/* Pass other required props */}
  />
