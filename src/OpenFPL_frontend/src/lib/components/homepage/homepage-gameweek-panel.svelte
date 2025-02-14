<script lang="ts">
    import { onMount } from "svelte";
    import { managerStore } from "$lib/stores/manager-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { formatWholeE8s } from "$lib/utils/helpers";
    import HeaderContentPanel from "../shared/panels/header-content-panel.svelte";
    import { rewardRatesStore } from "$lib/stores/reward-pool-store";
    import { globalDataLoaded } from "$lib/managers/store-manager";

    export let seasonName: string;

    let loadingRewardRates = true;
    let loadingManagerCount = true;
    let managerCount = 0;
    let weeklyPrizePool = "0.0000";

    onMount(() => {
        let unsub: () => void = () => {};
        unsub = globalDataLoaded.subscribe((loaded) => {
            if (loaded) {
                loadManagerCount();
                unsub();
            }
        });
        rewardRatesStore.subscribe(rewardRates => {
            if(!rewardRates) {return};
            weeklyPrizePool = formatWholeE8s(BigInt(Math.round(Number(rewardRates.weeklyLeaderboardRewardRate)))).toString();
            loadingRewardRates = false;
        });
    });
        
    async function loadManagerCount(): Promise<void> {
        managerCount = await managerStore.getTotalManagers();
        loadingManagerCount = false;
    }
</script>

<HeaderContentPanel 
    header="Gameweek" 
    content={(($leagueStore?.activeGameweek === 0 ? $leagueStore?.unplayedGameweek: $leagueStore?.activeGameweek) || 0).toString()}
    footer={seasonName} 
    loading={loadingRewardRates} 
/>
<div class="vertical-divider"></div>
<div class="flex-grow">
    <HeaderContentPanel header="Managers" content={managerCount.toString()} footer="Total" loading={loadingManagerCount} />
</div>
<div class="vertical-divider"></div>
<div class="flex-grow">
    <HeaderContentPanel header="Weekly Prize Pool" content={weeklyPrizePool} footer="$FPL" loading={false} />
</div>