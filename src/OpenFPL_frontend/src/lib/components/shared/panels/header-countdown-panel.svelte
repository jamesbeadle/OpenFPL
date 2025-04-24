<script lang="ts">
    import LoadingDots from "../global/loading-dots.svelte";
    
    interface Props {
        countdownTime: { days: number; hours: number; minutes: number; }
        header: string;
        footer: string;
        loading: boolean;
    }
    let { header, countdownTime, footer, loading }: Props = $props();

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