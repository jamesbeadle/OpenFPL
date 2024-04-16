<script lang="ts">
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
    import CreateLeagueModal from '$lib/components/private-leagues/create-private-league.svelte';
    import type { PrivateLeaguesDTO, PrivateLeagueDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import Layout from '../Layout.svelte';
    
    const leagues = writable<PrivateLeaguesDTO | null>(null);
    const showCreateLeagueModal = writable(false);
  
    function fetchLeagues() {
      const dummyLeagues: PrivateLeagueDTO[] = [
        { canisterId: "1", name: 'OpenFPL Team', memberCount: 10n, seasonPosition: 1n, created: BigInt(Date.now()) },
        { canisterId: "2", name: 'OpenChat', memberCount: 10000n, seasonPosition: 3n, created: BigInt(Date.now()) },
        { canisterId: "3", name: 'Dragginz', memberCount: 5000n, seasonPosition: 2n, created: BigInt(Date.now()) },
        // Add more dummy leagues
      ];

      leagues.set({
        entries: dummyLeagues,
        totalEntries: 2n
      });
    }
  
    function handleCreateLeague() {
      
      // Add league creation logic here
      fetchLeagues();
    }
  
    onMount(() => {
      fetchLeagues();
    });
  </script>

  {#if showCreateLeagueModal}
    <CreateLeagueModal on:createLeague={handleCreateLeague} on:closeModal={() => showCreateLeagueModal.set(false)} />
  {/if}

  <Layout>
    <div class="m-4">
      <div class="bg-panel rounded-md">

        <div class="p-4">
          <div class="p-4 flex justify-end">
            <button class="fpl-button text-white rounded-md p-2" on:click={() => showCreateLeagueModal.set(true)}>
              Create New League
            </button>
          </div>
          <div class="overflow-x-auto">
            <table class="table-auto w-full my-4">
              <thead>
                <tr>
                  <th class="text-left">League Name</th>
                  <th class="text-left">Members</th>
                  <th class="text-left">Season Position</th>
                  <th class="text-left">Options</th>
                </tr>
              </thead>
              <tbody>
                {#if $leagues}
                  {#each $leagues.entries as league (league.canisterId)}
                    <tr class="hover:bg-gray-800 cursor-pointer">
                      <td>{league.name}</td>
                      <td>{league.memberCount}</td>
                      <td>{league.seasonPosition}</td>
                      <td><button class="p-2 text-gray-600 hover:text-gray-800">⋮</button></td>
                    </tr>
                  {/each}
                {:else}
                    <p>You are not a member of any leagues.</p>
                {/if}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </Layout>