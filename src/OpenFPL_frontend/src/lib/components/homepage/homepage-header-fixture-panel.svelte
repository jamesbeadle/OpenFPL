
<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { ClubDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import LoadingDots from "../shared/loading-dots.svelte";

    export let nextFixtureHomeTeam: ClubDTO;
    export let nextFixtureAwayTeam: ClubDTO;
    export let loading: boolean;

</script>
{#if loading}
    <div class="flex">
        <LoadingDots />
    </div>
{:else}

    <div class="flex">
        <a 
            class="flex flex-col items-center justify-center"
            href={`/club?id=${nextFixtureHomeTeam.id}`}
        >
            <BadgeIcon
                className="h-4 sm:h-6 my-2 sm:my-4"
                club={nextFixtureHomeTeam}
            />
            <span class="content-panel-header">
                {nextFixtureHomeTeam.abbreviatedName}
            </span>
        </a>
    </div>
    <div class="flex justify-center ml-1 mr-1 w-v">
        <p class="mt-2 mb-2">v</p>
    </div>
    <div class="flex">
        <a
            class="flex flex-col items-center justify-center"
            href={`/club?id=${nextFixtureAwayTeam.id}`}
        >
            <BadgeIcon
                className="h-4 sm:h-6 my-2 sm:my-4"
                club={nextFixtureAwayTeam}
            />
            <span class="content-panel-header">
                {nextFixtureAwayTeam.abbreviatedName}
            </span>
        </a>
    </div>
{/if}