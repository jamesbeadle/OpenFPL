<script lang="ts">
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
    import CreateLeagueModal from '$lib/components/private-leagues/create-private-league.svelte';
    import type { PrivateLeague } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    
    const leagues: PrivateLeague = writable([]);
    const showModal = writable(false);
  
    type League = {
      id: number;
      name: string;
      membersCount: number;
      seasonPosition: number;
    };
  
    function fetchLeagues() {
      const dummyData: League[] = [
        { id: 1, name: 'League One', membersCount: 10, seasonPosition: 1 },
        { id: 2, name: 'League Two', membersCount: 8, seasonPosition: 2 },
        // Add more dummy leagues
      ];
      leagues.set(dummyData);
    }
  
    function handleCreateLeague(event) {
      console.log('League to create:', event.detail);
      // Add league creation logic here
      fetchLeagues();
    }
  
    onMount(() => {
      fetchLeagues();
    });
  </script>
  
  <CreateLeagueModal on:createLeague={handleCreateLeague} on:closeModal={() => showModal.set(false)} bind:isVisible={showModal} />
  
  <div class="p-4">
    <button class="btn bg-blue-500 text-white mb-4" on:click={() => showModal.set(true)}>Create New League</button>
  
    <div class="overflow-x-auto">
      <table class="table-auto w-full">
        <thead>
          <tr>
            <th class="text-left">League Name</th>
            <th class="text-left">Members</th>
            <th class="text-left">Season Position</th>
            <th class="text-left">Options</th>
          </tr>
        </thead>
        <tbody>
          {#each $leagues as league (league.id)}
            <tr class="hover:bg-gray-100 cursor-pointer">
              <td>{league.name}</td>
              <td>{league.membersCount}</td>
              <td>{league.seasonPosition}</td>
              <td><button class="p-2 text-gray-600 hover:text-gray-800">⋮</button></td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  </div>
  