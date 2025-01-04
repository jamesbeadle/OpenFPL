<script lang="ts">
    import { onMount } from "svelte";
    import { managerStore } from "$lib/stores/manager-store";
    import { leagueStore } from "$lib/stores/league-store";
    import { weeklyLeaderboardStore } from "$lib/stores/weekly-leaderboard-store";
    import { formatE8s } from "$lib/utils/helpers";
    import HeaderContentPanel from "../shared/panels/header-content-panel.svelte";

    export let seasonId: number;
    export let gameweek: number;
    export let seasonName: string;

    let loadingManagerCount = true;
    let loadingWeeklyPrizePool = true;
    let managerCount = 0;
    let weeklyPrizePool = 0n;

    onMount(() => {
        loadManagerCount();
        loadWeeklyPrizePool();
    });
        
    async function loadManagerCount(): Promise<void> {
        managerCount = await managerStore.getTotalManagers();
        loadingManagerCount = false;
    }

    async function loadWeeklyPrizePool(): Promise<void> {
        let rewardsDTO = await weeklyLeaderboardStore.getWeeklyRewards(seasonId, gameweek);
        if(!rewardsDTO){
            return;
        }
        
        let gameweekRewards = rewardsDTO.rewards.find(x => Object.keys(x.rewardType)[0] == "WeeklyLeaderboard");    
        if(!gameweekRewards){
            return
        }

        weeklyPrizePool = gameweekRewards.amount;
        loadingWeeklyPrizePool = false;
    }
</script>

<HeaderContentPanel header="Gameweek" content={($leagueStore!.activeGameweek == 0 ? $leagueStore!.unplayedGameweek : $leagueStore! .activeGameweek ).toString()} footer={seasonName} loading={false} />
<div class="vertical-divider"></div>
<div class="flex-grow">
    <HeaderContentPanel header="Managers" content={managerCount.toString()} footer="Total" loading={loadingManagerCount} />
</div>
<div class="vertical-divider"></div>
<div class="flex-grow">
    <HeaderContentPanel header="Weekly Prize Pool" content={formatE8s(weeklyPrizePool).toString()} footer="$FPL" loading={loadingWeeklyPrizePool} />
</div>