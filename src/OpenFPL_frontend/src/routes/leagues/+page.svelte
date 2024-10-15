<script lang="ts">
    import { onMount } from "svelte";
    import { toastsError } from "$lib/stores/toasts-store";
    import { leagueStore } from "$lib/stores/league-store";
    import Layout from "../Layout.svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { getImageURL } from "$lib/utils/helpers";
    import { userStore } from "$lib/stores/user-store";
    import AddLeagueModal from "$lib/components/admin/league/add-league-modal.svelte";

    let isAdmin = false; 
    let showAddLeague = false;
  
    onMount(async () => {
      try {
        await storeManager.syncStores();
        isAdmin = await userStore.isAdmin();
      } catch (error) {
        toastsError({
          msg: { text: "Error fetching leagues." },
          err: error,
        });
        console.error("Error fetching leagues:", error);
      } finally {
      }
    });

    async function closeModal(){
      await storeManager.syncStores();
      showAddLeague = false;
    }
  </script>
  
  <Layout>
    <div class="page-header-wrapper flex w-full">
      <div class="content-panel w-full flex flex-col">
        <div class="flex justify-between items-center w-full mb-4">
          <p class="text-lg font-bold">Leagues</p>
          {#if isAdmin}
            <button
              class="fpl-button text-white font-bold py-2 px-4 rounded bg-blue-500 hover:bg-blue-600"
              on:click={() => { showAddLeague = true ;}}
            >
              Add New
            </button>
          {/if}
        </div>
        {#each $leagueStore.sort((a, b) => a.id - b.id) as league}
            <div class="flex flex-row items-center bg-gray-700 rounded shadow p-4 w-full my-2">
                <div class="flex items-center space-x-4 w-full">
                    <img
                        src={getImageURL(league.logo)}
                        class="w-8"
                        alt="logo"
                    />
                    <p class="flex-grow text-lg md:text-sm">{league.name}</p>
                    <a class="mt-auto self-end" href={`/league?id=${league.id}`}>
                        <button
                        class="fpl-button text-white font-bold py-2 px-4 rounded self-end"
                        >
                        View
                        </button>
                    </a>
                </div>
            </div>
        {/each}
      </div>
    </div>
  </Layout>
  
  {#if showAddLeague}
    <AddLeagueModal visible={showAddLeague} {closeModal} cancelModal={closeModal} />
  {/if}