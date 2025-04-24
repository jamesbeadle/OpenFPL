<script lang="ts">
    interface Props {
        fixtureStatus: string;
    }
    let { fixtureStatus }: Props = $props();
</script>

{#if fixtureStatus == "Unplayed"}
    <div class="unplayed-divider"></div>
{/if}

{#if fixtureStatus == "Active"}
    <div class="active-divider"></div>
{/if}

{#if fixtureStatus == "Complete"}
    <div class="complete-divider"></div>
{/if}

{#if fixtureStatus == "Finalised"}
    <div class="finalised-divider"></div>
{/if}