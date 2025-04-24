<!--
    // TODO
    Season Filter
    Gameweek filter
    Table of players
        Fixture
        Points
        Amount
        Amount per user
-->
<script lang="ts">
    import GameweekFilter from "../shared/filters/gameweek-filter.svelte";
    import SeasonFilter from "../shared/filters/season-filter.svelte";
    import LocalSpinner from "../shared/global/local-spinner.svelte";
    import GameweekMvpList from "./mvps/gameweek-mvp-list.svelte";


</script>
{#if isLoading}
    <LocalSpinner />
    <p class="pb-4 mb-4 text-center">Getting Most Valuable Player Leaderboard for Gameweek {selectedGameweek}</p>
{:else}
    <div class="flex flex-col">

        <SeasonFilter {selectedSeasonId} />
        <GameweekFilter {selectedGameweek} />
        <GameweekMvpList {mvps} {fixture} />
    </div>
{/if}