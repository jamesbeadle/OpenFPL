<script lang="ts">
    import LoadingDots from "../global/loading-dots.svelte";
    
    interface Props {
        countdownTime: { days: number; hours: number; minutes: number; }
        header: string;
        footer: string;
    }
    let { header, countdownTime, footer }: Props = $props();

</script>

<div class="flex-grow">
    <p class="content-panel-header">{header}</p>
    <div class="flex">
        <p class="content-panel-stat">
            {countdownTime.days}<span class="countdown-text">d</span>
            : {countdownTime.hours}<span class="countdown-text">h</span>
            : {countdownTime.minutes}<span class="countdown-text">m</span>
        </p>
    </div>
    <p class="content-panel-header">
      {footer}
    </p>
</div>