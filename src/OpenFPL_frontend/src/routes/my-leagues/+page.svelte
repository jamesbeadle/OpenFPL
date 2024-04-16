<script lang="ts">
    import { onMount } from 'svelte';
    import { writable } from 'svelte/store';
    import CreateLeagueModal from '$lib/components/private-leagues/create-private-league.svelte';
    import type { PrivateLeaguesDTO, PrivateLeagueDTO } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import Layout from '../Layout.svelte';
    
    const leagues = writable<PrivateLeaguesDTO | null>(null);
    const showCreateLeagueModal = writable(false);

    let currentPage = 1;
    const pageSize = 10;
  
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

    function goToPage(page: number) {
      currentPage = page;
    }
  </script>

  {#if showCreateLeagueModal}
    <CreateLeagueModal on:createLeague={handleCreateLeague} on:closeModal={() => showCreateLeagueModal.set(false)} />
  {/if}

  <Layout>
    <div class="m-4">
      <div class="bg-panel rounded-md">

        <div class="py-4">
          <div class="flex justify-between items-center p-4">
            <div>Private Leagues</div>
            <button class="fpl-button text-white rounded-md p-2" on:click={() => showCreateLeagueModal.set(true)}>
              Create New League
            </button>
          </div>
          
          <div class="overflow-x-auto flex-1">
            <div
              class="flex justify-between border border-gray-700 py-2 bg-light-gray border-b border-gray-700 p-4"
            >
              <div class="w-3/6">League Name</div>
              <div class="w-1/6">Members</div>
              <div class="w-1/6">Season Position</div>
              <div class="w-1/6"></div>
            </div>

            {#if $leagues}
              {#each $leagues.entries as league (league.canisterId)}
                <div class="flex items-center justify-between border-b border-gray-700 cursor-pointer p-4">
                  <div class="w-3/6">
                    {league.name}
                  </div>
                  <div class="w-1/6">
                    {league.memberCount}
                  </div>
                  <div class="w-1/6">
                    {league.seasonPosition}
                  </div>
                  <div class="w-1/6 flex justify-center items-center">
                    <button class="rounded fpl-button flex items-center px-4 py-2">
                      View
                    </button>
                  </div>
                </div>
              {/each}

              <div class="justify-center mt-4 overflow-x-auto px-4">
                <div class="flex space-x-1 min-w-max">
                  {#each Array(Math.ceil(Number($leagues.totalEntries) / pageSize)) as _, index}
                    <button
                      class={`px-4 py-2 rounded-md ${
                        index + 1 === currentPage ? "fpl-button" : ""
                      }`}
                      on:click={() => goToPage(index + 1)}
                    >
                      {index + 1}
                    </button>
                  {/each}
                </div>
              </div>
            {:else}
                <p>You are not a member of any leagues.</p>
            {/if}
          </div>
        </div>
      </div>
    </div>
  </Layout>