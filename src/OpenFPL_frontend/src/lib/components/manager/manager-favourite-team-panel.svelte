<script lang="ts">
    import BadgeIcon from "$lib/icons/BadgeIcon.svelte";
    import type { Writable } from "svelte/store";
    import type { Club } from "../../../../../declarations/OpenFPL_backend/OpenFPL_backend.did";

    export let favouriteTeam: Writable<Club | null>;
</script>
<div class="flex-grow">
    <p class="content-panel-header">Favourite Team</p>
    {#if $favouriteTeam}
        <p class="flex items-center content-panel-stat">
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