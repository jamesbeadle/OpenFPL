<script lang="ts">
    import { onMount } from 'svelte';
    import type { Team } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { TeamService } from '$lib/services/TeamService';
    
    const teamService = new TeamService();
    
    let teams: Team[] = [];
    let selectedTeam = 1;

    onMount(async () => {
        try {
            const fetchedTeams = await teamService.getTeamsData(localStorage.getItem('teams_hash') ?? '');

            teams = fetchedTeams;
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    });

</script>

<div class="container mx-auto p-4">
    <div class="flex flex-wrap">
      <div class="w-full md:w-auto px-2 ml-4 md:ml-0">
        <img src="profile_placeholder.png" alt="Profile" class="w-48 md:w-80 p-4"/>
      </div>
      <div class="w-full md:w-3/4 px-2 mb-4">
        <div class="ml-4 p-4 rounded-lg">
            <p class="text-xs mb-2">Display Name:</p>
            <h2 class="text-2xl font-bold mb-2">Not Set</h2>
            <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold p-4 rounded">
                Update
            </button>
            <p class="text-xs mb-2 mt-4">Favourite Team:</p>
            <select class="p-2 fpl-dropdown text-sm md:text-xl"
                bind:value={selectedTeam}>
                {#each teams as team}
                    <option value="{team.id}">{team.friendlyName}</option>
                {/each}
            </select>
            
            <p class="text-xs mb-2 mt-4">Joined:</p>
            <h2 class="text-2xl font-bold mb-2">August 2023</h2>
            
            <p class="text-xs mb-2 mt-4">Principal:</p>
            <h2 class="text-xs font-bold mb-2">yxaeb-cknlu-ymf7s-hyhv4-ngpus-hurji-roqrb-hcf46-6ed5v-cp3qa-uqe</h2>

        </div>
      </div>
    </div>
  
    <div class="flex flex-wrap -mx-2 mt-4">
      <div class="w-full px-2 mb-4">
        <div class="mt-4 px-2">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
              <div class="flex items-center p-4 rounded-lg shadow-md border border-gray-700">
                <img src="ICPCoin.png" alt="ICP" class="h-12 w-12"/>
                <div class="ml-4">
                  <p class="font-bold">ICP</p>
                  <p>0.00 ICP</p>
                </div>
              </div>
              <div class="flex items-center p-4 rounded-lg shadow-md border border-gray-700">
                <img src="FPLCoin.png" alt="FPL" class="h-12 w-12"/>
                <div class="ml-4">
                  <p class="font-bold">FPL</p>
                  <p>0.00 FPL</p>
                </div>
              </div>
              <div class="flex items-center p-4 rounded-lg shadow-md border border-gray-700">
                <img src="ckBTCCoin.png" alt="ICP" class="h-12 w-12"/>
                <div class="ml-4">
                  <p class="font-bold">ckBTC</p>
                  <p>0.00 ckBTC</p>
                </div>
              </div>
              <div class="flex items-center p-4 rounded-lg shadow-md border border-gray-700">
                <img src="ckETHCoin.png" alt="ICP" class="h-12 w-12"/>
                <div class="ml-4">
                  <p class="font-bold">ckETH</p>
                  <p>0.00 ckETH</p>
                </div>
              </div>
            </div>
          </div>
          
      </div>
    </div>
  </div>
  