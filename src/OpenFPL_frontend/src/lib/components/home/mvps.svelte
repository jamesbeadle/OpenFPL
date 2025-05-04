
<script lang="ts">
    import { onMount } from "svelte";
    import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
    import SeasonFilter from "../shared/filters/season-filter.svelte";
    import LocalSpinner from "../shared/global/local-spinner.svelte";
    import GameweekMvpList from "./mvps/gameweek-mvp-list.svelte";
    import { storeManager } from "$lib/managers/store-manager";
    import { leagueStore } from "$lib/stores/league-store";
    import type { MostValuableGameweekPlayers, MostValuablePlayer } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import { mvpStore } from "$lib/stores/mvp-store";

    let isLoading = $state(true);
    let selectedSeasonId = $state(1);
    let selectedGameweek = $state(1);
    let mostValuableGameweekPlayers: MostValuableGameweekPlayers | undefined = $state(undefined);
    
    onMount(async () => {
      await storeManager.syncStores();
      selectedSeasonId = $leagueStore!.activeSeasonId;
      selectedGameweek = $leagueStore!.completedGameweek;
      isLoading = false;
    });

    $effect(() => {
        if(selectedSeasonId == 0 || selectedGameweek == 0) { return }
        loadMostValuableGameweekPlayers();
    })

    async function loadMostValuableGameweekPlayers(){
        let mvpsResult = await mvpStore.getMostValuableGameweekPlayers({
            seasonId: selectedSeasonId,
            gameweek: selectedGameweek
        });
        if(!mvpsResult){ return }
        mostValuableGameweekPlayers = mvpsResult;
    }

</script>
{#if isLoading}
    <LocalSpinner />
    <p class="pb-4 mb-4 text-center">Getting Most Valuable Player Leaderboard for Gameweek {selectedGameweek}</p>
{:else}
    {#if mostValuableGameweekPlayers}
        <div class="flex flex-col">

            <SeasonFilter {selectedSeasonId} />
            <GameweekFilter {selectedGameweek} />
            <GameweekMvpList mvps={mostValuableGameweekPlayers.entries} />
        </div>
    {:else}
        <p>Could not find most valuable players for gameweek.</p>
    {/if}
{/if}