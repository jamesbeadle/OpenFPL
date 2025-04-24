
<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Club } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import LoadingDots from "../../shared/loading-dots.svelte";

    interface Props {
        nextFixtureHomeTeam: Club;
        nextFixtureAwayTeam: Club;
        loading: boolean;
    }
    let { nextFixtureHomeTeam, nextFixtureAwayTeam, loading }: Props = $props();

</script>
{#if loading}
    <div class="flex">
        <LoadingDots />
    </div>
{:else}

    <div class="flex flex-col">
        <a 
            class="flex flex-row items-center" 
            href={`/club?id=${nextFixtureHomeTeam.id}`}
        >
            <BadgeIcon className="header-badge" club={nextFixtureHomeTeam} />
            <span class="content-panel-header">
                {nextFixtureHomeTeam.friendlyName}
            </span>
        </a>
        <a
        class="flex flex-row items-center" 
            href={`/club?id=${nextFixtureAwayTeam.id}`}
        >
            <BadgeIcon className="header-badge" club={nextFixtureAwayTeam} />
            <span class="content-panel-header">
                {nextFixtureAwayTeam.friendlyName}
            </span>
        </a>
    </div>
{/if}