<script lang="ts">
  import { onMount } from "svelte";
  import type { SnapshotPlayer } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerStore } from "$lib/stores/player-store";
  import {toastsStore } from "$lib/stores/toasts-store";
  import SeasonFilter from "$lib/components/shared/filters/season-filter.svelte";
  import GameweekFilter from "$lib/components/shared/filters/gameweek-filter.svelte";
  import PlayerDetailRow from "$lib/components/player/player-detail-row.svelte";
  
  let isLoading = $state(true);
  let selectedSeasonId = $state(0);
  let selectedGameweek = $state(0);
  let gameweekPlayers: SnapshotPlayer[] = $state([]);

  onMount(async () => {
    try{
        await storeManager.syncStores();
        selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.completedGameweek : $leagueStore!.activeGameweek ?? 1;
        selectedSeasonId = $leagueStore?.activeSeasonId ?? 0;
        loadPlayers();
      } catch {
        toastsStore.addToast({type: 'error', message: 'Error loading active season information'});
      } finally {
        isLoading = false;
      }
  });

  $effect(() => {
    if(selectedSeasonId > 0 && selectedGameweek > 0){
      loadPlayers();
    }
  })

  async function loadPlayers() {
    try {
      isLoading = true;
      let snapshotResult = await playerStore.getSnapshotPlayers({
        seasonId: selectedSeasonId,
        gameweek: selectedGameweek
      });

      if(!snapshotResult) {return};
    
      gameweekPlayers = snapshotResult.players;
    } catch {
      toastsStore.addToast({ type: 'error', message: 'Error loading gameweek players'});
    } finally {
      isLoading = false;
    }
  }

</script>

<SeasonFilter {selectedSeasonId} />
<GameweekFilter {selectedGameweek} />

<div class="flex w-full flex-col">
  {#each gameweekPlayers as snapshotPlayer}
  {@const player = $playerStore.find(x => x.id == snapshotPlayer.id)!}
    <PlayerDetailRow {player} />
  {/each}
</div>