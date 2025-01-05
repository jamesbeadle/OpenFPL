<script lang="ts">
    import { onMount } from "svelte";
    import { managerStore } from "$lib/stores/manager-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { formatWholeE8s } from "$lib/utils/helpers";
    import HeaderContentPanel from "../shared/panels/header-content-panel.svelte";
    import { rewardPoolStore } from "$lib/stores/reward-pool-store";

    export let seasonName: string;

    let loadingRewardPool = true;
    let loadingManagerCount = true;
    let managerCount = 0;
    let weeklyPrizePool = "0.0000";

    onMount(() => {
        loadManagerCount();
        rewardPoolStore.subscribe(rewardPool => {
            if(!rewardPool) {return};
            weeklyPrizePool = formatWholeE8s(BigInt(Math.round(Number(rewardPool.weeklyLeaderboardPool) * 100_000_000 / 38))).toString();
            loadingRewardPool = false;
        });
    });
        
    async function loadManagerCount(): Promise<void> {
        managerCount = await managerStore.getTotalManagers();
        loadingManagerCount = false;
    }
</script>

<HeaderContentPanel header="Gameweek" content={($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore! .activeGameweek ).toString()} footer={seasonName} loading={loadingRewardPool} />
<div class="vertical-divider"></div>
<div class="flex-grow">
    <HeaderContentPanel header="Managers" content={managerCount.toString()} footer="Total" loading={loadingManagerCount} />
</div>
<div class="vertical-divider"></div>
<div class="flex-grow">
    <HeaderContentPanel header="Weekly Prize Pool" content={weeklyPrizePool} footer="$FPL" loading={false} />
</div>