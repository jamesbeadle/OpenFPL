<script lang="ts">
    import { onMount } from "svelte";
    import { fixtureStore } from "$lib/stores/fixture-store";
    import { clubStore } from "$lib/stores/club-store";
    import { globalDataLoaded } from "$lib/managers/store-manager";
    import { formatUnixDateToSmallReadable, formatUnixTimeToTime, getCountdownTime } from "../../utils/helpers";
    import HeaderCountdownPanel from "../shared/panels/header-countdown-panel.svelte";
    import HeaderFixturePanel from "./homepage-header-fixture-panel.svelte";
    import LoadingDots from "../shared/loading-dots.svelte";
    import type { Club, Fixture } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    let loadingNextFixture = true;
    let noNextFixture = false;
    let nextFixture: Fixture;
    let countdownTime: { days: number; hours: number; minutes: number; };
    let nextFixtureHomeTeam: Club;
    let nextFixtureAwayTeam: Club;

    onMount(() => {
        let unsub: () => void = () => {};
        unsub = globalDataLoaded.subscribe((loaded) => {
            if (loaded) {
            loadNextFixture();
            unsub();
            }
        });
    });

    async function loadNextFixture(): Promise<void> {
        let nextFixtureResult = await fixtureStore.getNextFixture();
            
        if(!nextFixtureResult){
            noNextFixture = true;
            return;
        }
        nextFixture = nextFixtureResult;
        
        nextFixtureHomeTeam = $clubStore.find(x => x.id == nextFixture.homeClubId)!;
        nextFixtureAwayTeam = $clubStore.find(x => x.id == nextFixture.awayClubId)!;
        countdownTime = getCountdownTime(nextFixture.kickOff);
        loadingNextFixture = false;
    }

</script>

{#if loadingNextFixture}
    <LoadingDots />
{:else}
    <div class="flex items-center justify-start mb-2 ml-1">
        {#if loadingNextFixture}
            <LoadingDots />
        {:else}
            {#if noNextFixture}
                <p>No fixtures for the season have been announced.</p>
            {:else}
                <HeaderCountdownPanel loading={loadingNextFixture} {countdownTime} header="Upcoming Fixture" footer={`${formatUnixDateToSmallReadable(nextFixture.kickOff).toString()} ${formatUnixTimeToTime(nextFixture.kickOff)}`} />
                <div class="vertical-divider"></div>
                <HeaderFixturePanel loading={loadingNextFixture} {nextFixtureHomeTeam} {nextFixtureAwayTeam}  />
            {/if}
        {/if}
    </div>
{/if}