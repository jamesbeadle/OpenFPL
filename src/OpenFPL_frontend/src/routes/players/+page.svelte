<script lang="ts">
    import { onMount } from "svelte";
    import { writable, type Writable } from "svelte/store";
    import { playerStore } from "$lib/stores/player-store";
    import type {
    GetSnapshotPlayersDTO,
      PlayerDTO

    } from "../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import Layout from "../Layout.svelte";
    import { leagueStore } from "$lib/stores/league-store";
    import WidgetSpinner from "$lib/components/shared/widget-spinner.svelte";
    import { toasts } from "$lib/stores/toasts-store";
      
    let isLoading = true;
    let activeSeasonId = 0;
    let selectedGameweek = 0;
    let gameweekPlayers: PlayerDTO[] = [];
    
    onMount(async () => {
        loadPlayers();
    });

    async function loadPlayers(){
        try{
            activeSeasonId = $leagueStore?.activeSeasonId ?? 1;
            selectedGameweek = (($leagueStore?.activeGameweek === 0) ? $leagueStore?.unplayedGameweek: $leagueStore?.activeGameweek) ?? 1;
            gameweekPlayers = await playerStore.getSnapshotPlayers({seasonId: activeSeasonId, gameweek: selectedGameweek});
        } catch {
            toasts.addToast({ type: 'error', message: 'Error fetching snapshot players' });
        } finally {
            isLoading = false;
        }
    }
  </script>
  
  <Layout>
    {#if isLoading}
      <WidgetSpinner />
    {:else}
      <div class="bg-panel">
        {#each gameweekPlayers as player}
            <p>{player.firstName} {player.lastName}</p>
        {/each}
      </div>
    {/if}
  </Layout>