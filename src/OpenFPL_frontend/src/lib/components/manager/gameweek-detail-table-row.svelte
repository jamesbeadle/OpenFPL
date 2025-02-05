<script lang="ts">
    import ActiveCaptainIcon from "$lib/icons/ActiveCaptainIcon.svelte";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import { convertPositionToIndex, getFlagComponent, getPlayerName, getPositionAbbreviation } from "$lib/utils/helpers";
    import type { ClubDTO, PlayerDTO } from "../../../../../declarations/data_canister/data_canister.did";
    import type { GameweekData } from "$lib/interfaces/GameweekData";
    import type { Writable } from "svelte/store";
    import type { ManagerGameweekDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let fantasyTeam: Writable<ManagerGameweekDTO | null>
    export let playerDTO: PlayerDTO;
    export let data: GameweekData;
    export let playerTeam: ClubDTO;

</script>
<div class="flex items-center p-2 justify-between py-4 border-b border-gray-700 cursor-pointer 
    {$fantasyTeam!.captainId == playerDTO?.id ? 'captain-row' : ''}">
    <div class="w-1/12 text-center items-center justify-center flex">
        {#if $fantasyTeam!.captainId == playerDTO?.id}
            <ActiveCaptainIcon className="w-5 sm:w-6 md:w-7" />
        {:else}
            {getPositionAbbreviation(
                convertPositionToIndex(data.player.position)
            )}
        {/if}
    </div>
    <div class="w-2/12 flex items-center">
        <svelte:component
            this={getFlagComponent(data.player.nationality)}
            class="w-4 h-4 mr-1 hidden md:flex"
            size="100"
        />
        <span class="flex items-center">
            <BadgeIcon club={playerTeam} className="w-4 h-4 mr-1 md:hidden" />
            <p class="truncate min-w-[30px] max-w-[30px] xs:min-w-[50px] xs:max-w-[50px] sm:min-w-[60px] sm:max-w-[60px] md:min-w-[75px] md:max-w-[75px]">
                {getPlayerName(playerDTO)}
            </p>
        </span>
    </div>
    <div class="w-1/12 hidden lg:flex text-center">
        <a href="/club?id={playerTeam.id}" class="flex items-center">
            <BadgeIcon club={playerTeam} className="w-4 h-4 mr-2 hidden md:flex" />
            <span class="hidden md:flex">
                {playerTeam?.abbreviatedName}
            </span>
        </a>
    </div>
    <div class="w-1/2 xxs:w-7/12 lg:7/12 flex">
        <div class={`w-1/12 text-center ${ data.appearance > 0 ? "" : "text-gray-500" }`}>
        {data.appearance}
        </div>
        <div class={`w-1/12 text-center ${ data.highestScoringPlayerId > 0 ? "" : "text-gray-500" }`}>
        {data.highestScoringPlayerId}
        </div>
        <div class={`w-1/12 text-center ${ data.goals > 0 ? "" : "text-gray-500" }`}>
        {data.goals}
        </div>
        <div class={`w-1/12 text-center ${ data.assists > 0 ? "" : "text-gray-500" }`}>
        {data.assists}
        </div>
        <div class={`w-1/12 text-center ${ data.penaltySaves > 0 ? "" : "text-gray-500" }`}>
        {data.penaltySaves}
        </div>
        <div class={`w-1/12 text-center ${ data.cleanSheets > 0 ? "" : "text-gray-500"}`}>
        {data.cleanSheets}
        </div>
        <div class={`w-1/12 text-center ${ data.saves > 0 ? "" : "text-gray-500" }`}>
        {data.saves}
        </div>
        <div class={`w-1/12 text-center ${ data.yellowCards > 0 ? "" : "text-gray-500" }`}>
        {data.yellowCards}
        </div>
        <div class={`w-1/12 text-center ${ data.ownGoals > 0 ? "" : "text-gray-500" }`}>
        {data.ownGoals}
        </div>
        <div class={`w-1/12 text-center ${ data.goalsConceded > 0 ? "" : "text-gray-500"}`}>
        {data.goalsConceded}
        </div>
        <div class={`w-1/12 text-center ${ data.redCards > 0 ? "" : "text-gray-500" }`}>
        {data.redCards}
        </div>
        <div class={`w-1/12 text-center ${ data.bonusPoints > 0 ? "" : "text-gray-500"}`}>
        {data.bonusPoints}
        </div>
    </div>
    <div class={`w-1/12 text-center ${ $fantasyTeam!.captainId == playerDTO?.id ? "" : "text-gray-500" }`}>
    {$fantasyTeam!.captainId == playerDTO?.id ? data.points : "-"}
    </div>
    <div class="w-1/12 text-center">{data.totalPoints}</div>
</div>