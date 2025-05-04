<script lang="ts">
    import { clubStore } from "$lib/stores/club-store";
    import type { ClubId } from "../../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    interface Props {
        selectedClubId: ClubId;
    }
    let { selectedClubId }: Props = $props();

</script>

<div class="flex w-full flex-col">
    <p class="input-header">Select Club:</p>
    <select class="fpl-dropdown" value={selectedClubId}>
        {#each $clubStore as club}
            <option value={club.id}>{club.friendlyName}</option>
        {/each}
    </select>
</div>