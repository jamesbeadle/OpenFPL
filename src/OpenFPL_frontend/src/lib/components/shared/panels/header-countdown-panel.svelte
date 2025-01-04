<script lang="ts">
    import LoadingDots from "../loading-dots.svelte";

    export let countdownDays: number;
    export let countdownHours: number;
    export let countdownMinutes: number;
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
            {countdownDays}<span class="countdown-text">d</span>
            : {countdownHours}<span class="countdown-text">h</span>
            : {countdownMinutes}<span class="countdown-text">m</span>
            </p>
        </div>
    {/if}
    <p class="content-panel-header">
      {footer}
    </p>
</div>