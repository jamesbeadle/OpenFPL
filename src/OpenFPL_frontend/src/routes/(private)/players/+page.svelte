<script lang="ts">
  import { onMount } from "svelte";
  import type { Player } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
  import { storeManager } from "$lib/managers/store-manager";
  import { leagueStore } from "$lib/stores/league-store";
  import { playerStore } from "$lib/stores/player-store";
  import { toasts } from "$lib/stores/toasts-store";
  import SeasonFilter from "$lib/components/shared/filters/season-filter.svelte";
  import GameweekFilter from "$lib/components/shared/filters/gameweek-filter.svelte";
  
  let isLoading = $state(true);
  let selectedSeasonId = $state(0);
  let selectedGameweek = $state(0);
  let gameweekPlayers: Player[] = $state([]);

  onMount(async () => {
    try{
        await storeManager.syncStores();
        selectedGameweek = $leagueStore!.activeGameweek == 0 ? $leagueStore!.completedGameweek : $leagueStore!.activeGameweek ?? 1;
        selectedSeasonId = $leagueStore?.activeSeasonId ?? 0;
        loadPlayers();
      } catch {
        toasts.addToast({type: 'error', message: 'Error loading active season information'});
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
      toasts.addToast({ type: 'error', message: 'Error loading gameweek players'});
    } finally {
      isLoading = false;
    }
  }

</script>

<SeasonFilter {selectedSeasonId} />
<GameweekFilter {selectedGameweek} />

<div class="flex w-full flex-col">
  {#each gameweekPlayers as player}
    <p>{player.firstName} {player.lastName}</p>
  {/each}
</div>