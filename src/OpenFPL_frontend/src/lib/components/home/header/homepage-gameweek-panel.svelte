<script lang="ts">
    import { onMount } from "svelte";
    import { managerStore } from "$lib/stores/manager-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { formatWholeE8s } from "$lib/utils/helpers";
    import HeaderContentPanel from "../../shared/panels/header-content-panel.svelte";
    import { rewardRatesStore } from "$lib/stores/reward-pool-store";
    import { globalDataLoaded } from "$lib/managers/store-manager";

    interface Props {
        seasonName: string;
    }
    let { seasonName }: Props = $props();

    let loadingRewardRates = $state(true);
    let loadingManagerCount = $state(true);
    let managerCount = $state(0);
    let weeklyPrizePool = $state("0.0000");

    onMount(() => {
        if (globalDataLoaded) {
            loadManagerCount();
        }
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
    <HeaderContentPanel header="Weekly Prize Pool" content={weeklyPrizePool} footer="$ICFC" loading={false} />
</div>