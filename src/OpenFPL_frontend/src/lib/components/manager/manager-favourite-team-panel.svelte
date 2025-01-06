<script lang="ts">
    import type { ClubDTO } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Writable } from "svelte/store";

    export let favouriteTeam: Writable<ClubDTO | null>;
</script>
<div class="flex-grow">
    <p class="content-panel-header">Favourite Team</p>
    {#if $favouriteTeam}
        <p class="content-panel-stat flex items-center">
            <BadgeIcon className="w-7 mr-2" club={$favouriteTeam} />
            {$favouriteTeam.abbreviatedName ?? "-"}
        </p>
        <p class="content-panel-header">
          {$favouriteTeam.name}
        </p>
    {:else}
        <p class="content-panel-header">
            Not Set
        </p>
    {/if}
</div>