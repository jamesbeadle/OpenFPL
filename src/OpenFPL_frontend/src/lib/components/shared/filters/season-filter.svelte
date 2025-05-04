<script lang="ts">
    import { seasonStore } from "$lib/stores/season-store";
    import type { SeasonId } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    interface Props {
        selectedSeasonId: SeasonId;
    }
    let { selectedSeasonId }: Props = $props();

</script>

<div class="flex w-full flex-col">
    <p class="input-header">Select Season:</p>
    <select class="fpl-dropdown" value={selectedSeasonId}>
        {#each $seasonStore as season}
            <option value={season.id}>{season.name}</option>
        {/each}
    </select>
</div>