<script lang="ts">
    import LoadingDots from "../loading-dots.svelte";
    export let countdownTime: { days: number; hours: number; minutes: number; };
    export let header: string;
    export let footer: string;
    export let loading: boolean;
</script>

<div class="flex-grow">
    <p class="content-panel-header">{header}</p>
    {#if loading}
        <LoadingDots />
    {:else}
        <div class="flex">
            <p class="content-panel-stat">
            {#if loading || countdownTime == undefined}
                <LoadingDots />
            {:else}
                {countdownTime.days}<span class="countdown-text">d</span>
                : {countdownTime.hours}<span class="countdown-text">h</span>
                : {countdownTime.minutes}<span class="countdown-text">m</span>
            {/if}
            </p>
        </div>
    {/if}
    <p class="content-panel-header">
      {footer}
    </p>
</div>